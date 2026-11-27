#import "../../lib.typ": *
= Chapter 5. Caching

#tag[●] What a cache is and the basic patterns. #tag[◐] Hit-ratio maths and stampedes. #tag[◆] Consistency races and cold-start risk.

#callout("predict")[
A database query takes 20 ms. A cache lookup takes 1 ms. If *90%* of requests hit the cache, what is the average time per request? And what happens to the _database's_ load if the cache is suddenly emptied?

#lines(4)
]

== 5.1 The idea

A *cache* keeps a copy of data in a place that is faster or cheaper to reach than the original source. It works because access is usually *uneven*: a small portion of the data gets most of the requests (a viral listing, today's popular tools).

A cache trades three things: *freshness* (the copy can be out of date), *memory cost*, and *complexity* (you now have two places that hold the answer). Use one when reads are far more common than writes, the data tolerates some staleness, and the source is slow or expensive.

#callout("keyidea")[
*A cache is an optimisation, not a source of truth.* If the system is _incorrect_ without the cache, you have built a database and called it a cache. Design so that losing the cache makes things slower, never wrong.
]

== 5.2 Where caches live

From closest to the user to closest to the data:

#table(columns: (28fr, 48fr, 34fr, 34fr),
  [*Layer*], [*What it caches*], [*Who controls it*], [*Staleness risk*],
  [Browser / app], [Responses, images, assets], [Your response headers], [Hard to purge; plan expiry],
  [CDN / edge], [Static and some API responses], [Your headers and purge calls], [Medium],
  [Application in-process], [Hot objects inside each server], [Your code], [Each server may differ],
  [Distributed cache], [Shared in-memory store used by all servers], [Your code], [Depends on your invalidation],
  [Database internal], [Recently read pages and query plans], [The database], [Transparent to you],
)

More layers help speed, but make "why am I seeing old data?" harder to answer. Know which layers exist before you debug.

== 5.3 Patterns for reads and writes

#table(columns: (36fr, 61fr, 44fr, 61fr),
  [*Pattern*], [*How it works*], [*Good for*], [*Risk*],
  [*Cache-aside* (lazy loading)], [App checks cache; on miss, reads database, then stores in cache], [General reads; the usual default], [Cold start; stale data after writes],
  [*Read-through*], [Cache itself loads from the source on a miss], [Simpler app code], [Less control; cache library must know the source],
  [*Write-through*], [Write goes to cache and database together], [Reads right after writes must be fresh], [Slower writes; cache fills with data never read],
  [*Write-back* (write-behind)], [Write goes to cache, database updated later], [Very high write rates], [Data loss if cache fails before flush; *needs durability thinking*],
  [*Write-around*], [Writes go to the database only; reads populate the cache], [Data written once, rarely re-read], [First read after write is a miss],
)

Default to *cache-aside with a time-to-live (TTL)*. It is simple, and TTLs bound how wrong the cache can ever be.

== 5.4 The maths of a hit ratio

If a cache lookup takes `t_cache` and a miss goes on to the source at `t_db`, then:

#block(stroke: (left: 2pt + black), inset: (left: 3mm, y: 1mm), width: 100%)[*average latency = t\_cache + (1 - h) × t\_db*, where _h_ is the hit ratio.]

#callout("worked")[
*PorchLend "popular tools near you" list.* `t_cache` = 1 ms, `t_db` = 20 ms.

#table(columns: (18fr, 38fr, 51fr),
  [*Hit ratio h*], [*Average latency*], [*Requests reaching the database (of 1,000 rps)*],
  [0 (no cache)], [20 ms], [1,000],
  [0.80], [1 + 0.2 × 20 = *5 ms*], [200],
  [0.90], [1 + 0.1 × 20 = *3 ms*], [100],
  [0.99], [1 + 0.01 × 20 = *1.2 ms*], [10],
)

Going from 90% to 99% barely changes the average (3 ms to 1.2 ms) but cuts database load tenfold (100 to 10 requests per second). *Hit ratio is about protecting the database, not just speed.*

_(Predict-box answer: about 3 ms. And if the cache is emptied, database load jumps from 100 to 1,000 rps: ten times. At 99%, an empty cache means a hundredfold jump, from 10 to 1,000.)_
]

#callout("keyidea")[
*The better your hit ratio, the more your database depends on it.* A 99% hit ratio means the database is sized for 1% of traffic. If the cache disappears, the database sees 100x its normal load and falls over. High hit ratios make _cold starts and cache failures_ the main risk.
]

== 5.5 Invalidation: the hard part

You have three ways to keep a cache honest:

1. *Expire* it: set a TTL. Simple, predictable, and the data is stale for at most the TTL.
2. *Update or delete it when the source changes*: fresher, but you must find _every_ cache entry affected by a change.
3. *Version the key*: include a version in the key (`tool:42:v7`). Old keys simply stop being used. Excellent for static assets and snapshots.

Decide *how stale is acceptable per kind of data*, not globally. A tool's _availability_ is sensitive (seconds); its _description_ is not (hours); the _popular tools list_ can be minutes old.

#callout("pitfall")[
*Caching the "not found" result forever.* If a lookup for a missing item is not cached, an attacker or a buggy client can hammer the database with misses. If it is cached with no expiry, a newly created item stays "missing". Cache negatives briefly (seconds to a minute).
]

#callout("mid")[
*Cache stampede (thundering herd).* A popular entry expires. In the next 100 ms, 2,000 requests all miss and all query the database for the same thing. Defences:

- *Request coalescing:* only one request per key reloads; others wait for it.
- *Jittered TTLs:* add random variation (say 10%) so many entries do not expire at once.
- *Serve stale while revalidating:* return the old value and refresh in the background.
- *Warm the cache* before a launch or after a restart.

*What to cache:* results that are expensive and reused. Do not cache things nobody asks for twice, and do not cache huge items that evict many small ones. Use an eviction policy (commonly "least recently used") and watch the eviction rate.
]

#callout("deepen")[
*Cache-aside has a race.* Request A reads a stale value from the database, request B updates the database and deletes the cache entry, then A writes its stale value into the cache. Now the cache is wrong _until the TTL_. Mitigations: short TTLs, versioned writes (compare a version number before overwrite), or serialising updates per key. Accept the risk where staleness is harmless; do not accept it for money or availability.

*Cold-start and brown-out planning.* Ask: _what is the database's capacity at 0% hit ratio?_ If it cannot survive, you need rate limiting, load shedding, gradual cache warming, or a second cache tier. Capacity planning that assumes the cache always works is a hidden single point of failure.

*Hot keys.* One entry (a viral listing) can exceed what a single cache node serves, even when the cluster has spare capacity. Replicate that key, keep a short-lived copy in each app server, or split it.

*Consistent hashing* is how many distributed caches spread keys so that adding a node moves only a fraction of keys. (Chapter 7.)

*Real-world scale cases are worth reading.* The Facebook "Scaling Memcache" paper (NSDI 2013) describes lease mechanisms against stale sets and stampedes, and regional replication. Read it for the _problems_, not as a recipe to copy.
]

#callout("interview")[
Never say "add a cache" without also saying *what key, what expiry, how it is invalidated, and what happens when it is empty*. Interviewers reward candidates who raise the failure mode (stampede, cold start) before being asked.
]

#checks-block((
  [Compute average latency and database load for h = 0.95, `t_cache` = 2 ms, `t_db` = 40 ms, 5,000 rps.],
  [Why can a 99% hit ratio be _more dangerous_ than a 90% one?],
  [Give one case where write-back caching is a bad idea and one where it fits.],
  [Why does setting every entry's TTL to exactly 5 minutes cause trouble?],
  [State, in the Chapter 1 form, whether PorchLend should cache the owner's rating average.],
))


#interview-round(5, "Add a cache, then break it",
  "Search is slow at the evening peak (2,000 read requests per second). The database answers in 40 ms and tolerates 300 queries per second. Would you add a cache? Where, and for what?",
  clarify: 3,
  est-title: "Hit-ratio maths (cache lookup 2 ms, database 40 ms)",
  est-cols: ("Quantity", "Calculation", "Result"),
  est-rows: ("DB load at 90% hit ratio", "DB load at 95% hit ratio", "Average latency at 95%", "Minimum hit ratio for DB <= 300 rps", "DB load if the cache empties"),
  row-h: 5mm,
  sketch-h: 38mm, trade-rows: 3,
  twist: "The cache cluster restarts at the peak and every entry is lost. Walk me through the next ten minutes, and say what you would have built to survive it.",
  twist-lines: 3)

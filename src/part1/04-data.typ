#import "../../lib.typ": *
= Chapter 4. Choosing where data lives

#tag[●] Store types and when each fits. #tag[◐] How storage engines work. #tag[◆] Partitioning, hot keys and exit costs.

#callout("predict")[
PorchLend stores: (a) user accounts, (b) tool listings, (c) photos, (d) loan requests and their status, (e) search history, (f) a "people who borrowed this also borrowed" list. For each, write *which kind of store* you would use and *one reason*.

#lines(4)
]

== 4.1 Start from the questions, not the technology

The right store is the one that answers your *most frequent and most important questions* well. So the first step is to write down the *access patterns*: what do we read and write, how often, how fast, and how correct must it be?

On paper, list the queries by frequency. The top two or three decide the design. A store that is excellent for something you do once a day is the wrong choice if it is poor at what you do 100 times a second.

#callout("keyidea")[
*Model data for how it is read.* If your most common question is "show me available tools within 2 km of this point, newest first", then _that query_ is the design target, not the entities in your head.
]

== 4.2 A tour of store types

#table(columns: (29fr, 55fr, 61fr, 61fr),
  [*Type*], [*Shape*], [*Fits when*], [*Breaks when*],
  [*Relational (SQL)*], [Tables, rows, joins, transactions], [Related data, strong correctness needs, ad hoc queries, moderate scale], [One machine cannot hold or write the load, and joins across machines get expensive],
  [*Key-value*], [Look up a value by key], [Simple get/put at high speed and scale; sessions, counters, caches], [You need to query by anything other than the key],
  [*Document*], [Self-contained JSON-like records], [Records are read and written as a whole; schema changes often], [You need many cross-record joins or multi-record transactions],
  [*Wide-column*], [Rows with many sparse columns, partitioned by key], [Huge write volumes, predictable key-based access, time-ordered data], [Ad hoc queries; you must design tables per query up front],
  [*Graph*], [Nodes and relationships], [Relationship traversal is the main question (friends of friends)], [Mostly simple lookups; very large graphs need careful distribution],
  [*Object / blob store*], [Big files addressed by name], [Photos, videos, backups; cheap, durable, huge], [Small frequent updates, low-latency random access],
  [*Search index*], [Inverted index for text, filters, ranking], [Full-text, faceted search, relevance], [As the system of record (indexes are derived, may lag)],
  [*Time-series*], [Timestamped measurements], [Metrics, sensor data, append-heavy and time-range queries], [General-purpose relational queries],
)

#callout("pitfall")[
*Choosing by popularity.* "Everyone uses X" is not a requirement. Write the access pattern, then choose.
*Using the search index as the source of truth.* Indexes are derived views. Keep the original data elsewhere so you can rebuild.
]

#callout("worked")[
*PorchLend data map.*

#table(columns: (38fr, 61fr, 61fr),
  [*Data*], [*Store*], [*Reason*],
  [Users, tools, loans, ratings], [*Relational* (one primary database)], [Related entities; loans need a transaction ("exactly one borrower at a time"); at \~160 peak rps, a single well-run relational database is far more than enough],
  [Photos], [*Object storage + CDN*], [Large, write-once, read-many; \~165 TB over 5 years (Chapter 2) is cheap in object storage and painful in a database],
  [Search (by place, text, filters)], [*Search index*, fed from the database], [Text relevance and geographic filters; derived data, can be rebuilt],
  [Sessions, rate-limit counters], [*Key-value* (in-memory)], [Fast, small, can tolerate loss with re-login],
  ["Also borrowed" recommendations], [*Computed offline*, stored as precomputed lists in key-value], [Expensive to compute per request; staleness of a day is fine],
)

_Notice:_ we did *not* pick a different technology per entity because it was fashionable. We chose where the access pattern and correctness needs differed. Simpler is better: one relational database carries most of the weight.
]

== 4.3 Transactions in one page

A *transaction* groups several changes so that either all happen or none do, and so that concurrent users do not see half-finished work. The relational promise is often summarised as *ACID*:

- *Atomicity*: all or nothing.
- *Consistency*: rules (constraints) remain true.
- *Isolation*: concurrent transactions do not trip over each other (to varying degrees; see Chapter 8).
- *Durability*: once committed, it survives crashes.

PorchLend needs this when a borrower requests the last available drill: "check that it is free" and "mark it reserved" must be *one atomic step*, otherwise two neighbours can both succeed.

```
BEGIN;
  -- only succeeds if still available
  UPDATE tools SET status = 'reserved', borrower_id = :me
   WHERE tool_id = :t AND status = 'available';
  -- if 0 rows updated, someone else got it: tell the user
  INSERT INTO loans(...);
COMMIT;
```

The important line is the *conditional update*: the check and the change are in one statement, so no gap exists between them.

== 4.4 How databases store data (so you can predict their behaviour)

#callout("mid")[
*Two families of storage engine.*

- *B-tree engines* (common in relational databases) keep data in sorted pages updated _in place_. Reads are efficient and predictable. Random writes touch pages across the disk.
- *Log-structured (LSM) engines* (common in many key-value and wide-column stores) write changes sequentially to a log and memory, then merge sorted files in the background. Writes are very fast; reads may check several files; background merging costs extra disk work ("write amplification").

_Rule of thumb:_ B-tree for read-heavy, point-and-range queries with moderate writes; LSM for very high write rates. Always measure on your workload.

*Indexes* make reads faster and writes slower. Each index must be updated on every write and uses space. Index what your top queries need, and no more. An index on `(city, status, created_at)` serves "available tools in a city, newest first"; the same index does *not* help "all tools by owner". Column _order_ matters.
]

#callout("deepen")[
*Partitioning (sharding) splits data across machines.* You pick a *partition key*. Two main schemes:

- *Hash partitioning*: even spread, but range queries scatter across partitions.
- *Range partitioning*: range queries stay local, but sequential keys (timestamps) pile all new writes on one partition ("hot partition").

*Hot keys.* One extremely popular key (a viral listing) can overload the single partition that owns it, regardless of how many machines you have. Remedies: cache it, split the key (add a random suffix and merge on read), or replicate it.

*Quorum-style stores* (the design family popularised by the Dynamo paper) keep N copies and let you choose how many must acknowledge a write (W) and agree on a read (R). If *R + W \> N*, reads overlap with the latest successful write, a building block for stronger consistency; lower values favour speed and availability. Chapter 7 and 8 cover replication and consistency properly.

*Exit costs.* Before adopting a store, ask: how would we leave? Data formats, query languages and operational skills lock you in. A relational database with standard SQL is a cheap exit; a proprietary managed store with unique features may not be.

*Do not shard early.* Sharding multiplies operational complexity (rebalancing, cross-shard queries, transactions across shards). Exhaust vertical scaling, read replicas and caching first, and write down the _threshold_ at which you would shard.
]

#callout("interview")[
Lead with access patterns: "The most common query is X, so I would...". Do not justify a choice by brand name. Expect "what happens at 10x?" and "how do you stop double booking?" Have a threshold ready: "I would shard when one primary cannot take the writes, roughly at N per second."
]

#checks-block((
  [Why is the conditional `UPDATE` safer than "read, then write"?],
  [Why must a search index not be the only copy of the data?],
  [A table is partitioned by `created_at` range. Why do new writes overload one partition, and what would you change?],
  [State the trade-off "relational database vs document store" for storing PorchLend loans in the required form: _I choose X over Y because R; I would change my mind if C_.],
))


#interview-round(4, "Where does each piece of data live?",
  "For a tool-lending app, walk me through what data you store, where, and why.",
  clarify: 3,
  est-title: "Data map",
  est-cols: ("Data", "Store type and reason", "Size / day"),
  est-rows: ("Users, tools, loans", "Photos", "Search (text + location)", "Sessions, counters", "Recommendations"),
  row-h: 6mm,
  sketch-title: "Sketch the data flow (writes in, derived views out)",
  sketch-h: 36mm, trade-rows: 3,
  twist: "Two neighbours tap 'borrow' on the last available drill at the same instant. Show the exact steps that prevent a double booking.",
  twist-lines: 3)

#import "../../lib.typ": *
= Part I answer key and review

How to use this key: *attempt first, then check.* For each interview round, the rubric lists what a strong answer *contains*. It is not a script. A different design that meets the same requirements with a stated condition for changing it is just as good.

== Chapter 1

*Checks.*
+ Example: "p95 search latency under 500 ms", "99.9% of requests succeed per month", "no acknowledged loan record is ever lost (zero acknowledged-write loss)".
+ CDN: load (and latency). Read replica: data / load. Retry policy: failure. Versioned API: change.
+ "I choose a relational table for ratings over a document store because ratings join to users and loans and we need per-user averages consistent with loan completion; I would change my mind if rating volume exceeds what one primary can write, or if rating forms become highly varied per category."

*Round 1 rubric: PorchLend Alerts.* Strong answers:
- Ask first: how late may an alert be (seconds? minutes?), what happens on duplicates, how many saved searches per user, which channels (push, email), opt-out and quiet hours.
- State numbers: for example 400k DAU, an average of 5 saved searches per user, and 20,000 new listings a day gives about 0.2 listings per second on average; the load is small, so *matching* (not volume) is the hard part.
- Core design: a new listing publishes an event; a matcher finds saved searches that match (index saved searches by category and a coarse location cell, rather than scanning everything); alerts go to a queue to notification senders; deduplicate with a key such as (user, listing).
- Trade-off stated as a condition: for example, "alerts may be up to 60 s late, so we batch matches; I would revisit if product demands under 5 s".
- *Twist (5 s, 200 searches each):* the matching index and per-user cap are the pressure points; move from batch to event-driven matching, keep matching in memory or a purpose-built index, and cap or rate-limit alerts per user so one user does not receive hundreds.

== Chapter 2: drills and rubric

#table(columns: (8fr, 50fr, 30fr),
  [*Drill*], [*Working*], [*Answer*],
  [D1], [5M × 20 = 100M/day; ÷ 10#sup[5] ≈ 1,000/s (exact ≈ 1,160); peak × 3], [≈ 1,000 avg; ≈ 3,000 peak (exact ≈ 3,500)],
  [D2], [1M × 500 KB = 500 GB/day; × 365 ≈ 183 TB; × 3], [500 GB/day; ≈ 183 TB/year; ≈ 550 TB with 3 copies],
  [D3], [0.05% of 43,200 min (30 days)], [≈ 21.6 minutes],
  [D4], [100M × 1 KB = 100 GB; hot 20%], [≈ 20 GB],
  [D5], [12,000 ÷ (1,000 × 0.5) = 24. Lose 1 of 3 zones: the 2 survivors must carry 24, so 12 each], [24 servers; 36 to survive losing a zone],
  [D6], [2,000 × 200 KB = 400 MB/s; × 8 bits], [3.2 Gbit/s],
)

*Checks.*
+ 40 requests/s says a single small server suffices; do not shard; the real design effort should go to media storage and bandwidth.
+ Usually actions per user per day or the peak factor; both are behavioural and can vary 3x to 10x, while payload sizes can be measured directly. Any justified answer is fine.
+ Availability multiplies along the path: 0.999#sup[3] ≈ 99.7%, roughly three times the downtime of one component.

*Round 2 rubric: photo storage.* Strong answers:
- Average requests ≈ 400,000 × 10 ÷ 10#sup[5] ≈ 40/s; peak ≈ 160/s. State that this is small.
- Photos: 20,000 × 3 × 1.5 MB ≈ 90 GB/day; 5 years ≈ 165 TB; 3 copies ≈ 500 TB.
- Peak egress ≈ 160 × 300 KB ≈ 48 MB/s ≈ 0.4 Gbit/s; conclude that *photos dominate*, not request rate.
- Design consequence: object storage plus CDN, thumbnails, a small relational database for metadata.
- *Twist (video):* 3,000 × 20 MB = 60 GB/day, comparable to photos. Egress could be much larger per view; this is where adaptive streaming and a CDN become essential. Storage line roughly +65%; design shape (object store plus CDN) unchanged, but add a transcoding queue (see Chapter 6).

== Chapter 3

*Checks.*
+ A nearby edge terminates TLS and keeps warm connections to the origin, so the user's handshakes cover a short distance, and the edge can compress and reuse connections.
+ If the health check queries the database and the database slows, *every* server fails its check at once, the balancer removes them all, and a partial degradation becomes a full outage. Use shallow checks for routing; separate deeper readiness checks for deploys, and degrade gracefully.
+ State in server memory ties a user to one server and is lost if it dies, so servers cannot be freely added or removed. Store the cart in a database or key-value store keyed by user or session, or in a signed client token.
+ Connection and TLS handshakes plus cold caches (CDN miss, empty database cache, runtime warm-up). Also a cold DNS lookup.

*Round 3 rubric: slow first load.* Strong answers:
- Cold: DNS (nearby resolver, ≈ 30 ms) + TCP (1 round trip, 120 ms) + TLS 1.3 (120 ms) + request and first byte (120 ms) ≈ *390 ms* before any page content; with a warm, reused connection ≈ 120 ms. A page that needs many sequential requests multiplies this, which is how a first load reaches 2 seconds.
- Fixes in order of payoff: serve static assets and images from a CDN; terminate TLS at a nearby edge; reuse connections; compress and shrink payloads; consider a nearby region only if dynamic calls dominate.
- Name the trade-off: a CDN adds cost and staleness; a second region adds consistency and operations burden. Give a condition.
- *Twist (health check cascade):* explained in check 2; also mention timeouts, load shedding and "serve cached or degraded content".

== Chapter 4

*Checks.*
+ A conditional update performs the check and the change in a single atomic step, so no gap exists in which two requests both see "available".
+ Indexes are derived views: they can lag, be misconfigured or be lost, and typically give weaker durability and transaction guarantees. Keep a source of truth to rebuild from.
+ Timestamps always increase, so the newest range receives all writes (a hot partition). Use hash partitioning, or a composite key such as (bucket, time).
+ "I choose a relational database over a document store for loans because loans link users and tools and change state in atomic steps; I would change my mind if loan writes exceed one primary's capacity or the record shape varies widely."

*Round 4 rubric: choose the stores.* Strong answers:
- Start from access patterns, not names. Relational for users, tools and loans (transactions); object storage plus CDN for photos; a search index fed from the database; in-memory key-value for sessions and counters; offline-computed recommendations.
- Say why *not* more stores: one relational database is enough for the first years at about 160 peak requests per second.
- Name the threshold at which you would change (for example single-primary write limit, or search latency target).
- *Twist (double booking):* a conditional `UPDATE ... WHERE status = 'available'` inside a transaction (or a row lock); if zero rows change, tell the second user it is gone. Mention idempotency keys so a retried tap does not create two loans.

== Chapter 5

*Checks.*
+ Average latency = 2 + 0.05 × 40 = *4 ms*. Database load = 5,000 × 0.05 = *250 rps*.
+ A 99% hit ratio means the database is sized for 1% of traffic; if the cache is lost, load jumps by 100x (versus 10x at 90%), which a database is far less likely to survive.
+ Bad: money or inventory counts, where losing unflushed data is unacceptable. Fits: view counters or analytics where small loss is acceptable.
+ All entries expire together and cause a stampede of misses. Add random jitter and coalesce reloads.
+ "I would cache the owner's rating average with a 10-minute TTL, because it is read on every listing and a few minutes of staleness harms no one; I would change my mind if ratings gate a financial decision."

*Round 5 rubric: add a cache, then break it.* Strong answers:
- At 90% hit ratio the database sees 200 rps (under the 300 limit); at 95%, 100 rps. Average latency at 95% = 2 + 0.05 × 40 = 4 ms. Required hit ratio ≥ 85%. With an empty cache the database sees 2,000 rps, about 6.7 times its limit.
- Where: cache-aside in the app tier for search results and tool details, with TTLs by staleness tolerance; CDN for public, shared responses.
- Name the risk: the database is protected *only while the cache works*.
- *Twist (restart at peak):* shed load or rate limit, serve stale or degraded responses, coalesce identical requests, restore the cache gradually (warm hottest keys first), page on database saturation and hit ratio. What you would have built: replicated cache nodes, a warm-up job, request coalescing, and a load-shedding switch.

== Chapter 6

*Checks.*
+ Busy workers = 800 × 0.02 = 16. At 60% utilisation: 16 ÷ 0.6 ≈ *27 workers*.
+ The two steps can fail separately, leaving the database updated but no message sent (or the reverse). Use an outbox written in the same transaction, or change-data-capture.
+ If the consumer is slower than producers, the queue grows without limit, wait times grow, memory or disk fill, and recovery takes longer. Bound queues; decide what happens when full (reject, shed, scale).
+ "Set status = shipped" is idempotent. Make "increment counter" safe by recording processed event IDs, or by storing events and counting them. Make "append to list" safe by using a unique ID per item so a duplicate is ignored.

*Round 6 rubric: reliable notifications.* Strong answers:
- Job rate = 50 × 4 = 200 jobs/s. Workers busy = 200 × 0.1 = 20; at 60% utilisation, ≈ 34 workers.
- Use an outbox plus publish/subscribe, with one consumer per downstream (push, email, search, analytics), each idempotent via event IDs, with exponential backoff plus jitter, and a monitored dead-letter queue.
- Email outage: backlog = 50/s × 3,600 s = 180,000 messages. With email capacity doubled to 100/s the net drain is 50/s, so recovery takes about 3,600 s: *an hour*. Message age is the metric to watch.
- *Twist (SMS limit):* 150,000 ÷ 100/s = 1,500 s = *25 minutes*. Tell product the first reminder is not instantaneous: stagger by time zone, prioritise, or negotiate a higher limit.

#pagebreak()
== Self-review: tear-out retrieval cards

Cover the bottom of each card with your hand, answer aloud, then rotate the page to check. Review schedule: day 1, day 3, day 7, day 21.

#cards((
  ("Name the four forces behind most design decisions.", "Load, data, failure, change."),
  ("Seconds in a day, rounded for estimation?", "10^5 (exact 86,400). Month ≈ 2.5×10^6; year ≈ 3×10^7."),
  ("Average latency with a cache?", "t_cache + (1 − h) × t_db."),
  ("What does a conditional UPDATE fix?", "It removes the gap between check and change, so two users cannot both win."),
  ("Why is a very high cache hit ratio risky?", "The database is sized for the misses only; a cold cache multiplies load by 1 ÷ (1 − h)."),
  ("State Little's Law.", "L = λ × W: items in the system = arrival rate × time spent in it."),
  ("With at-least-once delivery, what must consumers be?", "Idempotent: a duplicate must have no extra effect."),
  ("Round trips for a cold request (TCP + TLS 1.3 + HTTP)?", "About 3, plus DNS; one when the connection is reused."),
  ("Hot partition: what causes it, and one fix?", "Monotonic keys (timestamps) or one viral key; hash the key, split it, or cache it."),
  ("What turns a trade-off into a good one?", "A stated condition: \"I would change my mind if...\"."),
))

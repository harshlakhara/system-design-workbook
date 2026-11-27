#import "../../lib.typ": *
= Chapter 2. Numbers you should feel

#tag[●] Estimation basics. #tag[◐] Headroom and failure-aware sizing. #tag[◆] Cost and model error.

#callout("predict")[
PorchLend has 400,000 daily active users. Each opens the app and does about 10 actions a day. *Roughly how many requests per second is that on average?* Pick one: 4, 40, 400, 4,000.

#lines(4)
]

== 2.1 Why estimate at all

Estimation is not about being right. It tells you *which design family you are in*. 40 requests per second can run on one small server. 40,000 cannot. A single photo upload is trivial; 90 GB of photos a day shapes your whole storage plan. The estimate tells you _which numbers dominate_, so you spend your thinking on the right part.

#callout("keyidea")[
*Aim to be within a factor of 2 to 3, in under five minutes.* If a decision changes only when your estimate is off by 10x, then 2x errors do not matter.
]

== 2.2 Time and size, rounded for speed

Memorise these rounded values. They are chosen so arithmetic can be done in your head.

#table(columns: (28fr, 61fr, 48fr),
  [*Quantity*], [*Exact*], [*Use*],
  [Seconds in a day], [86,400], [*10#sup[5]* (about 15% error, fine)],
  [Seconds in a month], [2.6 million], [*2.5 × 10#sup[6]*],
  [Seconds in a year], [31.5 million], [*3 × 10#sup[7]*],
  [1 KB, 1 MB, 1 GB, 1 TB], [10#sup[3], 10#sup[6], 10#sup[9], 10#sup[12] bytes], [Ignore the 2#sup[10] differences],
)

*Availability in time* (the nines):

#table(columns: (13fr, 23fr, 31fr),
  [*Target*], [*Downtime per year*], [*Downtime per 30-day month*],
  [99%], [3.65 days], [7.2 hours],
  [99.9%], [8.76 hours], [43 minutes],
  [99.99%], [52.6 minutes], [4.3 minutes],
  [99.999%], [5.26 minutes], [26 seconds],
)

Each extra nine is roughly 10x less downtime and usually far more than 10x the cost. Beware that these only count _your_ component; a user's experience is the product of everything in the path (three components at 99.9% each give about 99.7%).

== 2.3 Latency: a ladder of magnitudes

Do not memorise exact figures. Remember the *ladder* and how many rungs apart things are. These are *working values* (orders of magnitude for modern server hardware, roughly 2020s); the lineage of this kind of table runs from Peter Norvig's "approximate timing for various operations" list (_Teach Yourself Programming in Ten Years_, norvig.com/21-days.html) to an interactive, year-by-year version (colin-scott.github.io). Both are dated, so check current figures before quoting any.

#table(columns: (40fr, 26fr, 40fr),
  [*Operation*], [*Rough time*], [*In "human" time if 1 ns = 1 second*],
  [Read from CPU cache or memory], [1 to 100 ns], [seconds to minutes],
  [Read 1 MB sequentially from memory], [tens of microseconds], [hours],
  [Random read from an SSD], [\~100 microseconds], [about a day],
  [Round trip inside one data centre], [\~0.5 ms], [about a week],
  [Read 1 MB sequentially from SSD], [\~1 ms], [about two weeks],
  [Spinning-disk seek], [\~10 ms], [months],
  [Round trip across a continent], [\~50 to 150 ms], [years],
)

Three lessons:

1. *Memory is about 1,000x faster than SSD, and SSD about 1,000x faster than a trip to another continent.* Avoid crossing the big gaps in the hot path.
2. *Round trips dominate.* Ten sequential calls inside a data centre cost more than moving the data.
3. *The speed of light sets a floor.* No cleverness gets a cross-continent round trip below tens of milliseconds.

== 2.4 The estimation recipe

Use this order every time. It is also the order to follow in the *Estimate* step of an interview.

1. *Users* → *daily active users (DAU)* → *actions per user per day*.
2. *Average requests per second (rps)* = DAU × actions ÷ 10#sup[5].
3. *Peak* = average × peak factor (2 to 5 for consumer apps with daily rhythms; much higher for events such as ticket sales).
4. *Read : write ratio*, because reads and writes scale differently.
5. *Payload size*, then *storage per day*, then *storage for the retention period*, then *× replication factor* (commonly 3 for durability).
6. *Bandwidth* = peak requests per second × payload size.
7. *Servers* = peak ÷ (capacity per server × target utilisation). Add spare capacity for failure.
8. *Sanity check*: compare each result to something you know. "Is 160 requests per second plausible for 400k daily users?" is a one-line check that catches most slips.

#callout("worked")[
*PorchLend estimate (worked through).*

#table(columns: (32fr, 54fr, 36fr),
  [*Quantity*], [*Calculation*], [*Result*],
  [DAU], [given], [400,000],
  [Actions per user per day], [assumption (open, search, view, message...)], [10],
  [Requests per day], [400,000 × 10], [4 million],
  [Average requests/s], [4 × 10#sup[6] ÷ 10#sup[5]], [*\~40*],
  [Peak factor], [evening peaks, assume 4], [4],
  [Peak requests/s], [40 × 4], [*\~160*],
  [New listings per day], [given], [20,000],
  [Photos per listing, size], [3 photos, 1.5 MB each after phone compression], [4.5 MB per listing],
  [New photo data per day], [20,000 × 4.5 MB = 90,000 MB], [*\~90 GB/day*],
  [Metadata per day], [20,000 × 2 KB], [\~40 MB/day],
  [Photo storage over 5 years], [90 GB × 1,825 days], [*\~165 TB* raw],
  [With 3 copies], [165 TB × 3], [\~500 TB],
  [Peak bandwidth], [160 rps × 300 KB average response], [\~48 MB/s, about *0.4 Gbit/s*],
)

_Sanity check:_ 40 requests per second is tiny; one modest server could serve it. The *interesting* numbers are not request rate but *photo storage (about 165 TB) and image bandwidth*. That is the insight: PorchLend's early problems are _media_, not _queries_. It would be wrong to design a sharded database for 160 requests per second.

(So the answer to the Predict box is "about 40".)
]

#callout("pitfall")[
*Using exact numbers too early.* Do not compute 86,400. Do not argue 1,000 vs 1,024. Do argue about the _assumptions_: is it 10 actions a day or 3? That is where the real error lives.
]

#callout("mid")[
*Headroom.* A server at 100% utilisation has no room for bursts, garbage-collection pauses or a neighbour's failure. Plan around *50 to 60% utilisation at peak*. Queueing delay grows steeply as utilisation approaches 100%, so a server at 90% busy has noticeably worse latency than one at 50% even when the average load looks the same.

*Plan for losing a failure domain.* If you run in 3 availability zones and one dies, the other two must carry everything. So 3 zones need capacity of *1.5x* the peak (not 1x). Two zones would need 2x. That is why more zones is _cheaper_ for redundancy than it looks.
]

#callout("deepen")[
*Your model has error bars; use them.* If the assumption "10 actions a day" could be 3 or 30, your average rate is somewhere between 12 and 120 rps. Decide which end drives the design. If the design is the same at both ends, stop refining.

*Cost is a number too.* Storage, egress and requests have prices that differ by orders of magnitude between tiers (memory, SSD, object storage, cold archive). A design that is correct but ten times the budget is not correct. Add a cost line to every estimate. (Prices change; use the provider's current price page, not a remembered figure.)

*Estimates for tails and bursts.* Averages are for capacity planning; *peaks and fan-out* are for failure planning. One celebrity-sized hot key, a retry storm or a cache restart can cause 10x to 100x short bursts. Ask: "what is my worst plausible one-minute load?"
]

== 2.5 Drills

Do these in the table below, with the arithmetic shown, before checking the answer key. Time yourself: aim for under 3 minutes each.

#callout("yourturn")[
*D1.* An app has 5 million daily active users, 20 requests each per day, peak factor 3. Average and peak requests per second?

*D2.* A service receives 1 million uploads a day of 500 KB each. Storage per day, per year, and with 3 copies?

*D3.* A contract demands 99.95% monthly availability (30-day month). How many minutes of downtime are allowed?

*D4.* A catalogue has 100 million items of 1 KB each. If caching the hottest 20% serves most reads, how large is the cache?

*D5.* Peak traffic is 12,000 requests per second. One server handles 1,000 per second at saturation. Target utilisation is 50%. How many servers? Then: you want to survive losing 1 of 3 zones. How many in total?

*D6.* A service sends 2,000 responses per second of 200 KB each. What bandwidth is that, in Gbit/s?

#drill-table(("D1", "D2", "D3", "D4", "D5", "D6"))
]


#callout("interview")[
Estimation is a *conversation*, not an arithmetic test. Say your assumptions aloud, round aggressively, and finish by saying what the number *means* ("so media storage dominates, not request rate"). If the interviewer gives numbers, use theirs. A wrong assumption stated clearly is easy to fix; a silent one is not.
]

#checks-block(new-page: true, (
  [Why is "40 requests per second" a _design signal_ and not just a number?],
  [Which assumption in an estimate usually has the largest error: users, actions per user, payload size, or peak factor? Justify.],
  [Why do three 99.9% components in series not give 99.9%?],
))


#quickref("Estimation cheat sheet (copy it onto one index card)")[
#table(columns: (22fr, 78fr),
  [*Time*], [1 day ≈ 10#sup[5] s · 1 month ≈ 2.5 × 10#sup[6] s · 1 year ≈ 3 × 10#sup[7] s],
  [*Size*], [1 KB = 10#sup[3] · 1 MB = 10#sup[6] · 1 GB = 10#sup[9] · 1 TB = 10#sup[12] bytes],
  [*Traffic*], [average rps = DAU × actions per user ÷ 10#sup[5] · peak = average × (2 to 5) · bandwidth = rps × payload],
  [*Storage*], [per day = writes × size · per year = per day × 365 · durable copies: × 3],
  [*Servers*], [count = peak ÷ (capacity per server × 0.5) · to survive losing 1 of N zones, provision N ÷ (N − 1) × peak],
  [*Availability*], [99.9% ≈ 8.8 h per year ≈ 43 min per month · 99.99% ≈ 53 min per year ≈ 4.3 min per month],
  [*Latency ladder*], [memory ≈ 100 ns · SSD read ≈ 100 µs · same data centre ≈ 0.5 ms · disk seek ≈ 10 ms · across a continent ≈ 100 ms],
  [*Always finish with*], [what the number *means*: "small, so do not shard" or "huge, so storage dominates".],
)
]

#interview-round(2, "Estimate first: photo storage",
  "We run a tool-lending app with 2 million users, 400,000 active daily, and 20,000 new listings a day with 3 photos each. How much storage and bandwidth do we need? Talk me through it.",
  clarify: 3,
  est-rows: ("Average requests / s", "Peak requests / s (x4)", "New photo data / day", "5-year storage, 3 copies", "Peak egress (300 KB / request)", "Which number dominates?"),
  row-h: 9mm,
  sketch-h: none, trade-rows: 3,
  twist: "Product also wants 30-second videos (about 20 MB each, 3,000 a day). Redo the storage line. Does your design change?",
  twist-lines: 4)

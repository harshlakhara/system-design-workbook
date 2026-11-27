#import "../../lib.typ": *

#pagebreak(weak: true)
#part-band[Part I: Foundations]
#[
#show heading.where(level: 1): h1-style
= Chapter 1. Thinking in systems
]

#tag[● Foundational] Read everything. #tag[◐] Read the Mid-level box. #tag[◆] Read the Deepen box.

#callout("predict")[
A friend says: "Our app is slow. We should add more servers." Write down *three questions* you would ask before agreeing.

#lines(4)
]

== 1.1 A system is a set of promises under constraints

A _system_ here means software plus the machines, networks and people that keep it running. Designing one is *choosing which promises to make, and which to break first when things go wrong*.

Promises sound like: "A search returns in under half a second." "Once we say your payment succeeded, it did." "If one data centre burns down, you lose no more than a minute of data."

Constraints are the reasons you cannot promise everything: money, time, team size, physics (the speed of light is not negotiable), and the fact that components fail.

#callout("keyidea")[
*Design is the art of deciding what you are willing to be bad at.* Every strength you add has a cost somewhere else. A design with no stated weakness has not been understood.
]

== 1.2 Requirements: what, and how well

*Functional requirements* say what the system does: "a user can list a tool", "an owner can approve a loan".

*Non-functional requirements* say _how well_. They are the ones that shape architecture. A short checklist:

#table(columns: (24fr, 56fr, 61fr),
  [*Quality*], [*The question to ask*], [*Example for PorchLend*],
  [Latency], [How fast must a response be, for which operations?], [Search results within 500 ms for most users],
  [Throughput], [How many operations per second, average and peak?], [Browsing is common, listing a tool is rare],
  [Availability], [How much downtime is acceptable?], [A few minutes a month is fine; it is not a hospital],
  [Durability], [Which data must never be lost?], [Loan records and ratings: never. Search history: who cares],
  [Consistency], [Can two users briefly see different answers?], [Two neighbours must not both borrow the same drill],
  [Cost], [What is the budget per user per month?], [A hobby budget at first],
  [Security & privacy], [What data is sensitive?], [Home location of users],
)

A requirement without a *number* is a wish. "Fast" is a wish. "p99 under 800 ms" is a requirement.

#callout("pitfall")[
Beginners start drawing boxes. Experienced engineers start asking questions. If you catch yourself naming a database in the first minute, stop and fill in the requirements page.
]

== 1.3 The four forces

Almost every architecture decision is a response to one of four forces. Name the force before you choose the tool.

#table(columns: (17fr, 40fr, 57fr),
  [*Force*], [*In plain words*], [*Typical response*],
  [*Load*], [More requests, more users, bursts], [Add capacity, cache, spread work out],
  [*Data*], [More of it, or harder to query], [Partition, index, change storage type],
  [*Failure*], [Machines, networks and people fail], [Redundancy, timeouts, retries, graceful degradation],
  [*Change*], [The product and team keep changing], [Clear boundaries, safe deploys, migrations],
)

If someone proposes a component and you cannot say which force it answers, ask. Often it answers none, and is there because it is fashionable.

== 1.4 A trade-off is a condition, not a verdict

Weak statement: "NoSQL scales better than SQL."

Strong statement: "For PorchLend's _loan records_, I would use a relational database, because we need a transaction that says 'this drill is borrowed by exactly one person'. For _listing photos_ I would use object storage, because they are large, written once and read many times. I would revisit if loans exceed what one primary can write."

A good trade-off has this shape:

#block(stroke: (left: 2pt + black), inset: (left: 3mm, y: 1mm), width: 100%)[*I choose X over Y because of requirement R. I would change my mind if condition C becomes true.*]

The last sentence is the important one. It shows you know the boundary of your own choice.

#callout("worked")[
*Decision: how should PorchLend store "is this tool available right now?"*

- _Option A:_ a column on the tool row, updated when a loan starts or ends. Simple, consistent, easy to reason about.
- _Option B:_ compute it by scanning loans each time. Never out of date, but slower on every search.
- _Option C:_ cache the flag in memory. Fast, but may be briefly wrong.

_Choice:_ A. _Because:_ the flag is read on every search but only changes on a loan event, and it must be right when a loan is approved. _Change my mind if:_ search traffic grows so large that reading the primary becomes the bottleneck. Then add a cache and accept "may be stale for a few seconds" on the search page only, while the approval step still checks the source of truth.
]

== 1.5 Why "just add servers" often fails

Back to your friend's slow app. Three outcomes of "adding servers":

- The slow part is a *single database query*. More servers send more queries to the same database and make things worse.
- The slow part is a *call to a slow external service*. More servers wait in parallel and cost more.
- The slow part is *CPU in the application*. More servers help. This is the only case where the advice is right.

The skill is _finding which one_. That is why Chapter 2 starts with numbers, and why every Interview Round asks you to state a number before you draw a box.

#callout("mid")[
*Latency and throughput are different problems.* Latency is how long one request takes. Throughput is how many you complete per second. You can have high throughput with bad latency (a long queue processed by many workers) and good latency with low throughput (a fast single worker). Always say which one you mean.

Percentiles matter: the _average_ hides the slow tail. "p99" means 99% of requests are faster than this value (likewise p95). If your p99 is 3 seconds, 1 request in 100 is that slow, and a page that makes 20 backend calls will hit a slow one on roughly one in five loads (1 - 0.99#sup[20] ≈ 18%).
]

#callout("deepen")[
*Write down what you are \*not\* promising.* Senior engineers state non-goals out loud: "We are not building real-time chat; messages can take up to 30 seconds." That one sentence can remove a whole component.

*Requirements move.* Plan for the _likely_ change, not every change. Ask "what is the next requirement the business will add?" and make sure your design does not forbid it. For PorchLend, that might be "borrowing fees". It would force you to treat payments as part of the loan transaction, so keep loan state changes behind one service boundary now.
]

#callout("interview")[
Interviewers score *how you think before you draw*. Spend the first three to five minutes on questions and numbers: "Before I design, can I confirm the scale, and whether latency, durability or cost matters most?" Naming a *non-goal* out loud is a strong signal. Naming a database in the first minute is a weak one.
]

#checks-block((
  [Rewrite "the site must be fast and reliable" as three measurable requirements.],
  [Name the force (load, data, failure, change) behind each: a CDN (a network of nearby caches), a read replica (a copy of the database that serves reads), a retry policy, a versioned API.],
  [State a trade-off in the form "I choose X over Y because R; I would change my mind if C" for storing user ratings.],
))


#interview-round(1, "Requirements first: PorchLend Alerts",
  "A neighbourhood tool-lending app wants alerts: when a neighbour lists a tool I previously searched for, notify me. Design it.",
  clarify: 4,
  est-title: "Pin down requirements with numbers",
  est-cols: ("Quality", "Target (a number)", "Why it matters"),
  est-widths: (24%, 46%, 30%),
  est-rows: ("Alert delay (p95)", "Duplicates allowed?", "Scale: saved searches", "Availability / loss", "Privacy / opt-out", "Out of scope"),
  row-h: 6mm,
  sketch-title: "First-pass sketch (only boxes you can justify)",
  sketch-h: 38mm, trade-rows: 2,
  twist: "Marketing wants every alert within 5 seconds, and power users have 200 saved searches each. What changes?",
  twist-lines: 3)

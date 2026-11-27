#import "../../lib.typ": *

// ---------- a hand-drawn-style flow: boxes with a reason underneath, arrows with a number on top ----------
#let arrow(label) = stack(dir: ttb, spacing: 0.8mm,
  align(center, hw(label, size: 8pt)),
  grid(columns: (1fr, auto), align: horizon,
    line(length: 100%, stroke: 1.1pt + luma(45)),
    polygon(fill: luma(45), stroke: none, (0pt, -1.3mm), (2.2mm, 0pt), (0pt, 1.3mm)),
  ),
)
#let node(label, reason) = stack(dir: ttb, spacing: 1.4mm,
  box(width: 100%, stroke: 1.1pt + luma(45), radius: 1mm, inset: (x: 1.5mm, y: 2.4mm), align(center, hw(label, size: 9.5pt))),
  align(center, hw(reason, size: 8pt)),
)
#let hflow(nodes, arrows, w: 29mm) = grid(
  columns: nodes.enumerate().map(((i, _)) => if i == 0 { (w,) } else { (1fr, w) }).flatten(),
  align: top, column-gutter: 1.2mm,
  ..nodes.enumerate().map(((i, n)) => if i == 0 { (node(..n),) } else { (pad(top: 3mm, arrow(arrows.at(i - 1))), node(..n)) }).flatten(),
)

#interview-round("Sample", "View counter",
  "PorchLend owners want to see how many times their listing was viewed today. Design the counter.",
  mins: "35 min",
  est-title: "Estimate (show the arithmetic)",
  est-rows: ("Views per day", "Average views / s", "Peak views / s (x3)", "Counter data size", "Which number dominates?"),
  est-widths: (30%, 50%, 20%),
  sample: (
    clarify-q: [1. Exact, or roughly right? \ 2. How fresh: instant, or a minute late? \ 3. Total views, or unique viewers? \ 4. Today only, or history too? \ 5. Do bots and refreshes count?],
    clarify-a: [Roughly right is fine, a minute late is fine. \ Total views: today plus a 30-day chart. \ Bots: ignore for now (ask later). \ 400k daily users, 5 views each. \ 600k active listings.],
    est: (
      ([400k users x 5 views], [2M / day]),
      ([2M / 10#sup[5] s in a day], [20 / s]),
      ([20 x 3 for the evening peak], [60 / s]),
      ([600k listings x 16 B], [10 MB]),
      ([Nothing is big: 60 writes/s is small], [keep it simple]),
    ),
    sketch: {
      v(5mm)
      hflow(
        (([Listing page], [a user opens a tool]), ([App server], [stateless: add more if needed]), ([Database], [one small table, 10 MB, already have it])),
        ([60 / s peak], [views = views + 1]),
        w: 33mm,
      )
      v(7mm)
      hflow(
        (([Owner dashboard], [reads once or twice a day]), ([Database], [same table, 30-day rows])),
        ([a few reads / s],),
        w: 40mm,
      )
      v(8mm)
      hw([Why no cache or queue? At 60 writes/s a plain database is fine. More parts means more things to fail. \ I will add them only when a number forces me to (see the twist on the back).], size: 9pt)
    },
    defend: (
      ([Atomic add in the database: views = views + 1], [Read, add one, write back in app code], [two requests can read the same value and lose a count], [counts must be exact (billing)]),
      ([Plain database, no cache or queue], [Redis counters with batching], [60 writes/s is small; fewer parts to fail], [one listing gets over ~1,000 writes/s]),
      ([Count total views], [Count unique viewers], [unique needs a record per viewer per listing: far more data], [product asks for unique viewers]),
    ),
    redraw: {
      v(3mm)
      hflow(
        (([Listing page], [20,000 views / s on one listing]), ([20 app servers], [each adds up views in memory for 1 s]), ([Database], [one hot row, but only 20 writes / s])),
        ([1,000 / s per server], [1 write / s per server]),
        w: 34mm,
      )
      v(7mm)
      hw([Unchanged: the owner dashboard, the table, the way it is read. \ Changed: the write path only. A server that crashes loses at most 1 s of its counts (about 1,000 views): acceptable for a view counter, not for money.], size: 9pt)
    },
    new-nums: [Viral listing: 20,000 views/s on one row = lock contention. \ 20,000 / 20 servers = 1,000 views/s each. Flush each second: \ 20 servers x 1 write/s = 20 writes/s on the hot row (1000x less). \ Cost: lose up to 1 s of counts if a server dies.],
    differently: [Ask about bots and repeated refreshes in step 1, not at the end.],
    tips: (
      "1": [Ask before you draw. Write what you assume, so the interviewer can correct you. Five good questions and four numbers beat ten minutes of boxes.],
      "2": [One line per quantity: the working, then the result. Round hard (a day is about 10#sup[5] seconds). The last row says which number dominates; here none does, so the design can stay simple.],
      "3": [Draw boxes left to right, the path of one request. Put a number on every arrow and a reason under every box. Say why you did *not* add the cache or queue; that shows judgement.],
      "4": [One row per decision: what I chose, what I rejected, because of which requirement, and the condition that would change my mind. Never write a verdict without a condition.],
      "5": [The interviewer changes one constraint. Redraw only what changes, say what stays the same, and redo the numbers. Your first design was right for the old numbers; the twist tests whether you can adapt.],
    ),
  ),
  twist: "One listing goes viral: 20,000 views per second on that single listing. What changes?",
)

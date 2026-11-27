#import "../../lib.typ": *

// ---------- a hand-drawn-style flow: boxes with a reason underneath, arrows with a label on top ----------
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

// A finished Round. Rules: 5 lines maximum in a 40mm clarify box; the analysis should say "keep it simple";
// the twist should force one change. Do not use "~" (the handwriting font lacks it).
#interview-round("Sample", "TODO short title",
  "TODO: a small, self-contained prompt.",
  est-rows: ("TODO row 1", "TODO row 2", "TODO row 3"),
  est-widths: (30%, 50%, 20%),
  sample: (
    clarify-q: [1. TODO question \ 2. TODO question \ 3. TODO question],
    clarify-a: [TODO assumption \ TODO number \ TODO scope],
    est: (
      ([TODO working], [TODO result]),
      ([TODO working], [TODO result]),
      ([TODO working], [TODO result]),
    ),
    sketch: {
      v(5mm)
      hflow(
        (([Box A], [reason]), ([Box B], [reason]), ([Box C], [reason])),
        ([number], [number]),
        w: 33mm,
      )
      v(7mm)
      hw([Why I kept it simple: TODO. \ I will add more only when a number forces me to.], size: 9pt)
    },
    defend: (
      ([TODO decision], [TODO rejected option], [TODO because], [TODO I would change if]),
      ([TODO decision], [TODO rejected option], [TODO because], [TODO I would change if]),
    ),
    redraw: {
      v(3mm)
      hflow((([Box A], [reason]), ([Box B'], [changed]), ([Box C], [reason])), ([number], [number]), w: 34mm)
      v(7mm)
      hw([Unchanged: TODO. Changed: TODO.], size: 9pt)
    },
    new-nums: [TODO new numbers \ TODO new decision],
    differently: [TODO one thing to ask or do earlier next time.],
    tips: (
      "1": [Ask before you start. Write what you assume so the examiner can correct you.],
      "2": [One line per quantity: working, then result. Round hard. Say which number dominates.],
      "3": [Draw left to right. A number on every arrow, a reason under every box. Say what you left out and why.],
      "4": [One row per decision: chosen, rejected, because, and the condition that would change your mind.],
      "5": [The examiner changes one constraint. Redraw only what changes, and redo the numbers.],
    ),
  ),
  twist: "TODO: one constraint changes.",
)

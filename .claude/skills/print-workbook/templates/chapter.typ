#import "../../lib.typ": *

// Chapter skeleton: keep this order. Delete the TODO lines as you fill them in.
#pagebreak(weak: true)
= Chapter 1. __CHAPTER_TITLE__

#callout("predict")[
TODO: one question the learner answers in writing *before* reading on.
#lines(4)
]

== 1.1 First idea

TODO: short explanation, one idea. Use `*bold*` for the term being defined and `_italic_` for emphasis.

#callout("keyidea")[
TODO: the one sentence to remember.
]

== 1.2 Second idea

TODO: explanation plus one table or diagram.

#callout("mid")[
TODO (optional): a deeper mechanism for readers who have practised the subject.
]

#callout("worked")[
*TODO: title of the worked example.* Solve it completely on the running example, with the arithmetic or reasoning shown and every number verified.
]

#callout("interview")[
TODO: what the real test probes on this topic, and how a strong answer sounds.
]

// If the questions get cut off at the bottom of the page, they did not fit in the space left: add `new-page: true`.
#checks-block((
  [TODO: question 1],
  [TODO: question 2],
  [TODO: question 3],
))

#interview-round(1, "TODO: short title (40 characters or fewer)",
  "TODO: the prompt the examiner gives.",
  est-title: "TODO: the working table (or delete est-rows)",
  est-cols: ("Quantity", "Calculation", "Result"),
  est-rows: ("TODO row 1", "TODO row 2"),
  est-widths: (30%, 50%, 20%),
  twist: "TODO: the examiner changes one constraint. What changes?",
)

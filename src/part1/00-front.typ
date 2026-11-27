#import "../../lib.typ": *

= How to use this workbook

This book is meant to be *written in*. Reading a system design book passively teaches you about as much as watching someone else do push-ups. It is built for *interview preparation* first: every chapter ends with an *Interview Round*, a two-page template (front and back of one sheet) that mimics a real interview, where the interviewer asks a question and you answer on paper, in the order a strong candidate would.

Every chapter follows the same rhythm:

1. *Predict first.* A dashed box asks a question _before_ you read the answer. Write a guess. Being wrong on paper makes the right answer stick.
2. *Concept pages.* Short sections, one diagram per idea.
3. *Worked example.* A fully solved example on one running product (below).
4. *In the interview.* What interviewers probe on this topic and how to answer well.
5. *Check yourself* and *Interview Round.* Short questions, then two pages that simulate the interview. Answers and a scoring rubric are at the back of the part.

*Start with the sample.* Right after the contents there is a finished Round, filled in by hand-style writing, with a short note on how to use each step. Read it once, then do Round 1 yourself.

*There are deliberately no blank filler pages.* A Round is a compact template (clarify, estimate, sketch, defend, handle the twist), so every sheet you print is one you actually use.

== Depth markers (survive black-and-white printing)

#table(columns: (30fr, 55fr, 55fr),
  [*Marker*], [*Meaning*], [*Read it if...*],
  [● *Foundational*], [Core ideas everyone needs], [You are new to system design, or want a refresher],
  [◐ *Mid-level*], [Mechanisms and the reasons behind them], [You have built and operated a service],
  [◆ *Senior+*], [Trade-offs, edge cases, failure modes, operations], [You decide architecture or review others' designs],
)

*Reading paths.* _Fresher:_ read ● only, then do every Round. _Mid-level:_ ● and ◐, and time yourself on the Rounds. _Senior:_ skim ●, deep-read ◐ and ◆, and spend your time on the *twist* in each Round.

== The five-step answer (used in every Round)

+ *Clarify.* Ask questions, state assumptions and numbers before drawing anything.
+ *Estimate.* Rough arithmetic that tells you which design family you are in.
+ *Sketch.* Boxes and arrows, with a number on each arrow and a reason for each box.
+ *Defend.* For each choice: "I choose X over Y because R; I would change my mind if C."
+ *Adapt.* The interviewer changes a constraint. Say what changes and what does not.

== Our running example: PorchLend

All worked examples in Part I use one fictional product, so you do not learn a new domain in every chapter.

#block(stroke: (left: 2pt + black), inset: (left: 3mm, y: 1mm), width: 100%)[*PorchLend* is a neighbourhood tool-lending app. People list tools they own (a drill, a ladder), neighbours search by location, request to borrow, the owner approves, they meet to hand over the tool, and both sides leave a short rating after the return.]

Working numbers (invented): *2 million* registered users, *400,000* daily active users, *20,000* new listings a day, about *3 photos* each. PorchLend is not a real company; none of its numbers come from a real system.

== About the numbers

- Numbers marked *working value* are rough orders of magnitude chosen to keep arithmetic honest. *Measure your own system* before trusting them.
- Real-world figures from a published source carry the year and a citation. Treat anything older than about five years as a story, not a specification.

== Licence, contributing, printing

- *Licence.* Text and figures: CC BY-SA 4.0. Build scripts and templates: MIT. You may print, share and adapt this book if you credit it and share adaptations under the same licence.
- *Original content only.* Do not paste text from books, paid courses or restrictively licensed sources. Public papers and engineering blogs may be _cited_ and their _facts_ used, in your own words. Each source is recorded in `SOURCES.md` with its licence.
- *Printing.* A4 or Letter, 100% scale, duplex, black and white. *We recommend spiral (coil) binding*: a spiral book lies flat, so you can write on any page with a pen without fighting the spine, and you can fold a Round back on itself to work on one sheet. Margins are equal (20mm) on every page, so the holes fit on the left whichever way you bind. Use pencil for a first attempt and pen for the final answer. Rounds are designed to be printed alone if you are short of paper: each is a front-and-back sheet.

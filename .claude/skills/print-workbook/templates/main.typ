#import "lib.typ": *
#show: workbook

// ---------- cover ----------
#page(footer: none)[
  #set text(font: sans)
  #v(55mm)
  #text(size: 38pt, weight: "bold")[__TITLE__]
  #v(6mm)
  #text(size: 14pt)[A print-first, pen-and-paper workbook: __SUBJECT__.]
  #v(4mm)
  #text(size: 11pt)[Part I (draft 0.1)]
  #v(1fr)
  #line(length: 100%, stroke: 1pt)
  #text(size: 8.5pt)[
    Text and figures: CC BY-SA 4.0. Build scripts and templates: MIT. Print it, copy it, improve it. \
    Every page is either explanation or a working exercise. There are no blank filler pages. Spiral binding is recommended.
  ]
]

#include "src/part1/00-front.typ"

#v(4mm)
#text(font: sans, size: 13pt, weight: "bold")[Contents]
#outline(title: none, depth: 1, indent: 0mm)

#include "src/part1/00b-sample.typ"
// Add each new chapter below, in order.
#include "src/part1/01-first-chapter.typ"
#include "src/part1/08-sources.typ"
#include "src/part1/07-answers.typ"

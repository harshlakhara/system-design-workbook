#import "lib.typ": *
#show: workbook

// ---------- cover ----------
#page(footer: none)[
  #set text(font: sans)
  #v(55mm)
  #text(size: 38pt, weight: "bold")[System Design \ Workbook]
  #v(6mm)
  #text(size: 14pt)[A print-first, pen-and-paper guide to system design interviews.]
  #v(4mm)
  #text(size: 11pt)[Part I: Foundations #h(2mm) (draft 0.1)]
  #v(1fr)
  #line(length: 100%, stroke: 1pt)
  #text(size: 8.5pt)[
    Text and figures: CC BY-SA 4.0. Build scripts and templates: MIT. Print it, copy it, improve it. \
    Every page is either explanation or a working exercise. There are no blank filler pages: each *Interview Round* is a two-page template (front and back) that you fill in as you would on a whiteboard. \
    Citations were link-checked on 27 Nov 2026 (see SOURCES.md). The Kafka paper has no verified authoritative URL.
  ]
]

#include "src/part1/00-front.typ"

#v(4mm)
#text(font: sans, size: 13pt, weight: "bold")[Contents]
#outline(title: none, depth: 1, indent: 0mm)

#include "src/part1/00b-sample.typ"
#include "src/part1/01-thinking-in-systems.typ"
#include "src/part1/02-numbers.typ"
#include "src/part1/03-request-lifecycle.typ"
#include "src/part1/04-data.typ"
#include "src/part1/05-caching.typ"
#include "src/part1/06-async.typ"
#include "src/part1/08-sources.typ"
#include "src/part1/07-answers.typ"

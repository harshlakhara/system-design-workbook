// System Design Workbook: shared template library.
// Text and figures: CC BY-SA 4.0. Build tooling and templates: MIT.
// Design rules: black & white safe, ink-light, no all-blank pages, equal 20mm side margins (room to punch or staple).

#let serif = ("Georgia", "Libertinus Serif")
#let sans = ("Helvetica Neue", "Helvetica", "Arial")
#let mono = ("Menlo", "DejaVu Sans Mono")
#let faint = luma(150)
#let ico(kind, size: 2.7mm) = box(width: size, height: size, baseline: 0.12em, {
  if kind == "F" {
    circle(radius: size / 2, fill: black, stroke: 0.7pt)
  } else if kind == "M" {
    circle(radius: size / 2, stroke: 0.7pt, fill: gradient.linear((black, 0%), (black, 50%), (white, 50%), (white, 100%)))
  } else {
    polygon(fill: black, (size / 2, 0pt), (size, size / 2), (size / 2, size), (0pt, size / 2))
  }
})

// ---------- document setup ----------
#let h1-style(it) = {
  set text(font: sans, size: 22pt, weight: "bold")
  block(width: 100%, below: 6mm, stroke: (bottom: 1.2pt + black), inset: (bottom: 3mm), it.body)
}
#let workbook(body) = {
  set page(
    paper: "a4",
    margin: (x: 20mm, top: 17mm, bottom: 19mm),
    footer: context {
      let n = counter(page).get().first()
      align(center, text(font: sans, size: 8.5pt, fill: luma(80), str(n)))
    },
  )
  show "●": ico("F")
  show "◐": ico("M")
  show "◆": ico("S")
  set text(font: serif, size: 11pt, lang: "en")

  set par(leading: 0.78em, spacing: 1.05em)
  set list(indent: 1mm, body-indent: 2.5mm, spacing: 0.75em)
  set enum(indent: 1mm, body-indent: 2.5mm, spacing: 0.75em)
  show raw: set text(font: mono, size: 8.3pt)
  show raw.where(block: true): it => block(width: 100%, fill: luma(243), stroke: 0.5pt + luma(150), inset: 2.5mm, breakable: false, it)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    h1-style(it)
  }
  show heading.where(level: 2): it => block(above: 8mm, below: 2.5mm, sticky: true, text(font: sans, size: 14pt, weight: "bold", it.body))
  show heading.where(level: 3): it => block(above: 5mm, below: 2mm, sticky: true, text(font: sans, size: 11.5pt, weight: "bold", it.body))
  set table(
    stroke: 0.55pt + black,
    inset: (x: 2mm, y: 1.7mm),
    fill: (_, y) => if y == 0 { luma(228) } else { none },
  )
  show table: set text(font: sans, size: 9.3pt)
  show table: set block(breakable: false)
  body
}

// ---------- tier markers (shapes, so they survive b/w printing) ----------
#let tag(body) = box(stroke: 0.7pt, inset: (x: 1.3mm, y: 0.7mm), baseline: 0.5mm, text(font: sans, size: 9pt, weight: "bold", body))

// ---------- writing aids ----------
#let lines(n, gap: 7.6mm) = {
  for _ in range(n) {
    v(gap)
    line(length: 100%, stroke: 0.5pt + luma(125))
  }
}
#let dotbox(h, width: 100%) = rect(
  width: width, height: h, stroke: 0.7pt + black,
  fill: tiling(size: (5mm, 5mm), place(center + horizon, circle(radius: 0.22mm, fill: luma(130)))),
)
#let ruled-fill = tiling(size: (20mm, 7.6mm), place(bottom, line(length: 20mm, stroke: 0.5pt + luma(125))))
#let check = box(width: 3mm, height: 3mm, stroke: 0.7pt, baseline: 0.3mm)
#let lab(body) = text(font: sans, size: 7.5pt, weight: "bold", tracking: 0.04em, upper(body))

// ---------- callouts ----------
// Wording of the callout labels. Re-skin for another subject here (see .claude/skills/print-workbook).
#let callout-text = (
  predict: "Predict first: write your guess before reading on",
  keyidea: "Key idea",
  pitfall: "Common pitfall",
  worked: "Worked example (PorchLend)",
  yourturn: "Your turn",
  deepen: "◆  Senior+ deepen",
  mid: "◐  Mid-level",
  interview: "In the interview",
  sources: "Primary sources: read the original, do not rely on our summary",
  checks: "Check yourself (answers in the Part I answer key)",
)
#let callout(kind, body) = {
  let (label, stroke, fill) = if kind == "predict" {
    (callout-text.predict, (paint: black, thickness: 1.1pt, dash: "dashed"), none)
  } else if kind == "keyidea" {
    (callout-text.keyidea, 0.8pt + black, luma(238))
  } else if kind == "pitfall" {
    (callout-text.pitfall, 0.8pt + black, none)
  } else if kind == "worked" {
    (callout-text.worked, 0.8pt + black, luma(248))
  } else if kind == "yourturn" {
    (callout-text.yourturn, 1.6pt + black, none)
  } else if kind == "deepen" {
    (callout-text.deepen, (left: 4pt + black, rest: 0.6pt + black), none)
  } else if kind == "mid" {
    (callout-text.mid, (left: 2.2pt + black, rest: 0.6pt + black), none)
  } else if kind == "interview" {
    (callout-text.interview, (left: 2.2pt + black, rest: 0.8pt + black), luma(244))
  } else if kind == "sources" {
    (callout-text.sources, (paint: black, thickness: 0.7pt, dash: "dotted"), none)
  } else if kind == "checks" {
    (callout-text.checks, 0.9pt + black, none)
  } else { ("", 0.6pt + black, none) }
  let can-break = kind in ("mid", "deepen", "interview", "worked", "checks", "sources")
  v(1.5mm)
  block(width: 100%, stroke: stroke, fill: fill, inset: (x: 3.6mm, top: 3mm, bottom: 2.8mm),
    breakable: can-break, {
    block(sticky: true, { lab(label); v(1.8mm) })
    set text(size: if kind == "sources" { 9pt } else { 10.6pt })
    body
  })
  v(1.5mm)
}

// ---------- Check yourself: fills the rest of the page ----------
// An unbreakable block of height 1fr takes all the space left on the page; each answer area is a 7mm minimum gap
// plus an equal share of the spare height (v(1fr)). Do NOT read here().position() for this: it oscillates between pages.
// If the questions do not fit in the space left on the page, pass new-page: true to start a fresh page.
#let check-label = callout-text.checks
#let checks-block(qs, nlines: 2, new-page: false) = {
  if new-page { pagebreak() }
  v(1.5mm)
  block(width: 100%, height: 1fr, stroke: 0.9pt + black, inset: (x: 3.6mm, top: 3mm, bottom: 2.8mm), breakable: false, {
    lab(check-label)
    v(1.8mm)
    set text(size: 10.6pt)
    for (i, q) in qs.enumerate() {
      grid(columns: (6mm, 1fr), [#(i + 1).], q)
      for _ in range(nlines) {
        v(7mm)
        v(1fr)
        line(length: 100%, stroke: 0.5pt + luma(125))
      }
      v(1.2mm)
    }
  })
}

// ---------- tear-out cards (compact, two columns) ----------
#let cards(items) = {
  grid(columns: (1fr, 1fr), gutter: 2.5mm, ..items.enumerate().map(((i, it)) => {
    let (q, a) = it
    block(width: 100%, height: 31mm, stroke: (paint: black, thickness: 0.7pt, dash: "dashed"), inset: 2mm, breakable: false, {
      grid(rows: (auto, 1fr, auto), row-gutter: 0mm,
        text(font: sans, size: 8.8pt, weight: "bold", [#text(fill: faint, size: 6.5pt)[#(i + 1).] #q]),
        [],
        rotate(180deg, reflow: true, block(width: 100%, text(font: sans, size: 7.3pt, a))),
      )
    })
  }))
}

// ---------- the Interview Round template: one page, one scenario ----------
// Print-efficient: every section is compact; the page is *the* exercise, not a blank sheet.
#let step(n, title, mins) = block(above: 3.4mm, below: 1.4mm, sticky: true, {
  box(fill: black, inset: (x: 1.6mm, y: 0.7mm), baseline: 0.3mm, text(font: sans, size: 8pt, weight: "bold", fill: white, str(n)))
  h(1.5mm)
  text(font: sans, size: 9.5pt, weight: "bold", title)
  h(1fr)
  text(font: sans, size: 7.5pt, fill: luma(90), mins)
})

// All wording of the Round template lives here, so another subject can re-skin it by editing this dictionary only
// (see .claude/skills/print-workbook). Layout code below must not contain literal user-facing strings.
#let round-text = (
  name: "Round",                                   // heading prefix: "ROUND 3"
  prompt-label: "Interviewer says",                // label above the question
  clarify-title: "Clarify before you draw: questions I ask, assumptions I state",
  clarify-left: "Questions I ask",
  clarify-right: "Assumptions and numbers I state",
  est-title: "Estimate (show the arithmetic)",
  sketch-title: "Sketch (numbers on the arrows; a reason for every box)",
  dominates-title: "What dominates, and what does it mean for the design?",
  defend-title: "Defend your choices (a condition, not a verdict)",
  defend-cols: ("Decision", "Chosen over", "Because (requirement)", "I'd change if..."),
  twist-title: "The interviewer changes a constraint",
  twist-label: "Twist",
  redraw-label: "Redraw only what changes, and say why",
  new-nums-label: "New numbers and decisions",
  differently-label: "One thing I would do differently next time",
  self-score-label: "Self-score",
  self-score: ("Clarified first", "Used numbers", "Justified each box", "Named a failure", "Adapted to the twist"),
  minutes: ("3 min", "4 min", "8 min", "5 min", "5 min"),   // steps 1, 2, 3, 4, 5
  sample-intro: [*This is a finished example.* The handwriting-style text is what a candidate would write on paper. The short notes marked "How to use this step" explain each part. Then do Round 1 yourself, with a pencil and a timer.],
  tip-label: "How to use this step.",
)

// Handwriting-style text used only in the sample Round (macOS fonts first, serif italic as a fallback).
#let hand = ("Bradley Hand", "Noteworthy", "Marker Felt", "Libertinus Serif")
#let hw(body, size: 10pt) = text(font: hand, size: size, fill: luma(45), body)

#let round-head(num, title, mins, back: false) = block(width: 100%, stroke: (bottom: 1.4pt + black), inset: (bottom: 1.5mm), below: 2.5mm,
  grid(columns: (1fr, auto), column-gutter: 3mm, align: (left + bottom, right + bottom),
    {
      text(font: sans, size: 14pt, weight: "bold")[#if type(num) == str [#upper(num) #upper(round-text.name)] else [#upper(round-text.name) #num]#if back [ (back)]]
      h(2mm)
      text(font: sans, size: 9.5pt, weight: "bold", title)
    },
    text(font: sans, size: 7.5pt)[#mins · Name: #box(width: 26mm, stroke: (bottom: 0.5pt))[] Date: #box(width: 16mm, stroke: (bottom: 0.5pt))[]],
  ))

#let dotfill = tiling(size: (5mm, 5mm), place(center + horizon, circle(radius: 0.22mm, fill: luma(130))))
// Lay out `top`, then a writing canvas that fills the rest of the page, then `bottom`.
// Measured heights (not here().position()) so layout converges in one pass.
#let fill-page(top, fill, bottom: none, slack: 10mm, content: none) = layout(size => {
  let mt = measure(width: size.width, top).height
  let mb = if bottom == none { 0mm } else { measure(width: size.width, bottom).height }
  let h = calc.max(size.height - mt - mb - slack, 25mm)
  block(width: 100%, {
    top
    rect(width: 100%, height: h, stroke: 0.7pt + black, fill: fill, inset: if content == none { 0pt } else { 3mm }, content)
    bottom
  })
})
#let writebox(h) = rect(width: 100%, height: h, stroke: 0.7pt + black, fill: ruled-fill)

// One Interview Round = two pages (front and back, or a facing spread).
#let interview-round(
  num, title, ask,
  mins: "35 min",
  est-title: round-text.est-title,
  est-cols: ("Quantity", "Calculation", "Result"),
  est-rows: (),
  est-widths: (30%, 50%, 20%),
  sketch-title: round-text.sketch-title,
  sketch-h: auto,
  trade-rows: 3,
  twist: none,
  sample: none,
  ..ignored,
) = {
  let no-sketch = sketch-h == none
  let rh = if no-sketch { 15mm } else { 8.5mm }
  let smp = sample != none
  // filled ruled box (sample only)
  let fbox(h, body) = rect(width: 100%, height: h, stroke: 0.7pt + black, fill: ruled-fill, inset: (x: 2mm, top: 1.9mm), {
    set par(leading: 16.3pt, spacing: 16.3pt)
    hw(body)
  })
  let tip(n) = if smp {
    block(width: 100%, above: 0mm, below: 1.6mm, inset: (left: 2.2mm), stroke: (left: 1.4pt + black),
      text(font: sans, size: 7.8pt, fill: luma(60))[*#round-text.tip-label* #sample.tips.at(str(n))])
  }
  let ck = if smp { box(width: 3mm, height: 3mm, stroke: 0.7pt, baseline: 0.3mm, align(center + horizon, hw("x", size: 9pt))) } else { check }
  pagebreak(weak: true)
  // ---- front ----
  let front-top = {
    round-head(num, title, mins)
    block(width: 100%, stroke: 0.9pt + black, fill: luma(244), inset: 2.6mm, radius: 1.5mm, {
      lab(round-text.prompt-label)
      v(1mm)
      text(size: 10.3pt, style: "italic", ask)
    })
    if smp {
      v(1.6mm)
      block(width: 100%, stroke: (paint: black, thickness: 0.9pt, dash: "dashed"), inset: 2.2mm,
        text(font: sans, size: 8pt, round-text.sample-intro))
    }
    step(1, round-text.clarify-title, round-text.minutes.at(0))
    tip(1)
    grid(columns: (1fr, 1fr), gutter: 4mm,
      [#lab(round-text.clarify-left) #v(0.8mm) #if smp { fbox(40mm, sample.clarify-q) } else { writebox(32mm) }],
      [#lab(round-text.clarify-right) #v(0.8mm) #if smp { fbox(40mm, sample.clarify-a) } else { writebox(32mm) }],
    )
    if est-rows.len() > 0 {
      step(2, est-title, round-text.minutes.at(1))
      tip(2)
      table(
        columns: est-widths,
        inset: (x: 1.6mm, y: 0pt),
        table.header(..est-cols.map(c => table.cell(inset: (x: 1.6mm, y: 1.2mm), align(center, text(size: 8pt, c))))),
        ..est-rows.enumerate().map(((i, r)) => (
          table.cell(inset: (x: 1.6mm, y: 1.6mm), text(weight: "bold", size: 8pt, r)),
          if smp { table.cell(inset: (x: 1.6mm, y: 0pt), align: horizon, hw(sample.est.at(i).at(0), size: 9.5pt)) } else { [#v(rh)] },
          if smp { table.cell(inset: (x: 1.6mm, y: 0pt), align: horizon, hw(sample.est.at(i).at(1), size: 9.5pt)) } else { [] },
        )).flatten(),
      )
    }
    if no-sketch { step(3, round-text.dominates-title, "2 min") } else { step(3, sketch-title, round-text.minutes.at(2)) }
    tip(3)
  }
  fill-page(front-top, if no-sketch { ruled-fill } else { dotfill }, content: if smp { sample.sketch } else { none })
  // ---- back ----
  pagebreak()
  let back-top = {
    round-head(num, title, mins, back: true)
    step(4, round-text.defend-title, round-text.minutes.at(3))
    tip(4)
    table(
      columns: (22%, 24%, 30%, 24%),
      inset: (x: 1.6mm, y: 0pt),
      table.header(..round-text.defend-cols.map(c => table.cell(inset: (x: 1.6mm, y: 1.2mm), text(size: 8pt, c)))),
      ..if smp {
        sample.defend.map(r => r.map(c => table.cell(inset: (x: 1.6mm, y: 1.6mm), align: top, hw(c, size: 9pt)))).flatten()
      } else {
        range(trade-rows).map(_ => ([#v(16mm)], [], [], [])).flatten()
      },
    )
    if twist != none {
      step(5, round-text.twist-title, round-text.minutes.at(4))
      tip(5)
      block(width: 100%, stroke: (paint: black, thickness: 0.9pt, dash: "dashed"), inset: 2.4mm, {
        lab(round-text.twist-label)
        h(1.5mm)
        text(style: "italic", twist)
      })
    }
    v(1.5mm)
    lab(round-text.redraw-label)
    v(0.8mm)
  }
  let back-bottom = {
    v(1.5mm)
    lab(round-text.new-nums-label)
    v(0.8mm)
    if smp { fbox(30mm, sample.new-nums) } else { writebox(30mm) }
    v(1.5mm)
    lab(round-text.differently-label)
    v(0.8mm)
    if smp { fbox(15mm, sample.differently) } else { writebox(15mm) }
    v(2.4mm)
    text(font: sans, size: 8pt, {
      lab(round-text.self-score-label)
      h(2mm)
      for s in round-text.self-score { ck; [ #s]; h(2.5mm) }
    })
  }
  fill-page(back-top, dotfill, bottom: back-bottom, content: if smp { sample.redraw } else { none })
}

// Drill answer table: compact, replaces a full blank page.
#let drill-table(labels) = table(
  columns: (9%, 69%, 22%),
  inset: (x: 1.6mm, y: 0pt),
  table.header(..([Drill], [Working], [Answer + unit]).map(c => table.cell(inset: (x: 1.6mm, y: 1.2mm), c))),
  ..labels.map(l => (table.cell(inset: (x: 1.6mm, y: 1.6mm), text(weight: "bold", l)), [#v(13mm)], [])).flatten(),
)

// ---------- the quick-rule tear-out reference box ----------
#let quickref(title, body) = block(width: 100%, stroke: 1pt + black, inset: 3mm, breakable: false, {
  text(font: sans, weight: "bold", size: 9.5pt, title)
  v(1mm)
  body
})

#let part-band(body) = block(width: 100%, below: 4mm, stroke: (bottom: 3pt + black), inset: (bottom: 1.5mm), text(font: sans, size: 11pt, weight: "bold", tracking: 0.06em, upper(body)))

// Superscript that does not depend on font OpenType features (some system fonts render them as dots).
#let sup(x) = text(size: 0.66em, baseline: -0.42em, x)

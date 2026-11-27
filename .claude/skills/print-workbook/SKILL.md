---
name: print-workbook
description: Create or extend a print-first, pen-and-paper workbook (PDF built with Typst) for learning any subject, in the style of this repo's System Design Workbook. Use when the user wants a new workbook/study book for a topic, a new chapter or practice Round in an existing one, or wants to adapt this repo to another subject, audience or exam.
---

# print-workbook: build a learn-by-writing workbook for any subject

This repo is a working example: a System Design Workbook (interview prep) built with Typst. This skill turns the repo into a template so someone can produce a workbook for **any subject** (a language, an exam, a trade, anatomy, finance, a programming topic) with the same proven layout: concise theory, predict boxes, worked examples, checks that fill the page, and compact **practice Rounds** that mimic the real test, so no printed page is wasted.

Read `CLAUDE.md` at the repo root first when extending *this* book: it holds the locked rules. For a **new** book, the scaffold copies a generic version of those rules into the new project.

## 1. Interview the user (ask only what you cannot infer; at most one round of questions)

1. **Subject and goal.** What do they want to learn, and for what (exam, interview, job, hobby)?
2. **Audience and levels.** Beginner to expert? The depth markers (● Foundational, ◐ Mid, ◆ Advanced) are optional; rename or drop them.
3. **The "real test" shape.** How is the skill actually assessed or used? (viva question, case study, translation task, problem set, clinical vignette.) This becomes the Round format.
4. **Running example.** One fictional product/case/story reused in every worked example, so learners do not meet a new domain each chapter. Pick or invent one.
5. **Scope.** Number of chapters for Part I (4 to 8 is healthy), and what is out of scope.
6. **Licence and sources.** Default: text CC BY-SA 4.0, tooling MIT. Public sources may be cited and re-expressed, never pasted.
7. **Binding and paper.** Default A4, black and white, duplex, spiral bound, 20mm equal side margins. Letter is a one-line change in `lib.typ`.

Do not re-ask what the user already said. If they give only a subject, propose sensible defaults for 2 to 7 in one short message and proceed.

## 2. Scaffold

```bash
.claude/skills/print-workbook/scripts/new-book.sh <target-dir> "<Book Title>" "<Subject>"
```

This creates a self-contained project (its own `lib.typ`, `main.typ`, `Makefile`, licences, a generic `CLAUDE.md`, and stubs under `src/part1/`) from the templates in `templates/`. Then `cd <target-dir> && make` must succeed before you write any content. Install Typst first if missing (`brew install typst`).

Never edit the layout code in `lib.typ` just to change wording. Wording lives in two dictionaries at the top of `lib.typ`:

- `round-text`: every label in the practice Round (prompt label, step titles, table headers, self-score items, minutes). Re-skin for the subject, for example "Examiner says", "Plan the translation", "Diagnose".
- `callout-text`: the callout labels (Predict first, Key idea, Worked example (...), In the interview, Check yourself...). Change "(PorchLend)" to the new running example and "In the interview" to the real test ("In the exam", "In the viva").

If the Round's five-step shape does not fit the subject, change the step *titles and prompts* first. Only change the structure (number of steps) if the real test truly differs, and then update `interview-round` and `CLAUDE.md` together.

## 3. Plan before writing

Write a short plan file (`PLAN.md`): audience, chapter list with one learning goal each, the running example, the Round scenario per chapter, and the sources you will cite. Show it to the user. Chapters should build: each one uses ideas from the previous ones.

## 4. Write each chapter (the rhythm is the product; do not skip steps)

Use `templates/chapter.typ` as the skeleton. Order:

1. **Predict box**: one question to answer in writing *before* reading, with 4 writing lines.
2. **Concept sections**: short, one idea each, one diagram or table per idea. Optional tier callouts (`mid`, `deepen`).
3. **Worked example** on the running example, fully solved, numbers verified.
4. **"In the real test"** callout: what examiners probe and how to answer well.
5. **`checks-block`**: 3 to 5 numbered questions; it stretches to the bottom of its page automatically.
6. **`interview-round(...)`**: the two-page practice Round (front and back).
7. Add the chapter's answers, rubric, and tear-out `cards` to the answer key; add its sources to the sources page.

Also write once per book:
- **A finished sample Round** (`00b-sample.typ`) in italic "handwriting" style with a "How to use this step" note under each step. It must follow an arc the learner can copy: the estimate/analysis says "keep it simple", the twist forces a change. Use `templates/sample-round.typ`.
- **Front matter** (how to use, depth markers, the five steps, running example, licence, printing and spiral-binding note).

## 5. Quality rules (non-negotiable)

- **No blank filler pages.** Writing space exists only inside Rounds, predict lines, check lines, drill tables and "Draw it" boxes.
- **Space where the learner must write or draw**: shrink text boxes and table rows before drawing canvases. Never say "draw this" without a visible dotted `dotbox` or Round canvas.
- **Original content only.** Cite and re-express public sources; record each with its licence in `SOURCES.md`. No text from books, paid courses or restricted material. Do not credit claims to people without a checked source.
- **Verify every number and fact** you state (do the arithmetic; check the citation URL and what it actually says). Mark invented numbers "working value".
- **Trade-offs as conditions**, not verdicts, where the subject has trade-offs ("I would change my mind if...").
- **Define terms at first use.** Short sentences. Concrete before abstract.
- **Black and white safe**: shapes, borders and grey only.

## 6. Verify before saying it is done

1. `make` has no errors or warnings, and the page count is sensible.
2. Render and look at the pages: `typst compile main.typ out/p-{p}.png --format png --ppi 60 --pages N` (scratch images outside the repo).
3. Check every Round front and back fits one page; every Check-yourself block ends at the bottom margin; no heading or label orphaned at a page bottom; no page with a single stray line; icons render; equal left and right margins; Round headers on one line.
4. Re-read each chapter's answer-key entry against its questions.
5. Send the PDF to the user and name what you did not verify.

## 7. Typst pitfalls learned the hard way

See `reference/typst-pitfalls.md` before touching layout code. The big ones: never size fills with `here().position()` (oscillates) or `1fr` grid rows around `layout`; use `checks-block` and `fill-page`; use `sup()` not `#super`; use only bundled open fonts (`--ignore-system-fonts`); add the `#import "../../lib.typ": *` line to every chapter file.

## Files in this skill

- `scripts/new-book.sh`: scaffold a new project.
- `templates/`: `main.typ`, `front.typ`, `chapter.typ`, `sample-round.typ`, `answers.typ`, `sources.typ`, `CLAUDE.generic.md`.
- `reference/design-rules.md`: the design system (page, type, callouts, Round anatomy).
- `reference/typst-pitfalls.md`: layout bugs and their fixes.

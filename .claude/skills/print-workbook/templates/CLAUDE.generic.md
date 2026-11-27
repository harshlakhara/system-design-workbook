# __TITLE__: project rules

Print-first, pen-and-paper workbook (Typst PDF) for __SUBJECT__. Built from the `print-workbook` template. Read this file before editing.

## Locked decisions
- Toolchain: Typst. Build with `make` → `out/__SLUG__.pdf`. Entry `main.typ`, template `lib.typ`, content `src/part1/*.typ`.
- Licence: CC BY-SA 4.0 (text, figures), MIT (tooling).
- No blank worksheet pages; writing space only inside Rounds, predict lines, check lines, drill tables and "Draw it" boxes.
- Original content; cite public sources and record them in `SOURCES.md`. Running example: __RUNNING__ (fictional; never present its numbers as real).

## Layout rules
- A4, black and white, equal side margins (`x: 20mm`), spiral-binding friendly. Never use `inside`/`outside` margins or `pagebreak(to: ..)`.
- Wording lives in `round-text` and `callout-text` at the top of `lib.typ`; layout code has no user-facing literals.
- Check-yourself sections use `#checks-block((...))`; Round canvases use `fill-page`. Never size content with `here().position()`.
- Typography: body serif 11pt, headings sans, tables 9.3pt, callouts 10.6pt. Use `sup()` for superscripts. List only installed fonts.
- Round titles 40 characters or fewer. When space is tight shrink text boxes and rows, never drawing canvases.

## Chapter rhythm
Predict box, concepts, worked example on the running case, "in the real test" callout, `checks-block`, `interview-round`. Answers, rubric and cards in `07-answers.typ`; sources in `08-sources.typ`. Every chapter file starts with `#import "../../lib.typ": *`.

## Content rules
Concise theory; one idea per section; define terms at first use; verify every number and citation; mark invented numbers "working value"; state trade-offs as conditions; no unsupported attributions.

## Verify before done
1. `make` builds without warnings.
2. Render and look at changed pages (scratch images outside the repo).
3. No overflow, no orphaned heading, no single-line pages, Round header on one line, equal margins.
4. Send the PDF and say what was not verified.

See `.claude/skills/print-workbook/` (if present) for templates and pitfalls.

# System Design Workbook: project rules

Open-source, print-first workbook (PDF) for system design **interview prep**, written for pen and paper. Read this file before editing anything. Do not drift from these rules; if a rule must change, change it here first and tell the user.

## Locked decisions (do not re-litigate)
- Audience: interview prep first; usable from fresher to senior via depth markers.
- Licence: **CC BY-SA 4.0** for text and figures, **MIT** for tooling and templates. Files: `LICENSE` (which files are which), `LICENSE-CC-BY-SA.md` (scope, attribution, **verbatim** official legal code: never edit the legal text), `LICENSE-MIT.txt`. New content under `src/` is CC BY-SA; new code or templates are MIT; update the scope lists in `LICENSE` and both licence files if a new kind of file is added.
- Toolchain: **Typst** (0.15.1). Build with `make` → `out/system-design-workbook-part1.pdf`. Entry `main.typ`, template `lib.typ`, content in `src/part1/*.typ`.
- **No blank worksheet pages.** Writing space comes only from compact **Interview Round** templates (interviewer asks, candidate writes), plus predict lines, check lines and drill tables.
- Content is original. Public papers and engineering blogs may be cited and their facts re-expressed in our words; never paste text. Record every source in `SOURCES.md` with its licence, and list per-chapter sources in `src/part1/08-sources.typ`.
- Running example is **PorchLend** (fictional neighbourhood tool-lending app: 2M users, 400k DAU, 20k listings/day, ~3 photos each). Never present its numbers as real.

## Page and print rules
- A4, black and white only (greys allowed, no colour), ink-light, duplex, 100% scale.
- Margins: **equal on every page**: `x: 20mm, top: 17mm, bottom: 19mm`. Never use `inside`/`outside` (mirrored margins make content shift between pages). Page numbers are centred in the footer. The book is meant to be **spiral (coil) bound** so it lies flat for writing; the front matter says so. Keep the equal margins at least 20mm wide for the punch holes.
- Never force blank verso pages (no `to: "odd"`). Never leave a part-band or heading alone at the bottom or on its own page.
- Everything must survive black-and-white printing: use shapes, bold, borders and tints of grey, never colour to carry meaning.

## Typography (set in `workbook()`; do not override ad hoc in chapters)
- **Fonts: open-licence (SIL OFL) only.** Body `Source Serif 4`, headings/labels/tables `Source Sans 3`, sample "handwriting" `Caveat` (all Google Fonts, variable TTFs in `fonts/` with their `OFL-*.txt` licences), code `DejaVu Sans Mono` (bundled in Typst). `make` passes `--font-path fonts --ignore-system-fonts`, so nothing proprietary can be embedded and builds are identical everywhere. Adding a font: it must be OFL/Apache/MIT, its licence file goes in `fonts/`, and re-render every page afterwards (metrics change page breaks).
- Body: serif, **11pt**, `par(leading: 0.78em, spacing: 1.05em)`; list/enum spacing 0.75em.
- Headings and labels: the `sans` role (Source Sans 3). h1 via `h1-style`, h2 14pt bold, h3 11.5pt bold, both sticky.
- Code: `mono` role at 8.3pt.
- Tables: sans 9.3pt, inset `(x: 2mm, y: 1.7mm)`. Callout text 10.6pt (sources callouts 9pt).
- Small caps-style labels use `lab[...]` (7.5pt bold, tracked, uppercase).
- Superscripts use `sup(x)`, never `#super` (the system font renders it as dots).
- Do not reference fonts that are not in `fonts/` or bundled with Typst; builds run with `--ignore-system-fonts`.

## Depth markers
- ● Foundational, ◐ Mid-level, ◆ Senior+. Type the plain characters; `workbook()` replaces them with vector icons via `ico("F"|"M"|"S")`. Never swap in emoji or font glyph helpers.
- Keep icon rendering verified (tags, callout labels, tables, answer key) after any change to `lib.typ`.

## Chapter rhythm (every chapter, in this order)
1. Predict box (`callout("predict")`, 4 writing lines via `#lines(4)`).
2. Concept sections with one idea each; depth tiers as `callout("mid")` and `callout("deepen")`.
3. Worked example on PorchLend (`callout("worked")`).
4. `callout("interview")`: what interviewers probe and how to answer.
5. `#checks-block((` `[q1]`, `[q2]`, ... `))`: the Check-yourself section. It is an unbreakable `1fr` block, so it **always stretches to the bottom margin** of its page and spare height is shared among the answer lines (7mm minimum gap each). Never give it a fixed height, never read `here().position()` for it (it oscillates between pages), never fall back to `callout("checks")`. If the questions do not fit in the space left, pass `new-page: true` (currently needed in Chapters 2, 3 and 5; after any font or text change, re-render and check every chapter).
6. `#interview-round(...)`: two sheets (front and back).
7. Answers and rubric go into `src/part1/07-answers.typ`; add retrieval `cards` for new key facts. Sources go into `08-sources.typ`, not into per-chapter callouts.
- Every chapter file starts with `#import "../../lib.typ": *`. Chapter 1 opens with `#pagebreak(weak: true)` and `#part-band[...]` under the local `h1-style` override.

## Interview Round rules
- Five steps, always in this order: **Clarify, Estimate, Sketch, Defend, Adapt (twist)**.
- Defend wording is fixed: "I choose X over Y because R; I would change my mind if C."
- Front sheet: header, interviewer bubble, Clarify (two 32mm boxes), Estimate table (row height 8.5mm, 15mm if there is no sketch), Sketch dotted canvas filling the rest of the page.
- Back sheet: Defend table (rows 16mm), Twist box, "Redraw only what changes" dotted canvas, "New numbers and decisions" (30mm), "One thing I would do differently" (15mm), self-score checkboxes.
- Canvases are sized with `fill-page(top, fill, bottom:)`, which uses `layout` + `measure` with `slack: 10mm` (8mm spills; do not lower it). **Never** size a fill with `here().position()` (it converges to a wrong page) or `1fr` grid rows. After touching it, render pages and confirm every front and back fits exactly one page with nothing spilling.
- Round titles must be short (about 40 characters or fewer) so the header, a two-column grid with Name/Date pinned right, stays on one line. Check every front and back header after adding a Round.
- A Round must work if printed alone.
- **Sample Round** (`src/part1/00b-sample.typ`, right after the contents): a finished Round for a small PorchLend problem (view counter) written in Caveat (`hw()`); sample boxes use `fbox` with leading 13.3pt and top inset 4.2mm so text sits on the 7.6mm rules with a "How to use this step" note under each step. It is rendered by `interview-round(..., sample: (...))`, so it always matches the real template. It teaches the arc: the estimate says "keep it simple", the twist forces a change. Keep its numbers consistent (60 views/s peak, 20,000/s twist). A filled box holds at most 5 lines in 40mm; check nothing overflows.

## Space for drawing
- Wherever the text asks the reader to draw, there must be generous dotted space on the page: the Round's Sketch canvas (front) and "Redraw only what changes" canvas (back) take every spare millimetre, and any in-chapter "Draw it" prompt is a `callout("yourturn")` with a `dotbox(55mm or more)`. When trading space, shrink text boxes and table rows first, never drawing canvases.
- Never write "draw this on the canvas at the end of the chapter" without a canvas existing; point to the Round's sketch or add a `dotbox`.

## Content rules
- Concise theory, one diagram per idea, numbers on arrows, reasons on boxes.
- Every trade-off is a **condition**, not a verdict ("I would change my mind if...").
- Numbers are either marked "working value" (invented, rough) or carry year and citation. Anything older than ~5 years is a story, not a spec.
- Verify arithmetic (powers of ten, seconds per day = 10^5, etc.) and keep the answer key consistent with the questions.
- Define a term at first use. No unsupported attribution (for example do not credit a quote to a person without a checked source).
- Citations: link-check before adding; most sources are cite-only (SRE book CC BY-NC-ND, ACM papers, AWS, IETF RFCs © IETF Trust). Note the licence in `SOURCES.md`.

## Verification before telling the user it is done
1. `make` builds with no errors or warnings.
2. Render the changed pages to PNG (`typst compile main.typ out/x-{p}.png --format png --ppi 70 --pages N`; put scratch renders in the scratchpad, not the repo) and look at them.
3. Check: no overflow, no orphaned heading or label, no page holding a single stray line, icons correct, page count sensible (currently 48).
4. Re-send the PDF to the user after meaningful changes.

## Still open
- Part II (replication/partitioning, consistency/time, indexes/search/data modelling, APIs/idempotency/rate limiting, reliability, observability).
- Kafka paper has no verified authoritative URL; Reddit sentiment unchecked; `LICENSE-CC-BY-SA.md` needs the full legal text pasted.

## Reusable skill
`.claude/skills/print-workbook/` turns this repo into a template for other subjects (scaffold script, templates, pitfalls). Round and callout wording lives in `round-text` and `callout-text` at the top of `lib.typ`: **never hard-code user-facing strings in layout code**. If you change layout rules here, update the skill's `reference/` and `templates/CLAUDE.generic.md` too.

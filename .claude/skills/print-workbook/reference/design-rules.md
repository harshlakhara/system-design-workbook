# Design system (what `lib.typ` implements)

**Page.** A4, black and white (greys allowed), equal side margins `x: 20mm`, `top: 17mm`, `bottom: 19mm`, page number centred. Intended for duplex printing and spiral binding.

**Type.** Body serif 11pt (`Georgia`, fallback `Libertinus Serif`), `leading: 0.78em`, `spacing: 1.05em`. Headings and labels sans (`Helvetica Neue`, `Helvetica`, `Arial`). Code `Menlo` 8.3pt. Tables 9.3pt. Callouts 10.6pt. Small labels use `lab[...]` (7.5pt bold, tracked, uppercase).

**Depth markers.** ● Foundational, ◐ Mid-level, ◆ Senior+. Plain characters in the source; vector icons in the PDF. Rename or drop for other subjects, but keep three shapes that survive black and white.

**Callouts** (`callout(kind, body)`): `predict` (dashed, writing lines), `keyidea` (grey fill), `pitfall`, `worked` (light fill), `yourturn`, `mid`, `deepen`, `interview` (grey, left rule), `sources` (dotted, 9pt). The check-yourself section is **`checks-block`**, not a callout.

**Writing aids.** `lines(n)` ruled lines, `dotbox(h)` drawing area, `writebox(h)` ruled box, `check` checkbox, `drill-table(labels)` working table, `cards(items)` rotated-answer tear-out cards, `quickref(title, body)` cheat sheet, `part-band[...]`.

**Round anatomy** (`interview-round(num, title, prompt, ...)`; wording in `round-text`):
- Front: header (title on one line, Name/Date pinned right), prompt bubble, step 1 two boxes (32mm), step 2 table (rows 8.5mm; 15mm if no sketch), step 3 dotted canvas filling the rest of the page.
- Back: step 4 defend table (rows 16mm), step 5 twist box, a "redraw" canvas that fills the page, "new numbers" (30mm), "do differently" (15mm), self-score checkboxes.
- Titles 40 characters or fewer. Works if printed alone.

**Sample Round.** Same template with `sample: (...)` data: handwriting-style text (`hw()`), diagrams from `hflow`, and a note under each step.

**Chapter rhythm.** Predict, concepts, worked example, "in the real test", checks-block, Round. Answers and cards in the answer key; sources on the sources page.

**Space priority.** When a page is tight, shrink text boxes and table rows first, never the drawing canvases.

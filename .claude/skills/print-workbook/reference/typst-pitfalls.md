# Typst pitfalls (all hit while building this workbook)

| Symptom | Cause | Fix |
|---|---|---|
| `unknown variable: callout` in a chapter | chapter files are separate modules | start every chapter with `#import "../../lib.typ": *` |
| Page count explodes, canvas jumps to next page, "context position did not stabilize" | sizing a fill from `here().position()` makes the layout oscillate between pages | never use `here().position()` to size content. Use `fill-page` (measure based) for Round canvases and `checks-block` (a `1fr`, unbreakable block) for check questions |
| Last line of a Round back lands on its own page | unmeasured block spacing between measured parts | `fill-page` keeps `slack: 10mm`; do not lower it (8mm spills) |
| Check-yourself box does not fill its page | `callout("checks")` is natural height | use `#checks-block((...))`; pass `new-page: true` if the questions do not fit in the space left |
| Superscripts render as dots | the system font has no superscript feature | use `sup(x)` from `lib.typ`, not `#super` |
| `unknown font family` warnings | font not installed | list only fonts that exist (`typst fonts`); keep a bundled fallback (Libertinus Serif) last |
| Icons (●, ◐, ◆) look tiny or off | font glyphs differ per font | the workbook replaces them with vector icons via `show "●": ico(..)`; type the plain characters |
| Page shifts sideways between pages | mirrored `inside`/`outside` margins | use equal `x:` margins |
| Blank verso pages | `pagebreak(to: "odd")` | never use `to:` |
| A heading or callout label orphaned at a page bottom | non-sticky headings | headings and callout labels are `sticky: true`; keep long callouts breakable with a sticky label block |
| A table moves whole to the next page, leaving white space | tables are unbreakable by default in some layouts | accept it for short tables; for long tables set `breakable` or split them |
| Handwriting font renders `~` as a blank | glyph missing in Bradley Hand | avoid `~` in sample text (write "about") |
| Handwriting rows do not sit on the ruled lines | line pitch mismatch | the sample uses `fbox` with `leading: 16.3pt` for 7.6mm rules; adjust both together |
| `measure` warnings "did not stabilize" | measured content depends on layout position | measure only static content; avoid counters/locations inside measured blocks |

## Debugging recipe
1. `typst compile main.typ out/x.pdf 2>&1 | head` and read the *first* warning; convergence warnings point at the real cause.
2. Render single pages: `typst compile main.typ "out/p-{p}.png" --format png --ppi 60 --pages 7,8`.
3. For layout numbers, print them in the page (`[#value]`), extract text, then remove the debug line.

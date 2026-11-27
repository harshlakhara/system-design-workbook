# System Design Workbook (draft 0.1, Part I)

A print-first, pen-and-paper workbook for **system design interview preparation**. Every chapter ends with an
*Interview Round*: a two-page (front and back) template where the interviewer asks a question and you answer on paper
(clarify, estimate, sketch, defend, handle the twist). There are no blank filler pages.

- Output: `out/system-design-workbook-part1.pdf` (A4, black and white, duplex friendly; spiral binding recommended so it lies flat)
- Build: install [Typst](https://typst.app) (`brew install typst`), then `make`. The build uses only Typst's bundled open fonts (Libertinus Serif, DejaVu Sans Mono; SIL OFL), so the PDF is identical on every machine and embeds no proprietary fonts
- Layout: `main.typ` (assembly), `lib.typ` (templates), `src/part1/*.typ` (chapters), `PHASE1-research-and-proposal.md` (research and plan)
- Licences: text and figures CC BY-SA 4.0 (`LICENSE-CC-BY-SA.md`), code and templates MIT (`LICENSE-MIT.txt`); see `LICENSE` for which files are which
- Contributing: original content only. Cite public papers and blogs, record them in `SOURCES.md`, never paste from books or paid courses.

Status: Part I drafted (foundations, six chapters, six Interview Rounds, answer key, retrieval cards).
Citations were link-checked on 2026-11-27 (see `SOURCES.md`); the Kafka paper still lacks an authoritative URL.

## Make your own workbook (any subject)

This repo includes a Claude Code skill, `.claude/skills/print-workbook`, that scaffolds a new workbook with the same layout (predict boxes, worked examples, check questions that fill the page, practice Rounds, a finished sample Round) for any subject. In Claude Code, ask for a workbook on your topic, or run `.claude/skills/print-workbook/scripts/new-book.sh <dir> "<Title>" "<Subject>"` and follow `SKILL.md`.

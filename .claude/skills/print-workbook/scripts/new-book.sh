#!/usr/bin/env bash
# Scaffold a new print-first workbook from this repo's template.
# Usage: new-book.sh <target-dir> "<Book Title>" "<Subject>" ["<Running example>"] ["<Learner goal>"]
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "usage: $0 <target-dir> \"<Book Title>\" \"<Subject>\" [\"<Running example>\"] [\"<Learner goal>\"]" >&2
  exit 1
fi
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="$(cd "$SKILL_DIR/../../.." && pwd)"
TARGET="$1"; TITLE="$2"; SUBJECT="$3"; RUNNING="${4:-the running example}"; GOAL="${5:-learning $SUBJECT}"
SLUG="$(printf '%s' "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
[ -n "$SLUG" ] || SLUG="workbook"

if [ -e "$TARGET" ] && [ -n "$(ls -A "$TARGET" 2>/dev/null)" ]; then
  echo "error: $TARGET exists and is not empty" >&2; exit 1
fi
command -v typst >/dev/null || echo "warning: typst not found (brew install typst); scaffold will still be created" >&2

mkdir -p "$TARGET/src/part1" "$TARGET/out"
cp "$ROOT/lib.typ" "$TARGET/lib.typ"
cp -R "$ROOT/fonts" "$TARGET/fonts"
cp "$ROOT/LICENSE-MIT.txt" "$TARGET/LICENSE-MIT.txt"
# CC BY-SA: keep the official legal code verbatim, replace this book's scope and attribution header with a generic one.
{
  printf '# Licence for text and figures: CC BY-SA 4.0\n\nThe written content and figures of this book (everything under `src/`, `README.md`, `SOURCES.md` and the built PDF)\nare licensed under **Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)**.\nSummary: https://creativecommons.org/licenses/by-sa/4.0/\n\nCode and templates (`lib.typ`, `main.typ`, `Makefile`, `CLAUDE.md`) are MIT: see `LICENSE-MIT.txt`.\nTODO: add a suggested attribution line (title, author, URL) here once the book is published.\nThird-party works cited keep their own licences (see `SOURCES.md`).\n\n---\n\n'
  sed -n '/^The text below is the unmodified legal code/,$p' "$ROOT/LICENSE-CC-BY-SA.md"
} > "$TARGET/LICENSE-CC-BY-SA.md"
cat > "$TARGET/LICENSE" <<LIC
This repository uses two licences, split by kind of file.

1. Text and figures: CC BY-SA 4.0 (src/**, README.md, SOURCES.md, the built PDF). See LICENSE-CC-BY-SA.md
2. Code and templates: MIT (lib.typ, main.typ, Makefile, CLAUDE.md). See LICENSE-MIT.txt

Third-party works cited in the book keep their own licences (see SOURCES.md).
LIC

sub() { # sub <template> <dest>
  sed -e "s|__TITLE__|$TITLE|g" -e "s|__SUBJECT__|$SUBJECT|g" -e "s|__SLUG__|$SLUG|g" \
      -e "s|__RUNNING__|$RUNNING|g" -e "s|__GOAL__|$GOAL|g" -e "s|__CHAPTER_TITLE__|First chapter|g" "$1" > "$2"
}
T="$SKILL_DIR/templates"
sub "$T/main.typ"          "$TARGET/main.typ"
sub "$T/front.typ"         "$TARGET/src/part1/00-front.typ"
sub "$T/sample-round.typ"  "$TARGET/src/part1/00b-sample.typ"
sub "$T/chapter.typ"       "$TARGET/src/part1/01-first-chapter.typ"
sub "$T/answers.typ"       "$TARGET/src/part1/07-answers.typ"
sub "$T/sources.typ"       "$TARGET/src/part1/08-sources.typ"
sub "$T/CLAUDE.generic.md" "$TARGET/CLAUDE.md"

cat > "$TARGET/Makefile" <<MK
# Build the workbook PDF. Requires Typst (https://typst.app, \`brew install typst\`).
PDF = out/$SLUG.pdf

all: \$(PDF)

\$(PDF): main.typ lib.typ \$(wildcard src/*/*.typ)
	@mkdir -p out
	typst compile --font-path fonts --ignore-system-fonts main.typ \$(PDF)

watch:
	typst watch --font-path fonts --ignore-system-fonts main.typ \$(PDF)

clean:
	rm -f \$(PDF)
MK

cat > "$TARGET/SOURCES.md" <<SRC
# Sources

Every external source used in the book: title, author, year, URL, licence seen, date link-checked.

| Source | URL | Licence | Checked | Used for |
|---|---|---|---|---|
SRC

cat > "$TARGET/README.md" <<RD
# $TITLE

A print-first, pen-and-paper workbook for $SUBJECT. Build: install [Typst](https://typst.app), then \`make\` (output \`out/$SLUG.pdf\`).
Licences: text and figures CC BY-SA 4.0, tooling MIT. Original content only; cite sources in \`SOURCES.md\`.
RD

echo "Created $TARGET"
echo "Next: cd \"$TARGET\" && make   (then edit lib.typ round-text / callout-text, write PLAN.md, fill the TODOs)"

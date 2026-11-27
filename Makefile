# Build the workbook PDF. Requires Typst (https://typst.app, `brew install typst`).
PDF = out/system-design-workbook-part1.pdf

all: $(PDF)

$(PDF): main.typ lib.typ $(wildcard src/*/*.typ)
	@mkdir -p out
	typst compile main.typ $(PDF)

watch:
	typst watch main.typ $(PDF)

clean:
	rm -f $(PDF)

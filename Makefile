# Build the workbook PDF. Requires Typst (https://typst.app, `brew install typst`).
PDF = out/system-design-workbook-part1.pdf

all: $(PDF)

$(PDF): main.typ lib.typ $(wildcard src/*/*.typ)
	@mkdir -p out
	typst compile --font-path fonts --ignore-system-fonts main.typ $(PDF)

watch:
	typst watch --font-path fonts --ignore-system-fonts main.typ $(PDF)

clean:
	rm -f $(PDF)

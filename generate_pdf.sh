#!/bin/sh

fold -sw 80 ThoughtsOnWebServer.md > wrapped.md
pandoc --toc --top-level-division=chapter --latex-engine=xelatex --template=template.tex wrapped.md -t latex > ThoughtsOnWebServer.latex
pandoc --toc --top-level-division=chapter --latex-engine=xelatex --template=template.tex wrapped.md -t latex -o ThoughtsOnWebServer.pdf

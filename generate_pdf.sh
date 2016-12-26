#!/bin/sh

fold -sw 80 Book.md > wrapped.md
pandoc --toc --top-level-division=chapter --latex-engine=xelatex --template=template.tex wrapped.md -t latex > ThoughtsOnJBossWebServer.latex
pandoc --toc --top-level-division=chapter --latex-engine=xelatex --template=template.tex wrapped.md -t latex -o ThoughtsOnJBossWebServer.pdf

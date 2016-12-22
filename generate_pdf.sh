#!/bin/sh

fold -sw 75 -s Book.md > wrapped.md
pandoc --toc --chapters wrapped.md -t latex > ThoughtsOnJBossWebServer.latex
pandoc --toc --chapters wrapped.md -t latex -o ThoughtsOnJBossWebServer.pdf

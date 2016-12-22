#!/bin/sh

fold -w 80 -s Book.md > wrapped.md
pandoc --toc --chapters wrapped.md -t latex -o ThoughtsOnJBossWebServer.pdf

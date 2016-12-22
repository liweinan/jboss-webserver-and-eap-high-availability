#!/bin/sh

fold -w 80 -s Book.md > wrapped.md
pandoc wrapped.md -t latex -o ThoughtsOnJBossWebServer.pdf

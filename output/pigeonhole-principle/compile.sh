#!/usr/bin/env bash
# Build this Loom notebook with XeLaTeX (runs the needed two passes via latexmk).
set -e
cd "$(dirname "$0")"
if command -v latexmk >/dev/null 2>&1; then
  latexmk -xelatex -interaction=nonstopmode -file-line-error main.tex
else
  xelatex -interaction=nonstopmode main.tex
  xelatex -interaction=nonstopmode main.tex
fi
echo "Built: $(dirname "$0")/main.pdf"

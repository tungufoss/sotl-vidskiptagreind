#!/usr/bin/env sh
# Compile each TikZ figure to a responsive SVG for the Quarto site.
# Needs pdflatex (with standalone, lm, pgf) and pdftocairo (poppler).
set -e
cd "$(dirname "$0")"
for f in LCF-tikz-is course-flow-is; do
  printf '%s\n' \
    '\documentclass[tikz,border=4pt]{standalone}' \
    '\usepackage[utf8]{inputenc}' \
    '\usepackage[T1]{fontenc}' \
    '\usepackage{lmodern}' \
    '\usetikzlibrary{fit,matrix,backgrounds}' \
    '\begin{document}' \
    "\\input{$f}" \
    '\end{document}' > "_$f.tex"
  pdflatex -interaction=nonstopmode -halt-on-error "_$f.tex" >/dev/null
  pdftocairo -svg "_$f.pdf" "$f.svg"
  # Drop the fixed width/height so the SVG scales with its container (viewBox keeps the aspect ratio)
  sed -i '0,/<svg /s/ width="[^"]*" height="[^"]*"//' "$f.svg"
  rm -f "_$f".*
done

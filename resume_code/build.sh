#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "==> Fetching publications from Web of Science..."
python3 fetch_publications.py

echo "==> Compiling resume with Typst..."
typst compile mnoetel_resume.typ mnoetel_resume.pdf

echo "==> Copying PDF to repo root..."
cp mnoetel_resume.pdf ../mnoetel_resume.pdf

echo "==> Done! Resume at mnoetel_resume.pdf"

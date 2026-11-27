#!/usr/bin/env bash
# Usage: apply-colors.sh <image> <dark|light> <scheme> <colors.json>
# Generates colors from the image into colors.json, then runs every apply-*.py on it.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
image="$1" mode="$2" scheme="$3" colors="$4"

python3 "$dir/generate-colors.py" "$image" --mode "$mode" --scheme "$scheme" -o "$colors"

for apply in "$dir"/apply-*.py; do
    python3 "$apply" "$colors" || echo "$(basename "$apply") failed" >&2
done

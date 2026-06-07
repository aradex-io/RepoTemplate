#!/usr/bin/env bash
#
# test.sh — Run the full test suite. Replace the body for your stack.
# Must exit non-zero on any failure so CI and agents can trust it.
#
set -euo pipefail
cd "$(dirname "$0")/.."

echo ">> test: starting"

if [[ -f package.json ]] && grep -q '"test"' package.json; then
  npm test
elif [[ -f pyproject.toml ]]; then
  python -m pytest -q
elif [[ -f go.mod ]]; then
  go test ./...
else
  echo ">> no test runner configured. Add yours to scripts/test.sh." >&2
  echo ">> (template ships green so CI passes out of the box)"
fi

echo ">> test: done"

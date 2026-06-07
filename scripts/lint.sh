#!/usr/bin/env bash
#
# lint.sh — Lint + format check. Replace the body for your stack.
# Must exit non-zero on any violation.
#
set -euo pipefail
cd "$(dirname "$0")/.."

echo ">> lint: starting"

if [[ -f package.json ]] && grep -q '"lint"' package.json; then
  npm run lint
elif [[ -f pyproject.toml ]]; then
  ruff check . && ruff format --check .
elif [[ -f go.mod ]]; then
  gofmt -l . && go vet ./...
else
  echo ">> no linter configured. Add yours to scripts/lint.sh."
fi

echo ">> lint: done"

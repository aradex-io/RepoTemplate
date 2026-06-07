#!/usr/bin/env bash
#
# bootstrap.sh — Set up the development environment.
#
# This is a project-agnostic stub. Replace the body with your project's real
# setup (e.g. `npm ci`, `uv sync`, `go mod download`, `make deps`). Keep it
# idempotent so it is safe to run repeatedly and from CI / SessionStart hooks.
#
set -euo pipefail
cd "$(dirname "$0")/.."

echo ">> bootstrap: starting"

# --- Example detection-based setup; adapt to your stack ---------------------
if [[ -f package.json ]]; then
  echo ">> detected Node project — run: npm ci"
elif [[ -f pyproject.toml ]]; then
  echo ">> detected Python project — run: uv sync  (or pip install -e .[dev])"
elif [[ -f go.mod ]]; then
  echo ">> detected Go project — run: go mod download"
else
  echo ">> no recognized manifest; nothing to install (edit scripts/bootstrap.sh)"
fi

echo ">> bootstrap: done"

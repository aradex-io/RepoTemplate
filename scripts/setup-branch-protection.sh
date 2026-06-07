#!/usr/bin/env bash
#
# setup-branch-protection.sh — Make `main` the default branch and apply the
# repository ruleset in .github/rulesets/main-branch-protection.json.
#
# Branch rulesets and the default-branch setting are NOT copied when you create a
# repo from a template, so run this once after adopting the template. Requires
# the GitHub CLI (`gh`) authenticated with admin rights on the repo.
#
# Usage:
#   scripts/setup-branch-protection.sh                 # current repo (from `gh`)
#   scripts/setup-branch-protection.sh owner/repo      # explicit target
#
set -euo pipefail
cd "$(dirname "$0")/.."

RULESET=".github/rulesets/main-branch-protection.json"

if ! command -v gh >/dev/null 2>&1; then
  echo "error: GitHub CLI 'gh' not found. Install it: https://cli.github.com" >&2
  echo "       (or import ${RULESET} via Settings -> Rules -> Rulesets -> Import)" >&2
  exit 127
fi
[[ -f "$RULESET" ]] || { echo "error: $RULESET not found" >&2; exit 1; }

REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"

echo ">> ensuring 'main' is the default branch on ${REPO}"
gh api -X PATCH "repos/${REPO}" -f default_branch=main >/dev/null

echo ">> applying ruleset from ${RULESET}"
gh api -X POST "repos/${REPO}/rulesets" --input "${RULESET}" >/dev/null

echo ">> done — main is default and protected (PR required, CI must pass, no"
echo "   direct pushes, no force-push, no deletion, linear history)."

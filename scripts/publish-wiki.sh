#!/usr/bin/env bash
#
# publish-wiki.sh — Publish the docs/ wiki to the GitHub repository Wiki.
#
# GitHub wikis are a SEPARATE git repo (OWNER/REPO.wiki.git) with flat page files.
# This script clones that repo, regenerates its pages FROM docs/ (single source of
# truth — nothing is duplicated in the code repo), rewrites links for the wiki,
# writes a sidebar, and pushes.
#
# Prereqs:
#   * The wiki must exist — create one page once via the GitHub UI (Wiki tab →
#     "Create the first page") to initialize OWNER/REPO.wiki.git.
#   * git auth that can push to the wiki (same as your normal GitHub push).
#
# Usage:
#   scripts/publish-wiki.sh                 # infer owner/repo from origin
#   scripts/publish-wiki.sh owner/repo      # explicit
#   WIKI_REMOTE=git@github.com:o/r.wiki.git scripts/publish-wiki.sh   # SSH override
#   DRY_RUN=1 scripts/publish-wiki.sh       # build pages, skip commit/push
#
set -euo pipefail
cd "$(dirname "$0")/.."

BRANCH_FOR_LINKS="${WIKI_LINK_BRANCH:-main}"

# Resolve owner/repo.
if [[ -n "${1:-}" ]]; then
  REPO="$1"
else
  url="$(git remote get-url origin 2>/dev/null || true)"
  # Strip .git, the ssh "git@host:" prefix, the "scheme://host/" prefix, and a
  # leading proxy "git/" segment — leaving "owner/repo".
  REPO="$(printf '%s' "$url" | sed -E 's#\.git$##; s#^git@[^:]+:##; s#^[a-z]+://[^/]+/##; s#^git/##')"
fi
[[ "$REPO" == */* ]] || { echo "error: could not determine owner/repo; pass it as an argument." >&2; exit 2; }

WIKI_REMOTE="${WIKI_REMOTE:-https://github.com/${REPO}.wiki.git}"
echo ">> repo: ${REPO}"
echo ">> wiki: ${WIKI_REMOTE}"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo ">> cloning wiki..."
if ! git clone --quiet "$WIKI_REMOTE" "$WORK/wiki" 2>/dev/null; then
  cat >&2 <<MSG
error: could not clone ${WIKI_REMOTE}
  The wiki may not be initialized yet. Open the repo's Wiki tab on GitHub and
  create the first page once, then re-run this script.
MSG
  exit 1
fi

echo ">> generating pages from docs/ ..."
REPO="$REPO" BRANCH="$BRANCH_FOR_LINKS" OUT="$WORK/wiki" python3 scripts/lib/wiki_render.py

cd "$WORK/wiki"
git add -A
if git diff --cached --quiet; then
  echo ">> wiki already up to date — nothing to publish."
  exit 0
fi

if [[ "${DRY_RUN:-0}" == "1" ]]; then
  echo ">> DRY_RUN: generated pages (not pushed):"
  git --no-pager diff --cached --stat
  exit 0
fi

git commit --quiet -m "docs(wiki): sync from docs/ ($(date -u +%Y-%m-%d))"
echo ">> pushing wiki..."
git push --quiet origin HEAD
echo ">> done — published to the GitHub wiki."

#!/usr/bin/env bash
#
# check-changelog.sh — Fail if source changed without a CHANGELOG.md update.
#
# Compares the current branch against a base ref (default: origin/main). If any
# tracked source files changed but CHANGELOG.md did not, exit non-zero — unless
# the change is explicitly opted out with a `changelog: none` commit footer or
# the CHANGELOG_SKIP env var is set (used for the `changelog: none` PR label).
#
set -euo pipefail

BASE_REF="${1:-${BASE_REF:-origin/main}}"

# Paths whose changes require a changelog entry.
WATCH_REGEX='^(src/|scripts/|\.github/workflows/)'

if [[ "${CHANGELOG_SKIP:-}" == "true" ]]; then
  echo "check-changelog: skipped via CHANGELOG_SKIP."
  exit 0
fi

if ! git rev-parse --verify "${BASE_REF}" >/dev/null 2>&1; then
  echo "check-changelog: base ref '${BASE_REF}' not found; skipping (likely first commit)."
  exit 0
fi

CHANGED="$(git diff --name-only "${BASE_REF}"...HEAD)"

# Honest opt-out: any commit in the range may carry a `changelog: none` footer.
if git log "${BASE_REF}"..HEAD --format='%b' | grep -qiE '^changelog:\s*none'; then
  echo "check-changelog: 'changelog: none' footer found; skipping."
  exit 0
fi

if echo "${CHANGED}" | grep -qE "${WATCH_REGEX}"; then
  if echo "${CHANGED}" | grep -qx 'CHANGELOG.md'; then
    echo "check-changelog: OK — source changed and CHANGELOG.md was updated."
    exit 0
  fi
  echo "::error::Source files changed but CHANGELOG.md was not updated." >&2
  echo "Add an entry under '## [Unreleased]' in CHANGELOG.md, or use a" >&2
  echo "'changelog: none' commit footer for internal-only changes." >&2
  exit 1
fi

echo "check-changelog: OK — no watched source paths changed."

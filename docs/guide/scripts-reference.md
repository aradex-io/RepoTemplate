# Scripts reference

Everything in [`scripts/`](../../scripts) is the seam between humans, agents, and
CI — they all call these wrappers, never raw tools. Scripts are POSIX-friendly
Bash, `set -euo pipefail`, and executable (`chmod +x scripts/*.sh`).

## `bootstrap.sh`

Set up the dev environment. **Stub** — detects the manifest (`package.json`,
`pyproject.toml`, `go.mod`) and prints the install command; replace the body with
your real setup. Idempotent so it's safe from CI and the SessionStart hook.

- **Args/env:** none. **Exit:** `0`.

## `test.sh`

Run the full test suite. **Stub** that dispatches by stack and otherwise exits `0`.

- **Exit:** non-zero on any failure — CI and agents rely on this. Wire it to your
  real runner before trusting CI.

## `lint.sh`

Lint + format check. **Stub** that dispatches by stack and otherwise exits `0`.

- **Exit:** non-zero on any violation.

> ⚠️ `bootstrap.sh`, `test.sh`, and `lint.sh` ship as **no-op stubs that exit 0**
> so CI is green out of the box — they check nothing until you wire them up.

## `codex-review.sh <plan.md>`

Review a plan and append `## Appendix: Plan Review`. Full detail in
[plan review](./plan-review.md).

- **Args:** path to a plan markdown file (required).
- **Env:** `CODEX_REVIEW_MODEL`, `REVIEW_BACKEND`, `REVIEW_FALLBACK_CMD`.
- **Exit:** `0` ok · `1` missing/empty · `2` usage · `3` no reviewer · `127` backend binary missing.

## `check-changelog.sh [base-ref]`

Fail if watched source changed without a `CHANGELOG.md` update. Full logic in
[version control & changelog](./version-control-and-changelog.md#check-changelogsh-internals).

- **Args:** base ref (default `origin/main`).
- **Env:** `CHANGELOG_SKIP=true` to skip; honors `changelog: none` commit footers.
- **Watched paths:** `src/`, `scripts/`, `.github/workflows/`.
- **Exit:** `0` ok/skipped · `1` source changed without a changelog entry.

## `setup-branch-protection.sh [owner/repo]`

Set `main` as default and apply the ruleset via `gh`. Full detail in
[branch protection](./branch-protection.md).

- **Args:** `owner/repo` (default: current repo via `gh`).
- **Requires:** `gh` with admin. **Exit:** `0` ok · `1` ruleset file missing · `127` no `gh`.

## Conventions for new scripts

- Put automation here and call it from CI — keep CI YAML thin.
- `set -euo pipefail`; clear usage on bad args; meaningful exit codes.
- Print progress to **stderr** so stdout stays usable for piping.

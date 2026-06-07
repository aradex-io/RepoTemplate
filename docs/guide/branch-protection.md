# Branch protection

The default branch is **`main`**, and it ships with a ruleset that **enforces**
what CLAUDE.md §2 only states. The policy lives in
[`.github/rulesets/main-branch-protection.json`](../../.github/rulesets/main-branch-protection.json).

> GitHub copies the **default branch** into repos created from a template, but it
> does **not** copy rulesets. Applying the ruleset is a one-time setup step.

## What the ruleset enforces

Target: `~DEFAULT_BRANCH` (whatever branch is default — robust to renames).
Enforcement: `active`.

| Rule | Effect |
|------|--------|
| `deletion` | The default branch cannot be deleted. |
| `non_fast_forward` | No force-pushes. |
| `required_linear_history` | No merge commits — rebase/squash only. |
| `pull_request` | Changes must land via PR. `required_approving_review_count: 0` (solo-friendly), stale reviews dismissed on push, review threads must be resolved. |
| `required_status_checks` | These checks must pass before merge, and the branch must be up to date (`strict`): **`Lint`**, **`Test`**, **`Conventional Commits`**, **`Changelog updated`**. |

The status-check contexts are the **job names** from the CI workflows — see
[CI/CD](./ci-cd-and-releases.md). If you rename a job, update it here too.

## Applying it

```bash
# GitHub CLI (sets main as default, then imports the ruleset):
scripts/setup-branch-protection.sh                 # current repo
scripts/setup-branch-protection.sh owner/repo      # explicit target
```

What the script does:

1. `gh api -X PATCH repos/<repo> -f default_branch=main`
2. `gh api -X POST repos/<repo>/rulesets --input .github/rulesets/main-branch-protection.json`

Requires `gh` authenticated with admin on the repo; exits `127` if `gh` is
missing. UI alternative: **Settings → Rules → Rulesets → New → Import a ruleset →**
pick the JSON file.

## Tuning

- **Teams**: raise `required_approving_review_count` to `1`+ in the JSON.
- **Required checks**: add/remove entries under `required_status_checks` to match
  your CI job names.
- **Bypass**: add entries to `bypass_actors` (e.g. a release bot) if you need an
  escape hatch; it ships empty (no bypass) for maximum strictness.

## Why a ruleset (not classic branch protection)

Rulesets are exportable/importable as JSON, so the policy is **version-controlled
and reviewable** in the repo rather than living only in repo settings — the same
"auditable in git" principle as the plan-review appendices.

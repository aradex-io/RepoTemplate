# Version control & changelog

The enforced rules from CLAUDE.md §2–§3, at the mechanism level. For the policy
rationale and the full commit-type table, see [`VERSIONING.md`](../../VERSIONING.md).

## Branch model

- `main` is the default and **protected** branch — never commit to it directly.
  See [branch protection](./branch-protection.md).
- All work happens on a branch named for its type:

  | Prefix | For |
  |--------|-----|
  | `feat/<slug>` | a new feature |
  | `fix/<slug>` | a bug fix |
  | `docs/<slug>` | docs only |
  | `chore/<slug>` | tooling/maintenance |
  | `claude/<task>` | a session-assigned agent branch |

- Create the branch **before** the first edit. Land changes on `main` via PR with
  green CI. Push with `git push -u origin <branch>`; never force-push a shared
  branch.

## Conventional Commits

```
type(scope): subject        # imperative, ≤ 72 chars, no trailing period

body                        # optional: the "why", wrapped ~72 cols

footer                      # optional: BREAKING CHANGE:, changelog: none, Refs: #123
```

- Allowed types: `feat fix docs style refactor perf test build ci chore revert`.
- Breaking change: `type(scope)!: …` **and** a `BREAKING CHANGE:` footer → MAJOR.
- **Atomic**: one logical change per commit; don't mix a refactor with a feature.
- **Green**: don't commit code that fails build/lint/tests (unless an explicitly
  marked `wip:` checkpoint that is never pushed to a shared branch).

CI validates every commit subject on a PR — see the `commit-lint` job in
[CI/CD](./ci-cd-and-releases.md).

## Changelog contract

The project keeps a [Keep a Changelog](https://keepachangelog.com) file.

- Add an entry under `## [Unreleased]` **in the same commit** as the change.
- Use the correct group: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`,
  `Security`.
- Write for humans — *what* changed and *why it matters*, not the diff.
- Internal-only changes (tests, CI, pure docs) may opt out **honestly** with a
  `changelog: none` commit footer or the `changelog: none` PR label.

### `check-changelog.sh` internals

The `changelog` workflow runs `scripts/check-changelog.sh <base-ref>` on PRs. Its
logic:

1. Skip if `CHANGELOG_SKIP=true` (used by the `changelog: none` label).
2. Skip if the base ref doesn't exist (e.g. the very first commit).
3. Skip if any commit in the range carries a `changelog: none` footer.
4. Otherwise, look at the changed files. If any match the **watched paths**
   (`src/`, `scripts/`, `.github/workflows/`) and `CHANGELOG.md` was **not** also
   changed → exit `1` and fail the PR.

So a change under a watched path must either touch `CHANGELOG.md` or be explicitly
opted out. Paths outside the watch list (e.g. `README.md`, `docs/`) don't require
a changelog entry — but adding one for user-visible docs is good hygiene.

## Releases

Releases move `Unreleased` items into a dated, versioned section and bump the
version per SemVer. The full procedure (and the tag-driven publish) is in
[CI/CD & releases](./ci-cd-and-releases.md#releases) and `VERSIONING.md`.

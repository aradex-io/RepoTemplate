# CI/CD & releases

Three workflows live in [`.github/workflows/`](../../.github/workflows). All call
the wrapper scripts in `scripts/` so CI and humans run the exact same commands.

## `ci.yml` — on every push to `main` and every PR

Concurrency-guarded (superseded runs on the same ref are cancelled). Permissions:
`contents: read`.

| Job | Runs | Fails when |
|-----|------|-----------|
| **Lint** | `./scripts/bootstrap.sh` then `./scripts/lint.sh` | the linter reports problems |
| **Test** | `./scripts/bootstrap.sh` then `./scripts/test.sh` | a test fails |
| **Conventional Commits** *(PR only)* | validates each commit subject in the PR range against the Conventional Commits regex | any subject doesn't match |

> The job **names** (`Lint`, `Test`, `Conventional Commits`) are the status-check
> contexts referenced by the branch-protection ruleset — keep them in sync if you
> rename jobs.

## `changelog.yml` — on PRs

Runs unless the PR carries the **`changelog: none`** label. Checks out full
history and runs `scripts/check-changelog.sh origin/<base>`. Job name:
**`Changelog updated`** (also a required-check context). See
[the changelog contract](./version-control-and-changelog.md#changelog-contract)
for the exact pass/fail logic.

## `release.yml` — on a version tag

Triggered by pushing a tag matching `v[0-9]+.[0-9]+.[0-9]+`. Permissions:
`contents: write`.

1. Derive the version from the tag (`v1.2.0` → `1.2.0`).
2. Extract that version's section from `CHANGELOG.md` with `awk` — capture starts
   at `## [1.2.0]` and stops at the next `## [` heading **or** the link-reference
   block (`[x]: …`), then trims blank lines. (The stop-at-link-ref rule is what
   makes the **first** release — which has no older section beneath it — produce
   clean notes.)
3. Fail if that section is empty (tag a version you haven't written notes for → CI
   error, by design).
4. Publish a GitHub Release with those notes via `softprops/action-gh-release`.

## Releases

The end-to-end procedure (run by the `changelog-keeper` agent or `/release`):

```bash
# 1. Decide the bump from the Unreleased entries (breaking→major, feat→minor, fix→patch).
# 2. Move Unreleased → "## [X.Y.Z] - YYYY-MM-DD"; reset Unreleased; update link refs.
# 3. Commit the release:
git commit -m "chore(release): vX.Y.Z"
# 4. Tag and push — this fires release.yml:
git tag -a vX.Y.Z -m "vX.Y.Z"
git push origin vX.Y.Z
```

The GitHub Release body is the changelog section for that version — so the
changelog *is* your release notes.

## Adapting CI to your stack

The workflows are stable; the **scripts** are where your stack plugs in. Make
`scripts/{bootstrap,test,lint}.sh` real for your language (see
[scripts reference](./scripts-reference.md)) and CI follows automatically. A
dynamic CI badge for your repo:

```markdown
![CI](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)
```

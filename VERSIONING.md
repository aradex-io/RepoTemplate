# Versioning, Commits & Releases

This repo uses **[Semantic Versioning]**, **[Conventional Commits]**, and
**[Keep a Changelog]** together. They are the strict version-control contract
referenced by `CLAUDE.md` §2–§3.

## Semantic Versioning

`MAJOR.MINOR.PATCH`:

- **MAJOR** — incompatible / breaking changes.
- **MINOR** — new functionality, backward compatible.
- **PATCH** — backward-compatible bug fixes.

## Conventional Commits

```
type(scope): subject

body (optional, wrapped at ~72 cols, explains the "why")

footer (optional: BREAKING CHANGE:, changelog: none, Refs: #123)
```

| Type       | Use for                                   | SemVer |
|------------|-------------------------------------------|--------|
| `feat`     | New feature                               | MINOR  |
| `fix`      | Bug fix                                    | PATCH  |
| `perf`     | Performance improvement                    | PATCH  |
| `refactor` | Code change, no behavior change            | —      |
| `docs`     | Documentation only                         | —      |
| `test`     | Tests only                                 | —      |
| `build`    | Build system / dependencies                | —      |
| `ci`       | CI configuration                           | —      |
| `chore`    | Maintenance, tooling                       | —      |
| `style`    | Formatting, no code change                 | —      |
| `revert`   | Reverts a previous commit                  | varies |

Rules:
- Imperative mood ("add", not "added"), subject ≤ 72 chars, no trailing period.
- Breaking change: append `!` after the type/scope **and** add a
  `BREAKING CHANGE:` footer → triggers a MAJOR bump.
- One logical change per commit (atomic).
- `changelog: none` footer marks an internal-only commit that needs no changelog
  entry — use honestly.

CI validates commit subjects on every PR (`.github/workflows/ci.yml`).

## Changelog

Maintain `CHANGELOG.md` in Keep a Changelog format. Add entries under
`## [Unreleased]` **in the same commit as the change**, grouped under: `Added`,
`Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`. CI
(`.github/workflows/changelog.yml`) fails PRs that change source without a
changelog update (unless labeled `changelog: none`).

## Release process

1. `/release` (or the `changelog-keeper` agent): decide the SemVer bump from the
   Unreleased entries.
2. Move Unreleased items into `## [x.y.z] - YYYY-MM-DD`; reset Unreleased; update
   link refs at the bottom of `CHANGELOG.md`.
3. Commit `chore(release): vX.Y.Z`.
4. Tag and push: `git tag vX.Y.Z && git push origin vX.Y.Z`.
5. `.github/workflows/release.yml` publishes a GitHub Release using that
   version's changelog section as the notes.

[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
[Conventional Commits]: https://www.conventionalcommits.org/en/v1.0.0/
[Keep a Changelog]: https://keepachangelog.com/en/1.1.0/

---
description: Cut a SemVer release from the Unreleased changelog section
argument-hint: <major|minor|patch> (optional; otherwise infer from entries)
---

Prepare a release.

1. Read `## [Unreleased]` in `CHANGELOG.md`. Infer the SemVer bump
   ($ARGUMENTS if given, else: breaking→major, feat→minor, fix→patch).
2. Move Unreleased entries into `## [x.y.z] - <today>`; reset Unreleased to empty
   groups; update link references at the bottom.
3. Commit `chore(release): vX.Y.Z` on the current branch.
4. Tell me the exact `git tag vX.Y.Z && git push origin vX.Y.Z` to run (the
   Release workflow publishes notes from the changelog). Don't tag without my OK.

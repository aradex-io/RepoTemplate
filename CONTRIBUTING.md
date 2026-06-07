# Contributing

Thanks for contributing. This repo holds humans and AI agents to the same bar.
The full operating contract is in [`CLAUDE.md`](./CLAUDE.md); this is the short
version for people.

## Workflow

1. **Branch.** Never commit to `main`/`master`. Use `feat/…`, `fix/…`,
   `docs/…`, `chore/…`.
2. **Plan non-trivial work.** Write a plan in `docs/plans/` and run
   `scripts/codex-review.sh <plan>` to attach a Codex review appendix before you
   build (see `CLAUDE.md` §4).
3. **Build surgically.** Smallest change that works; match existing style; no
   drive-by refactors.
4. **Test.** `scripts/lint.sh` and `scripts/test.sh` must pass.
5. **Changelog.** Add an entry under `## [Unreleased]` in `CHANGELOG.md` in the
   same commit (or use a `changelog: none` footer for internal-only changes).
6. **Commit.** [Conventional Commits](./VERSIONING.md), atomic.
7. **Push** to your branch. Open a PR only if a maintainer asks.

## Setup

```bash
./scripts/bootstrap.sh   # install deps
./scripts/test.sh        # run tests
./scripts/lint.sh        # lint + format check
```

## Project layout

See `CLAUDE.md` §5. In short: `src/` code, `tests/` tests, `docs/` docs & plans,
`scripts/` automation, `offline/` is git-ignored local scratch.

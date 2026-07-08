# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- `commit-lint` CI job no longer fails on the synthetic merge commit GitHub
  creates for `pull_request` events — it now lints with `git rev-list --no-merges`,
  so real commits are validated but the auto-generated `Merge …` commit is skipped.

### Added
- `docs/` wiki: a low-level reference under `docs/guide/` (plan review, version
  control & changelog, CI/CD & releases, branch protection, scripts, agents),
  indexed by `docs/README.md`.

- `scripts/publish-wiki.sh` (+ `scripts/lib/wiki_render.py`): publish the `docs/`
  wiki to the GitHub repository Wiki, regenerated from `docs/` with link rewriting
  and a generated sidebar — `docs/` stays the single source of truth.

### Changed
- Streamlined the README — removed repetition and moved deep detail into the wiki.
- Mandate model roles by phase: planning/plan-review on **Opus**, execution on
  **Sonnet** (`CLAUDE.md` §1.6 + Definition of done, `AGENTS.md`, and the agents
  guide). The `implementer` agent now runs on Sonnet instead of Opus.
- Broaden the model mandate into **complexity-based triage**: Fable 5 for the
  hardest problems, Opus for reasoning/planning, Sonnet for execution, and Haiku
  only for trivial work (sparingly) — `CLAUDE.md` §1.6 + Definition of done,
  `AGENTS.md`, and the agents guide.
- Mandate that **all authorship is attributed to the maintainer**
  (`d0sf3t <github@aradex.io>`) with **no Claude/Anthropic** co-author or
  "Generated with" attribution — `CLAUDE.md` §2 + Definition of done, `AGENTS.md`,
  and the version-control guide.

## [0.1.0] - 2026-06-07

### Added
- Operating contract for humans and AI agents (`CLAUDE.md` + tool-neutral
  `AGENTS.md`): think-before-coding, simplicity-first, surgical changes, strict
  branch-only version control, and a mandatory changelog.
- Plan → review → implement workflow. Non-trivial work is planned in
  `docs/plans/` and reviewed by `scripts/codex-review.sh`, which appends a
  `## Appendix: Plan Review` to the plan. Backends: **`codex exec`** (preferred,
  read-only, non-interactive — never the Codex bridge/MCP), a fallback reviewer
  CLI via `REVIEW_FALLBACK_CMD` (e.g. `advisor`), or the `plan-reviewer` agent.
- `.claude/` harness: shared `settings.json` with a SessionStart hook; agents
  (`planner`, `codex-reviewer`, `plan-reviewer`, `implementer`,
  `changelog-keeper`); slash commands (`/plan`, `/codex-review`, `/release`).
- CI/CD: `ci` (lint, test, Conventional-Commit linting), `changelog` gate, and
  tag-driven `release` workflows; PR/issue templates; inert `CODEOWNERS`.
- `main` is the default branch, with an importable branch-protection ruleset
  (`.github/rulesets/main-branch-protection.json`) and
  `scripts/setup-branch-protection.sh` to set the default branch and apply it.
- Base layout — `src/ tests/ docs/ scripts/ offline/` (git-ignored scratch) —
  plus `VERSIONING.md`, `CONTRIBUTING.md`, MIT `LICENSE`, `.gitignore`,
  `.editorconfig`, and a visually styled `README.md`.

[Unreleased]: https://github.com/OWNER/REPO/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/OWNER/REPO/releases/tag/v0.1.0

# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- `commit-lint` CI job no longer fails on the synthetic merge commit GitHub
  creates for `pull_request` events — it now lints with `git rev-list --no-merges`,
  so real commits are validated but the auto-generated `Merge …` commit is skipped.
- The `implementer` agent and `/codex-review` command referenced a
  `## Appendix: Codex Review` section, but `scripts/codex-review.sh` writes
  `## Appendix: Plan Review`; aligned all references to `## Appendix: Plan Review`
  so the implementer precondition actually matches.

### Added
- Permissive-by-default `.claude/settings.json`: broad tool allow-list
  (`Bash`, `Edit`, `Write`, `Read`, `WebFetch`, …) with `defaultMode:
  acceptEdits`, guarded by a `deny` list that still blocks destructive file wipes
  (`rm -rf` and variants, `shred`, `truncate`), disk/format/mount ops (`dd`,
  `mkfs*`, `fdisk`, `parted`, `wipefs`, `mount`/`umount`), and system/power/privilege
  ops (`shutdown`/`reboot`/`poweroff`/`halt`, `chmod -R`/`chown -R`, `kill -9 -1`),
  plus the existing secret-read denies.
- `docs/` wiki: a low-level reference under `docs/guide/` (plan review, version
  control & changelog, CI/CD & releases, branch protection, scripts, agents),
  indexed by `docs/README.md`.

- `scripts/publish-wiki.sh` (+ `scripts/lib/wiki_render.py`): publish the `docs/`
  wiki to the GitHub repository Wiki, regenerated from `docs/` with link rewriting
  and a generated sidebar — `docs/` stays the single source of truth.

### Changed
- Streamlined the README — removed repetition and moved deep detail into the wiki.
- Mandate **tier-based model triage** — by tier, **not by provider**
  (`CLAUDE.md` §1.6 + Definition of done, `AGENTS.md`, and the agents guide):
  **Tier 1** (hardest, most technically intensive) → **Astra 6** or **Fable 5**;
  **Tier 2** (complex reasoning / difficult technical, the planning default) →
  **Opus 5** (`high`/`xhigh`), with **Daybreak Blue** (`xhigh`) for cyber and
  **Sol 5.6** (extra-high effort) for non-cyber; **Tier 3** (straightforward
  tasks/implementation) → **Sonnet 5** or **Terra 5.6**. Tier 3 is the floor;
  Haiku is not part of the ladder. Shipped Claude agents encode the common Claude
  path (`planner`/`plan-reviewer` → Opus 5; `implementer`/`codex-reviewer`/
  `changelog-keeper` → Sonnet).
- Generalize the **plan-review mandate to "review by a tier-peer, not a fixed
  provider"** (`CLAUDE.md` §4, `AGENTS.md`, agents guide): the reviewer is an
  independent model at the task's tier (e.g. Opus 5 ↔ Sol 5.6 / Daybreak Blue),
  and the plan + review workload splits **~60/40 in either direction** — replacing
  the old fixed "Opus plans, Codex reviews" split.
- Point the **codex usage at the `/codexrev` / `/llm-bridge` file-handoff commands**
  as the interactive review path, alongside the scriptable `scripts/codex-review.sh`
  (`CLAUDE.md` §4, `/codex-review`, `codex-reviewer` agent, agents guide).
- `scripts/codex-review.sh` now defaults to **model `gpt-5.6-sol`** (the codex
  default `gpt-5.3-codex` fails on ChatGPT-account auth) and
  **`model_reasoning_effort=xhigh`**, both overridable via `CODEX_REVIEW_MODEL` /
  `CODEX_REVIEW_EFFORT`; the `codex exec` invocation closes stdin (`< /dev/null`)
  so it cannot hang.
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

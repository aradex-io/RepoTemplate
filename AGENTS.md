# AGENTS.md

Tool-neutral operating rules for any AI coding agent in this repo. This mirrors
`CLAUDE.md`; that file is the source of truth. If you are Claude Code, read
`CLAUDE.md`. If you are another agent, these are your rules.

## Core principles

- **Think before coding.** State assumptions and trade-offs; ask when unclear.
- **Simplicity first.** Minimum code, no speculative abstractions.
- **Surgical changes.** Touch only what the task needs; match existing style; no
  drive-by refactors.
- **Honesty.** Report real test results. Never claim unverified success.
- **Triage tasks to the right model by complexity (mandatory).** **Fable 5** —
  the hardest planning and the nuanced big-picture context/analysis work only
  (understanding a whole codebase to find the real gaps or set direction).
  **Opus 5** — the default for planning (write/review plans, design, non-trivial
  analysis) and for complex execution. **Sonnet (latest)** — basic planning for
  small, well-scoped changes, and pure/straightforward execution (code an
  approved plan, changelog, mechanical edits). Sonnet is the floor; Haiku is not
  part of the ladder. Agents encode the common path — `planner`/`plan-reviewer`
  on Opus 5, `implementer`/`codex-reviewer`/`changelog-keeper` on Sonnet;
  escalate whole-codebase or direction-setting work to Fable 5 and complex
  implementation to Opus 5. Never leave hard planning on Sonnet.

## Version control

- Work on a branch; never commit to `main`/`master` directly.
- [Conventional Commits](https://www.conventionalcommits.org): `type(scope): subject`.
- Atomic, green commits. No secrets in history. `git push -u origin <branch>`.
- **Attribute all authorship to the maintainer** — `d0sf3t <github@aradex.io>`
  (`user.name`/`user.email`). Never add a `Co-Authored-By: Claude`/Anthropic
  trailer or a "Generated with Claude Code" line to any commit or PR.
- No pull requests unless a human explicitly asks.

## Changelog

- Update `CHANGELOG.md` (`Unreleased`) in the **same commit** as any user-visible
  change. Format: [Keep a Changelog](https://keepachangelog.com).

## Plan review via Codex (mandatory for non-trivial work)

1. Write the plan to `docs/plans/<date>-<slug>.md` (`docs/plans/TEMPLATE.md`).
2. Review it with: `scripts/codex-review.sh docs/plans/<date>-<slug>.md`
3. The script runs **`codex exec`** (non-interactive, read-only) and **appends the
   review to the plan as a `## Appendix: Codex Review` section.**

Constraints: use `codex exec` only. **Not** an interactive Codex session, **not**
the Codex bridge / MCP / IDE integration. Codex reviews read-only; it must not
edit files. The review lives as text in the plan file, committed with the plan.

## Layout

`src/` source · `tests/` tests · `docs/` docs & plans · `scripts/` automation ·
`offline/` git-ignored scratch · `.github/` CI/CD. See `CLAUDE.md` §5.

## Done means

Builds, lints, tests pass; changelog updated; atomic commits on a branch;
non-trivial work has a Codex-reviewed plan; docs/ADRs updated; no secrets.

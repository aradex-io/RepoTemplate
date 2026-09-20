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
- **Triage tasks to the right model tier (mandatory) — by tier, not by
  provider.** **Tier 1 (hardest, most technically intensive):** **Astra 6** or
  **Fable 5** — whole-codebase, direction-setting, deep-architecture calls; reach
  here only when Tier 2 is not enough. **Tier 2 (complex reasoning / difficult
  technical — the default for planning, design, and complex execution):**
  **Opus 5** (effort `high`/`xhigh`); the peer is **Daybreak Blue** (`xhigh`) for
  **cyber** work and **Sol 5.6** (extra-high effort) for **non-cyber** work.
  **Tier 3 (straightforward tasks/implementation):** **Sonnet 5** or **Terra
  5.6** — code an approved plan, changelog, mechanical edits. Tier 3 is the
  floor; Haiku is not part of the ladder. Agents encode the common Claude path —
  `planner`/`plan-reviewer` on Opus 5 (Tier 2), `implementer`/`codex-reviewer`/
  `changelog-keeper` on Sonnet (Tier 3); escalate whole-codebase or
  direction-setting work to Tier 1 and complex implementation to Tier 2. Never
  leave hard planning on a Tier-3 model.

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

## Plan review by a tier-peer model (mandatory for non-trivial work)

Reviewed **by tier, not by provider**: a second, independent model at the task's
tier (§ model triage) reviews the plan before implementation — a Tier-2 plan on
Opus 5 is reviewed by Sol 5.6 (non-cyber) or Daybreak Blue (cyber), and
vice-versa. Split the plan + review workload ~60/40 in either direction; neither
model is permanently planner or reviewer. (Replaces the old fixed "Opus plans,
Codex reviews" split.)

1. Write the plan to `docs/plans/<date>-<slug>.md` (`docs/plans/TEMPLATE.md`).
2. Review it with **`/codexrev docs/plans/<date>-<slug>.md`** (= `/llm-bridge codex
   …`, file-handoff to a peer model), or the scriptable equivalent
   **`scripts/codex-review.sh docs/plans/<date>-<slug>.md`**.
3. Both run **`codex exec`** (non-interactive, read-only) and produce a review that
   is appended to the plan as a `## Appendix: Plan Review` section.

Constraints: **non-interactive** and **read-only** only (`codex exec --sandbox
read-only`, or `/llm-bridge` in its default read-only mode). **Not** an interactive
session, **not** a Codex/peer MCP server / IDE integration. The reviewer reviews;
it must not edit files. The review lives as text in the plan file, committed with
the plan.

## Layout

`src/` source · `tests/` tests · `docs/` docs & plans · `scripts/` automation ·
`offline/` git-ignored scratch · `.github/` CI/CD. See `CLAUDE.md` §5.

## Done means

Builds, lints, tests pass; changelog updated; atomic commits on a branch;
non-trivial work has a tier-peer-reviewed plan; docs/ADRs updated; no secrets.

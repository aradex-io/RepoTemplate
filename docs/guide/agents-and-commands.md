# Agents & commands

The [`.claude/`](../../.claude) directory configures Claude Code for this repo:
shared settings, role agents, and slash commands. They encode the workflow so an
agent follows the same contract a human does.

## Settings — `.claude/settings.json`

- **SessionStart hook** — runs `./scripts/bootstrap.sh` on `startup|resume` so a
  fresh session/container has its environment ready (failures are swallowed so a
  stub bootstrap never blocks a session).
- **Permissions** — pre-allows the common git + script invocations (no prompt for
  routine work) and **denies reading** secrets and scratch: `./offline/**`,
  `.env`, `*.pem`, `**/secrets/**`.
- `.claude/settings.local.json` is git-ignored for personal overrides.

## Agents — `.claude/agents/`

Each agent is a focused role with a minimal toolset. They chain
**plan → review → implement**. Per CLAUDE.md §1.6, **planning runs on Opus and
execution runs on Sonnet** — each agent pins its `model` accordingly:

| Agent | Model | Tools | Does | Does not |
|-------|-------|-------|------|----------|
| [`planner`](../../.claude/agents/planner.md) | **opus** | Read, Grep, Glob, Bash, Write | Research, then write a grounded plan into `docs/plans/`. | Touch `src/` or implement. |
| [`codex-reviewer`](../../.claude/agents/codex-reviewer.md) | sonnet | Bash, Read | Run `scripts/codex-review.sh`; summarize the verdict/blockers; hand off to `plan-reviewer` on exit `3`. | Write the review itself or implement. |
| [`plan-reviewer`](../../.claude/agents/plan-reviewer.md) | **opus** | Read, Edit | **Fallback reviewer** with no CLI: review the plan and append the same appendix. | Implement; use an interactive Codex session or the bridge/MCP. |
| [`implementer`](../../.claude/agents/implementer.md) | sonnet | Read, Grep, Glob, Edit, Write, Bash | Implement an approved plan surgically, with tests + changelog. | Start before blockers are resolved; commit to `main`. |
| [`changelog-keeper`](../../.claude/agents/changelog-keeper.md) | sonnet | Read, Edit, Bash | Keep `CHANGELOG.md` honest; cut SemVer releases. | Invent entries. |

## Slash commands — `.claude/commands/`

| Command | Effect |
|---------|--------|
| [`/plan <task>`](../../.claude/commands/plan.md) | Research and draft a plan into `docs/plans/`; reminds you to review before coding. |
| [`/codex-review <plan>`](../../.claude/commands/codex-review.md) | Run `scripts/codex-review.sh` on a plan and summarize the appendix. |
| [`/release [bump]`](../../.claude/commands/release.md) | Roll `Unreleased` into a versioned section and prep the release commit/tag. |

## Typical flow

```
/plan add rate limiting
  → planner writes docs/plans/2026-06-07-rate-limiting.md
/codex-review docs/plans/2026-06-07-rate-limiting.md
  → codex-reviewer runs the script → "## Appendix: Plan Review" appended
  → (no Codex installed? → plan-reviewer appends it instead)
resolve blockers, then implement on a feat/ branch
  → implementer: code + tests + CHANGELOG, Conventional commits
/release minor
  → changelog-keeper cuts vX.Y.0
```

## Keeping it consistent

`CLAUDE.md` is the source of truth; `AGENTS.md` mirrors it for non-Claude tools.
When you change the workflow, update both and the relevant agent/command file so
the encoded behavior matches the written contract.

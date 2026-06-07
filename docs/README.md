# Documentation

The wiki for this repository. The top-level `README.md` is the overview; this is
the **low-level reference** for how every mechanism works and how to operate it.

## Map

| Area | Page | Covers |
|------|------|--------|
| **Plan review** | [`guide/plan-review.md`](./guide/plan-review.md) | The review gate end to end: `codex exec` invocation, backend resolution, env vars, exit codes, the appendix format, and the reviewing agents. |
| **Version control & changelog** | [`guide/version-control-and-changelog.md`](./guide/version-control-and-changelog.md) | Branch model, Conventional Commits, atomic commits, the changelog contract and `check-changelog.sh` internals. |
| **CI/CD & releases** | [`guide/ci-cd-and-releases.md`](./guide/ci-cd-and-releases.md) | Every workflow job by job, triggers, required checks, and the tag-driven release + notes extraction. |
| **Branch protection** | [`guide/branch-protection.md`](./guide/branch-protection.md) | The ruleset rule by rule, how to apply it (`gh` or UI), and how to tune it. |
| **Scripts** | [`guide/scripts-reference.md`](./guide/scripts-reference.md) | Each script's contract: arguments, env vars, exit codes, behavior. |
| **Agents & commands** | [`guide/agents-and-commands.md`](./guide/agents-and-commands.md) | The `.claude/` agents and slash commands, their tools, and how they chain. |

## Other docs

- [`architecture/overview.md`](./architecture/overview.md) — **your** system map.
  A stub to fill in for the project you build on this template.
- [`adr/`](./adr) — Architecture Decision Records, one decision per file. Start
  from [`adr/0001-record-architecture-decisions.md`](./adr/0001-record-architecture-decisions.md).
- [`plans/`](./plans) — implementation plans and their review appendices. Use
  [`plans/TEMPLATE.md`](./plans/TEMPLATE.md).

## Conventions for these docs

- One concern per page; link rather than duplicate.
- Show the real command, real flag, real exit code — this is the low-level layer,
  so prefer precision over prose.
- `guide/` documents the **template tooling** (safe to keep as-is). `architecture/`
  and `adr/` are about **your** project (you own them).

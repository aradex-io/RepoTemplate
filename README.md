# RepoTemplate

A robust, agent-ready repository template. Clone it to start any project with a
strict, batteries-included workflow already wired up: AI operating rules, a
Codex plan-review gate, CI/CD, and disciplined version control + changelog.

## What's inside

```
.
├── CLAUDE.md              # Operating contract for AI agents (source of truth)
├── AGENTS.md              # Tool-neutral mirror of CLAUDE.md
├── VERSIONING.md          # Conventional Commits + SemVer + release process
├── CHANGELOG.md           # Keep a Changelog
├── CONTRIBUTING.md        # Human contributor guide
├── .claude/
│   ├── settings.json      # Shared permissions/config
│   ├── agents/            # planner, codex-reviewer, implementer, changelog-keeper
│   └── commands/          # /plan, /codex-review, /release
├── .github/
│   ├── workflows/         # ci, changelog, release
│   ├── ISSUE_TEMPLATE/    # bug / feature
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── CODEOWNERS
├── docs/
│   ├── architecture/      # system map
│   ├── adr/               # Architecture Decision Records
│   └── plans/             # implementation plans + Codex review appendices
├── scripts/               # bootstrap, test, lint, codex-review, check-changelog
├── src/                   # your code
├── tests/                 # your tests
└── offline/               # git-ignored local scratch (experiments, data)
```

## The workflow in 30 seconds

1. **Plan** non-trivial work → `docs/plans/<date>-<slug>.md` (`/plan`).
2. **Review** the plan with Codex → `scripts/codex-review.sh <plan>` runs
   `codex exec` (read-only) and appends a `## Appendix: Codex Review` to the
   plan. Resolve blockers.
3. **Implement** surgically on a branch; write tests; update `CHANGELOG.md`.
4. **Commit** with Conventional Commits; CI enforces commit style + changelog.
5. **Release** by tagging `vX.Y.Z`; notes come from the changelog.

The Codex review is **always** produced via `codex exec` and stored as text in
the plan file — never as an interactive session and never via the Codex bridge.
See `CLAUDE.md` §4.

## Getting started

Two ways to adopt this, both work for anyone:

- **GitHub → "Use this template" → Create a new repository** (recommended — starts
  you with a clean history), or
- **Clone / fork**, then point the remote at your own repo.

```bash
# 1. Get the code (template button, or):
git clone <your-repo-url> && cd <your-repo>

# 2. Make scripts executable (only needed after a raw download/zip):
chmod +x scripts/*.sh

# 3. Wire up your stack:
./scripts/bootstrap.sh    # edit the stub for your language first
```

### Customize before you ship

The template is intentionally generic. Update these repo-specific bits once:

- [ ] `LICENSE` — set the copyright holder (defaults to MIT / "aradex").
- [ ] `.github/CODEOWNERS` — uncomment and set real owners (ships inert so it
      never errors for a fresh clone).
- [ ] `CHANGELOG.md` — replace the `OWNER/REPO` link reference with your repo.
- [ ] `scripts/bootstrap.sh`, `scripts/test.sh`, `scripts/lint.sh` — see note below.
- [ ] `docs/architecture/overview.md` — describe your actual system.

> **Heads-up on the script stubs.** `bootstrap.sh`, `test.sh`, and `lint.sh` ship
> as no-op stubs that **exit 0** so CI is green out of the box. Until you wire
> them to real commands for your stack, lint/test **pass without checking
> anything** — replace the bodies before relying on CI as a quality gate.

Read `CLAUDE.md` first — it's the contract every contributor (human or AI)
follows.

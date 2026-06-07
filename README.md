<div align="center">

# ⛬ RepoTemplate

### A strict, agent-ready project skeleton — disciplined version control, a mandatory plan-review gate, and CI/CD wired up from commit zero.

<br/>

![License: MIT](https://img.shields.io/badge/License-MIT-22c55e.svg?style=flat-square)
![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-FE5196?style=flat-square&logo=conventionalcommits&logoColor=white)
![Keep a Changelog](https://img.shields.io/badge/Keep%20a%20Changelog-1.1.0-f59e0b?style=flat-square)
![SemVer](https://img.shields.io/badge/SemVer-2.0.0-3b82f6?style=flat-square)
![Plans: reviewed](https://img.shields.io/badge/plans-Codex%20reviewed-000000?style=flat-square&logo=openai)
![Agent ready](https://img.shields.io/badge/Claude%20Code-ready-D97757?style=flat-square)

</div>

---

**RepoTemplate** is a batteries-included starting point for any project. Clone it
and you inherit a hard contract that humans *and* AI agents follow: branch-only
work, Conventional Commits, a maintained changelog, protected `main`, and a
**plan → review → implement** loop where every non-trivial plan is reviewed by
**Codex** (or a fallback reviewer) and the review is committed alongside the plan.

It is language-agnostic — the structure and rules are the product; you drop your
code into `src/`.

## ⚙️ Core requirements

Most of the template works with nothing installed. The one external dependency is
the **plan-review step**, which prefers the OpenAI **Codex CLI**.

| Need | Why | How |
|------|-----|-----|
| **Codex CLI** | Runs `codex exec` to review plans | `npm install -g @openai/codex` |
| **Codex auth token** | Codex needs to authenticate | `codex login` **or** export `OPENAI_API_KEY` |
| `CODEX_REVIEW_MODEL` *(optional)* | Pick the review model | `export CODEX_REVIEW_MODEL=gpt-5.3-codex` (default) |
| **Fallback reviewer** *(if no Codex)* | Review without Codex | see **[Plan review & fallbacks](#-plan-review--fallbacks)** |
| `git` + Bash | Everything else | already on your machine |

```bash
# Typical one-time setup for the review gate:
npm install -g @openai/codex
export OPENAI_API_KEY=sk-...          # or run: codex login
```

> 🔒 **Never commit the token.** `.env` and `*.key`/`*.pem` are git-ignored, and
> `.claude/settings.json` denies reading them. Put secrets in your shell env or a
> secrets manager — never in the repo.

## 🚀 Quick start

```bash
# 1. "Use this template" on GitHub (recommended), or clone:
git clone <your-repo-url> && cd <your-repo>

# 2. Make scripts executable (only after a raw zip download):
chmod +x scripts/*.sh

# 3. Wire your stack into the stubs, then:
./scripts/bootstrap.sh     # install deps
./scripts/lint.sh          # lint + format
./scripts/test.sh          # tests
```

Read **`CLAUDE.md`** first — it's the contract every contributor (human or AI)
follows.

## 🔁 General usage — the workflow

```mermaid
flowchart LR
    I([idea]) --> P["/plan → docs/plans/"]
    P --> R{"review backend"}
    R -->|codex exec| A["Appendix: Plan Review"]
    R -->|fallback CLI| A
    R -->|plan-reviewer agent| A
    A --> X["resolve blockers"]
    X --> B["implement on a branch"]
    B --> T["tests + CHANGELOG"]
    T --> C["Conventional commit"]
    C --> M["PR → CI gates → main"]
```

1. **Plan** non-trivial work → a file in `docs/plans/` (slash command `/plan`).
2. **Review** it → `scripts/codex-review.sh <plan>` appends a
   `## Appendix: Plan Review` to the plan. Resolve blockers.
3. **Implement** surgically on a branch; write tests; update `CHANGELOG.md`.
4. **Commit** with Conventional Commits — CI lints commits + the changelog.
5. **Merge** to protected `main` via PR (CI must be green).
6. **Release** by tagging `vX.Y.Z`; notes come from the changelog.

| Command | Does |
|---------|------|
| `/plan <task>` · `scripts` | Draft a plan into `docs/plans/` |
| `scripts/codex-review.sh <plan>` | Review a plan → appendix (Codex or fallback) |
| `scripts/test.sh` · `scripts/lint.sh` | Test / lint (wire to your stack) |
| `scripts/check-changelog.sh` | Fail if source changed w/o a changelog entry |
| `scripts/setup-branch-protection.sh` | Set `main` default + apply the ruleset |

## 🧪 Plan review & fallbacks

The review is **always** produced non-interactively and **always** stored as text
in the plan file — never an interactive Codex session, never the Codex bridge/MCP.
`scripts/codex-review.sh` picks a backend automatically:

| Order | Backend | When | How it's selected |
|:-----:|---------|------|-------------------|
| 1 | **`codex exec`** | Codex CLI installed | default |
| 2 | **fallback CLI** (`advisor`) | no Codex, but a reviewer CLI exists | `REVIEW_FALLBACK_CMD=<cli>` (reads prompt on stdin, writes review to stdout) |
| 3 | **`plan-reviewer` agent** | no review CLI at all | run the agent in Claude Code; it appends the same appendix |

```bash
# Force a backend if you want:
REVIEW_BACKEND=codex   scripts/codex-review.sh docs/plans/<plan>.md
REVIEW_FALLBACK_CMD=advisor REVIEW_BACKEND=advisor scripts/codex-review.sh docs/plans/<plan>.md
```

If none of the above is available, the script **stops** and tells you how to
proceed — it never fabricates a review.

## 🗂️ Layout

```
.
├── CLAUDE.md / AGENTS.md   # operating contract (source of truth + tool-neutral mirror)
├── VERSIONING.md           # Conventional Commits + SemVer + releases
├── CHANGELOG.md            # Keep a Changelog
├── .claude/
│   ├── settings.json       # shared permissions + SessionStart hook
│   ├── agents/             # planner · codex-reviewer · plan-reviewer · implementer · changelog-keeper
│   └── commands/           # /plan · /codex-review · /release
├── .github/
│   ├── workflows/          # ci · changelog · release
│   ├── rulesets/           # importable main branch protection
│   └── ISSUE_TEMPLATE · PULL_REQUEST_TEMPLATE · CODEOWNERS
├── docs/
│   ├── architecture/ · adr/    # system map · decision records
│   └── plans/                  # plans + their review appendices
├── scripts/                # bootstrap · test · lint · codex-review · check-changelog · setup-branch-protection
├── src/  tests/            # your code · your tests
└── offline/                # git-ignored local scratch (only its README is tracked)
```

<details>
<summary><b>🛡️ Default branch & branch protection</b></summary>

<br/>

The default branch is **`main`**, so any repo created via *"Use this template"*
starts on `main`. GitHub does **not** copy branch rules to new repos, so apply
them once — they enforce what `CLAUDE.md` §2 mandates (no direct pushes, green CI
required, no force-push, no deletion, linear history):

```bash
scripts/setup-branch-protection.sh            # uses gh; or: ... owner/repo
# UI alternative: Settings → Rules → Rulesets → Import →
#   .github/rulesets/main-branch-protection.json
```

The ruleset requires a PR with **0** approvals by default (solo-friendly); bump
`required_approving_review_count` for teams.

</details>

<details>
<summary><b>✅ Customize before you ship</b></summary>

<br/>

- [ ] `LICENSE` — copyright holder (defaults to MIT / "aradex").
- [ ] `.github/CODEOWNERS` — uncomment + set real owners (ships inert).
- [ ] `CHANGELOG.md` — replace the `OWNER/REPO` link reference.
- [ ] `scripts/{bootstrap,test,lint}.sh` — see the stub note below.
- [ ] `docs/architecture/overview.md` — describe your real system.
- [ ] Apply branch protection (above).

> ⚠️ **Script stubs.** `bootstrap.sh`, `test.sh`, and `lint.sh` ship as no-op
> stubs that **exit 0**, so CI is green out of the box. Until you wire them to
> real commands, lint/test **pass without checking anything** — replace the
> bodies before trusting CI as a quality gate.

</details>

## 📄 License

[MIT](./LICENSE) © aradex — free to use, modify, and distribute.

# CLAUDE.md

Operating contract for AI coding agents (Claude Code, and compatible) working in
this repository. Read this fully before doing anything. These rules are
**mandatory**, not advisory. When a rule here conflicts with a request, surface
the conflict and stop — do not silently override it.

> Language-agnostic peers live in `AGENTS.md` (same rules, tool-neutral). Keep
> the two in sync; this file is the source of truth.

---

## 1. Prime directives

1. **Think before coding.** State assumptions, surface trade-offs, name the
   files you intend to touch. If the request is ambiguous, ask — do not guess.
2. **Simplicity first.** No speculative features, no single-use abstractions, no
   frameworks you don't need yet. Write the minimum code that satisfies the
   requirement and the tests.
3. **Surgical changes.** Touch only what the task requires. Match the surrounding
   style. No drive-by refactors, no reformatting unrelated lines, no dependency
   bumps that aren't part of the task.
4. **Leave it more coherent than you found it.** Every change should keep the
   tree buildable, tested, documented, and version-controlled.
5. **Be honest about state.** If tests fail, say so with output. If you skipped a
   step, say that. Never report "done" for work you did not verify.

## 2. Version control (strict)

These are hard requirements. CI enforces several of them; the rest are on you.

- **`main` is the default branch and is protected.** All work happens on a
  branch: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`, `docs/<slug>`, or the
  session-assigned `claude/<task>` branch. Create the branch before the first
  edit. Never commit to `main`/`master` directly — the ruleset in
  `.github/rulesets/main-branch-protection.json` blocks direct pushes and
  force-pushes, requires green CI, and forbids deleting `main` (apply it once via
  `scripts/setup-branch-protection.sh`).
- **Conventional Commits, always.** Format: `type(scope): subject` in the
  imperative mood, ≤ 72 chars. Allowed types: `feat`, `fix`, `docs`, `style`,
  `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`. Breaking changes
  use `type(scope)!:` and a `BREAKING CHANGE:` footer. See `VERSIONING.md`.
- **Atomic commits.** One logical change per commit. Don't mix a refactor with a
  feature. Don't bundle unrelated fixes.
- **Commit early, commit often, but only green.** Don't commit code that fails
  the build, lint, or tests unless explicitly told to checkpoint WIP (and then
  mark it `wip:` and never push it to a shared branch).
- **Pushing:** always `git push -u origin <branch>`. Never force-push a shared
  branch. Never push to a branch other than the one assigned to the task without
  explicit permission.
- **No secrets, ever.** No credentials, tokens, `.env`, or private keys in the
  history. If you find one, stop and report it.
- **Pull requests are opt-in.** Do not open a PR unless the human explicitly asks.

## 3. Changelog (mandatory)

This repo follows [Keep a Changelog](https://keepachangelog.com) +
[SemVer](https://semver.org). See `CHANGELOG.md` and `VERSIONING.md`.

- **Every user-visible change updates `CHANGELOG.md`** under the `## [Unreleased]`
  section, in the correct group: `Added`, `Changed`, `Deprecated`, `Removed`,
  `Fixed`, `Security`.
- **Write the entry in the same commit as the change**, not afterward. CI
  (`changelog-check`) fails a PR that changes `src/` without touching the
  changelog. Pure-internal changes (tests, CI, docs) may use the
  `changelog: none` label / commit footer to opt out — use it honestly.
- Entries are written for humans: what changed and why it matters, not the diff.
- Releases move `Unreleased` items into a dated, versioned section and bump the
  version per SemVer (feat → minor, fix → patch, breaking → major).

## 4. Plans must be reviewed by Codex (mandatory)

Any non-trivial change (new feature, schema/API change, migration, anything
touching > ~50 lines or multiple modules) **requires a written plan that has been
reviewed by Codex before implementation begins.**

Workflow:

1. Write the plan to `docs/plans/<YYYY-MM-DD>-<slug>.md` using
   `docs/plans/TEMPLATE.md`. Cover: goal, approach, files touched, test strategy,
   risks, rollout.
2. Run the Codex review:
   ```bash
   scripts/codex-review.sh docs/plans/<YYYY-MM-DD>-<slug>.md
   ```
   This invokes **`codex exec`** (OpenAI Codex CLI, non-interactive, read-only
   sandbox) and **appends the review to the plan file as a `## Appendix: Codex
   Review` section.**
3. **Read the appendix. Address blocking issues** in the plan (revise and, if the
   plan changed materially, re-run the review). Only then implement.

Hard constraints on how the review is produced — do not deviate:

- ✅ Use **`codex exec`** (one-shot, non-interactive). The review is **text
  appended to the plan markdown file**, recorded in version control alongside the
  plan.
- ❌ **Do NOT** open an interactive Codex session / TUI for this.
- ❌ **Do NOT** use the "Codex bridge" / any Codex MCP server / IDE integration
  to perform the review.
- ❌ **Do NOT** let Codex modify files — it runs `--sandbox read-only`. It
  reviews; it does not implement.

The plan + its Codex appendix are committed together (`docs(plan): ...`) so the
review is auditable in history.

## 5. Repository layout

| Path             | Purpose                                                         |
|------------------|----------------------------------------------------------------|
| `src/`           | Application/library source. The product.                       |
| `tests/`         | Automated tests. Mirror `src/` structure.                      |
| `docs/`          | Human docs: architecture, ADRs, plans.                         |
| `docs/plans/`    | Implementation plans + their Codex review appendices.          |
| `docs/adr/`      | Architecture Decision Records (one decision per file).         |
| `scripts/`       | Dev/CI automation. Executable, POSIX-friendly.                 |
| `offline/`       | **Git-ignored.** Local scratch, experiments, large/private data. Never relied on by code or CI. |
| `.claude/`       | Agents, slash commands, and shared settings for this repo.     |
| `.github/`       | CI/CD workflows, issue/PR templates, CODEOWNERS.               |

## 6. Definition of done

A task is done only when **all** hold:

- [ ] Code builds and lint passes.
- [ ] Tests written/updated and **passing** (`scripts/test.sh`).
- [ ] `CHANGELOG.md` updated (or honest `changelog: none`).
- [ ] Conventional, atomic commits on the correct branch.
- [ ] For non-trivial work: plan exists in `docs/plans/` **with** a Codex review
      appendix, and blocking issues are resolved.
- [ ] Docs/ADR updated if behavior or architecture changed.
- [ ] No secrets, no stray files, `offline/` not referenced.

## 7. Commands

Wrapper scripts keep CI and humans in sync. Implement them per project; agents
call these, not raw tool invocations.

| Command                         | Does                                  |
|---------------------------------|---------------------------------------|
| `scripts/bootstrap.sh`          | Install deps / set up the environment |
| `scripts/test.sh`               | Run the full test suite               |
| `scripts/lint.sh`               | Lint + format check                   |
| `scripts/codex-review.sh PLAN`  | Codex review of a plan → appendix     |
| `scripts/check-changelog.sh`    | Verify changelog was updated          |

## 8. References (read on demand)

- `AGENTS.md` — tool-neutral version of these rules.
- `VERSIONING.md` — Conventional Commits + SemVer + release process in detail.
- `CONTRIBUTING.md` — human contributor guide.
- `docs/architecture/overview.md` — system map.
- `docs/adr/` — why decisions were made.

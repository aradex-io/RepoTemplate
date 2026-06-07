# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial repository template: CLAUDE.md / AGENTS.md operating contract, Codex
  plan-review workflow (`scripts/codex-review.sh`), `.claude/` agents and slash
  commands, CI/CD workflows, changelog + versioning policy, and the base
  `src/ tests/ docs/ scripts/ offline/` folder structure.
- Default branch is `main`; importable branch-protection ruleset
  (`.github/rulesets/main-branch-protection.json`) plus
  `scripts/setup-branch-protection.sh` to set the default branch and apply it.
- Plan-review fallbacks when Codex is absent: a fallback reviewer CLI via
  `REVIEW_FALLBACK_CMD` (e.g. `advisor`) and a `plan-reviewer` agent — both
  append the same `## Appendix: Plan Review` section.
- Visually styled README: short description, core requirements (Codex CLI +
  token), usage workflow with diagram, and the review-fallback reference.

### Changed
- Plan-review appendix renamed `## Appendix: Codex Review` → `## Appendix: Plan
  Review` so it's accurate across review backends (Codex remains the default).

<!-- Update OWNER/REPO to your repository, or switch to a compare link after the
     first tagged release, e.g. .../compare/v0.1.0...HEAD -->
[Unreleased]: https://github.com/OWNER/REPO/commits/main

# Plan: <title>

- **Date:** <YYYY-MM-DD>
- **Author:** <name / agent>
- **Status:** Draft <!-- Draft | Reviewed | Approved | Implemented -->
- **Branch:** <feat/...>

## 1. Goal
What outcome are we after, and why now? One paragraph. Include the success
criteria — how we'll know it's done.

## 2. Context
What exists today that's relevant (files, modules, constraints). Link code with
`path:line`. State assumptions explicitly.

## 3. Approach
The chosen design, step by step. Keep it simple and surgical.

### Alternatives considered
At least one rejected option and why.

## 4. Files touched
- `path/to/file` — what changes and why.

## 5. Test strategy
What tests prove this works (unit / integration / manual). New tests go in
`tests/`.

## 6. Risks & mitigations
Failure modes, security/privacy/data concerns, and how each is mitigated.

## 7. Rollout & rollback
How it ships and how to back it out safely.

## 8. Out of scope
Explicitly not doing.

## 9. Open questions
Anything needing a human decision before/while implementing.

<!--
After writing this plan, run:
    scripts/codex-review.sh docs/plans/<this-file>.md
It will append a "## Appendix: Plan Review" section below via `codex exec`
(read-only), or a fallback reviewer / the plan-reviewer agent if Codex is not
installed. Resolve Blocker/Major issues before implementing (CLAUDE.md §4).
-->

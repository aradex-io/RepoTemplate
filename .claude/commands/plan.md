---
description: Draft an implementation plan for a task and save it to docs/plans/
argument-hint: <short task description>
---

Create an implementation plan for: **$ARGUMENTS**

1. Research the relevant code first (don't plan blind).
2. Write the plan to `docs/plans/<today>-<slug>.md` using the structure in
   `docs/plans/TEMPLATE.md`: Goal, Context, Approach, Files touched, Test
   strategy, Risks, Rollout/rollback, Out of scope, Open questions.
3. Keep it simple and surgical; note one rejected alternative.
4. End by reminding me to run `/codex-review docs/plans/<file>.md` before coding.

Do not implement anything yet.

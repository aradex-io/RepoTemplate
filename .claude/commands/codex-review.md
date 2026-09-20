---
description: Run the mandatory tier-peer plan review and append it as an appendix
argument-hint: <path to docs/plans/*.md>
allowed-tools: Bash(scripts/codex-review.sh:*), Read
---

Run the mandatory plan review (CLAUDE.md §4) for: **$ARGUMENTS**

Execute:

```
scripts/codex-review.sh $ARGUMENTS
```

This runs `codex exec` (non-interactive, `--sandbox read-only`, model
`gpt-5.6-sol`, `model_reasoning_effort=xhigh`) and appends a
`## Appendix: Plan Review` section to the plan file. Then read the appendix and
summarize the verdict plus any Blocker/Major issues I must resolve before
implementing.

For an ad-hoc interactive peer review instead, use **`/codexrev $ARGUMENTS`**
(alias for `/llm-bridge codex …`), or `/llm-bridge <provider> …` for another peer
(e.g. `gemini`). Reviews are **by tier, not by provider** — the reviewer is an
independent tier-peer of whoever wrote the plan.

Do NOT use an interactive Codex session or a Codex/peer MCP server. Do NOT let the
reviewer edit files.

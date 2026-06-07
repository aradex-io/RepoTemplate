---
description: Run the mandatory Codex review of a plan and append it as an appendix
argument-hint: <path to docs/plans/*.md>
allowed-tools: Bash(scripts/codex-review.sh:*), Read
---

Run the Codex plan review (CLAUDE.md §4) for: **$ARGUMENTS**

Execute:

```
scripts/codex-review.sh $ARGUMENTS
```

This runs `codex exec` (non-interactive, read-only) and appends a
`## Appendix: Codex Review` section to the plan file. Then read the appendix and
summarize the verdict plus any Blocker/Major issues I must resolve before
implementing.

Do NOT use an interactive Codex session or the Codex bridge/MCP. Do NOT let Codex
edit files.

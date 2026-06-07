# offline/ — local scratch (git-ignored)

This directory is **not tracked by git** (see `.gitignore`). Only this README is.

Use it for local-only material that should never reach the repository:

- experiments and throwaway prototypes
- scratch notes and one-off scripts
- large datasets, fixtures, or model weights
- private / sensitive files you need locally

**Rules (CLAUDE.md §5):**
- Nothing in `src/`, `tests/`, `scripts/`, or CI may depend on files here.
- Never move secrets *out* of here into tracked paths.
- Anything that becomes permanent and shareable belongs in a tracked directory
  with a proper commit and changelog entry.

# ADR 0001: Record architecture decisions

- **Status:** Accepted
- **Date:** 2026-06-07

## Context
We need a durable, low-friction record of significant technical decisions so
future contributors (human and AI) understand *why* the system is the way it is,
not just *what* it is.

## Decision
We use **Architecture Decision Records (ADRs)** — one Markdown file per decision
in `docs/adr/`, numbered sequentially (`NNNN-title.md`). Each ADR captures
Context, Decision, and Consequences. ADRs are immutable once Accepted; to change
a decision, add a new ADR that supersedes the old one.

## Consequences
- Decisions are auditable in version control alongside the code.
- Plans (`docs/plans/`) that make a lasting architectural choice should produce a
  corresponding ADR.
- Use this file as the template for new ADRs.

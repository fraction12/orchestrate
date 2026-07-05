---
name: orchestrator-status
description: Report current or latest Orchestrate state for a repository. Use when the user invokes /orchestrator:status, /ochestrator:status, asks for orchestration status, wants active workers, PRs, UAT, heartbeats, blockers, ledger state, stale worktrees, or next orchestration actions summarized.
---

# Orchestrator Status

This is a visible entrypoint for the canonical `$orchestrate` status route.

## Route

1. Locate the canonical `orchestrate` skill:
   - Prefer sibling user-scope path `../orchestrate/SKILL.md` relative to this skill directory.
   - Otherwise use `${CODEX_HOME:-$HOME/.codex}/skills/orchestrate/SKILL.md`.
   - If working inside the source repo, use `../../SKILL.md` when it has `name: orchestrate`.
2. Read the canonical `orchestrate` `SKILL.md` fully before acting.
3. Treat the user request as `/orchestrator:status`.
4. Follow the canonical status route and read its referenced files, especially `references/status.md`, `references/private-ledger.md`, and `references/automation-lifecycle.md`.

If the canonical `orchestrate` skill is missing, stop and tell the user to install `$orchestrate` first. Do not infer orchestration status from memory alone.

## Guardrails

- Report by orchestration unit, not raw activity.
- Label facts as verified, worker-reported, inferred, stale, or missing.
- Do not present inferred or stale state as verified.
- Do not start setup, implementation, merge, or cleanup work unless the user explicitly asks after status is reported.

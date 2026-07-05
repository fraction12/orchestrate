---
name: orchestrator-recover
description: Recover interrupted, stale, or partially completed Orchestrator work. Use when the user invokes /orchestrator:recover, /ochestrator:recover, asks to recover orchestration, repair stale ledgers, reconnect workers, reconstruct PR/UAT/heartbeat state, or resume safely after an interrupted agent run.
---

# Orchestrator Recover

This is a visible entrypoint for the canonical `$orchestrate` recovery route.

## Route

1. Locate the canonical `orchestrate` skill:
   - Prefer sibling user-scope path `../orchestrate/SKILL.md`.
   - Otherwise use `${CODEX_HOME:-$HOME/.codex}/skills/orchestrate/SKILL.md`.
   - If working inside the source repo, use `../../SKILL.md` when it has `name: orchestrate`.
2. Read the canonical `orchestrate` `SKILL.md` fully before acting.
3. Treat the user request as `/orchestrator:recover`.
4. Follow the canonical recovery route and read `references/recover.md`.

## Guardrails

- Recover state before resuming work.
- Apply only safe repairs under recorded policy.
- Ask before destructive cleanup, merge, rebase, branch deletion, or restarting implementation.
- Return exact resume prompts for remaining lanes.

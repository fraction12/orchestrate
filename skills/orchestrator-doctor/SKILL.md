---
name: orchestrator-doctor
description: Check and repair Orchestrator setup health. Use when the user invokes /orchestrator:doctor, /ochestrator:doctor, asks to diagnose or fix Orchestrator setup, verify CE dependency, validate installed skills, repair thread titles, check ledger health, check automation/thread tooling, or decide whether setup/recover/orchestrate can safely continue.
---

# Orchestrator Doctor

This is a visible entrypoint for the canonical `$orchestrate` doctor route.

## Route

1. Locate the canonical `orchestrate` skill:
   - Prefer sibling user-scope path `../orchestrate/SKILL.md`.
   - Otherwise use `${CODEX_HOME:-$HOME/.codex}/skills/orchestrate/SKILL.md`.
   - If working inside the source repo, use `../../SKILL.md` when it has `name: orchestrate`.
2. Read the canonical `orchestrate` `SKILL.md` fully before acting.
3. Treat the user request as `/orchestrator:doctor`.
4. Follow the canonical doctor route and read `references/doctor.md`.

## Guardrails

- Doctor setup health, not active implementation.
- Apply only safe setup fixes without asking.
- Ask before setup initialization, CE installation, policy changes, repo doc edits, or destructive cleanup.
- Route to setup or recover when that is the correct next action.

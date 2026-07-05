---
name: orchestrator-update
description: Update the installed Orchestrator user-scope skills from the latest GitHub repo version. Use when the user invokes /orchestrator:update, /ochestrator:update, asks to update or refresh the Orchestrator skill, or wants the local Codex skill install synced from fraction12/orchestrate.
---

# Orchestrator Update

This is a visible entrypoint for the canonical `$orchestrate` update route.

## Route

1. Locate the canonical `orchestrate` skill:
   - Prefer sibling user-scope path `../orchestrate/SKILL.md` relative to this skill directory.
   - Otherwise use `${CODEX_HOME:-$HOME/.codex}/skills/orchestrate/SKILL.md`.
   - If working inside the source repo, use `../../SKILL.md` when it has `name: orchestrate`.
2. Read the canonical `orchestrate` `SKILL.md` fully before acting.
3. Treat the user request as `/orchestrator:update`.
4. Follow the canonical update route and read `references/update.md`.

If the canonical `orchestrate` skill is missing but this wrapper exists, run the bundled update script from the source repo only when it can be located. Otherwise tell the user to install `$orchestrate` first.

## Guardrails

- Do not require Compound Engineering before updating the Orchestrator skill itself.
- Do not run orchestration setup or execution during update.
- Update only user-scope Orchestrator skills.
- Validate the installed skills and tell the user to restart Codex.

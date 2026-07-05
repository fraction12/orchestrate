---
name: orchestrator-intake
description: Run the Orchestrator Intake role for task-tracker-agnostic requirements capture and ticket grooming. Use when the user invokes /orchestrator:intake, /orchestrate:intake, asks Intake to create or refine a ticket, asks where to capture requirements, wants Linear/GitHub/Notion/docs intake options, or wants to prepare work before ORCHESTRATOR decides whether to run it.
---

# Orchestrator Intake

This is a visible entrypoint for the canonical `$orchestrate` intake route.

## Route

1. Locate the canonical `orchestrate` skill:
   - Prefer sibling user-scope path `../orchestrate/SKILL.md`.
   - Otherwise use `${CODEX_HOME:-$HOME/.codex}/skills/orchestrate/SKILL.md`.
   - If working inside the source repo, use `../../SKILL.md` when it has `name: orchestrate`.
2. Read the canonical `orchestrate` `SKILL.md` fully before acting.
3. Treat the user request as `/orchestrator:intake`.
4. Follow the canonical intake route and read `references/intake.md`.

## Guardrails

- Stay task-tracker-system agnostic.
- Ask where to capture work when the destination is unclear.
- Create/refine tickets, docs, brainstorms, and plans; do not implement code.
- Do not notify ORCHESTRATOR to start work unless the user explicitly chooses that after intake output is ready.

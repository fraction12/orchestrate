---
name: orchestrator-uat
description: Run the Orchestrator UAT role for validating ready PRs and producing acceptance or blocker notes. Use when the user invokes /orchestrator:uat, /orchestrate:uat, sends a PR to UAT, asks for user acceptance testing, wants a UAT checklist, or needs acceptance/blocker notes before merge.
---

# Orchestrator UAT

This is a visible entrypoint for the canonical `$orchestrate` UAT route.

## Route

1. Locate the canonical `orchestrate` skill:
   - Prefer sibling user-scope path `../orchestrate/SKILL.md`.
   - Otherwise use `${CODEX_HOME:-$HOME/.codex}/skills/orchestrate/SKILL.md`.
   - If working inside the source repo, use `../../SKILL.md` when it has `name: orchestrate`.
2. Read the canonical `orchestrate` `SKILL.md` fully before acting.
3. Treat the user request as `/orchestrator:uat`.
4. Follow the canonical UAT route and read `references/uat.md`.

## Guardrails

- Validate from the user's acceptance perspective.
- Do not merge or edit implementation code.
- Do not claim manual/browser checks passed unless actually performed.
- Return accepted, blocked, or needs-more-information with concrete evidence.

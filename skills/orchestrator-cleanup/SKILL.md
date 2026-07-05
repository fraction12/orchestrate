---
name: orchestrator-cleanup
description: Clean completed Orchestrator residue. Use when the user invokes /orchestrator:cleanup, /orchestrate:cleanup, asks to remove completed heartbeats or automations, clean merged worktrees, delete merged worker branches, archive completed worker Codex threads, or clear leftover orchestration state after PRs are merged or work is canceled.
---

# Orchestrator Cleanup

This is a visible entrypoint for the canonical `$orchestrate` cleanup route.

## Route

1. Locate the canonical `orchestrate` skill:
   - Prefer sibling user-scope path `../orchestrate/SKILL.md`.
   - Otherwise use `${CODEX_HOME:-$HOME/.codex}/skills/orchestrate/SKILL.md`.
   - If working inside the source repo, use `../../SKILL.md` when it has `name: orchestrate`.
2. Read the canonical `orchestrate` `SKILL.md` fully before acting.
3. Treat the user request as `/orchestrator:cleanup`.
4. Follow the canonical cleanup route and read `references/cleanup.md`.

## Guardrails

- Clean only completed, merged, canceled, or explicitly deferred orchestration residue.
- Delete safe heartbeats/automations, clean worker worktrees, delete merged worker branches, and archive completed worker threads.
- Never archive, delete, rename, or recreate `ORCHESTRATOR`, `INTAKE`, or `UAT`.
- Ask before cleaning ambiguous state, dirty worktrees, unmerged branches, or threads not known to be worker threads.

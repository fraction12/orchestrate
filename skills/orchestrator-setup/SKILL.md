---
name: orchestrator-setup
description: Set up the Orchestrate operating model for a repository. Use when the user invokes /orchestrator:setup, /ochestrator:setup, asks to configure a Main Orchestrator with Intake and UAT threads, wants repo orchestration policy captured, or needs private ledger, heartbeat, worktree, QA, UAT, and merge defaults established before running /orchestrate.
---

# Orchestrator Setup

This is a visible entrypoint for the canonical `$orchestrate` setup route.

## Route

1. Locate the canonical `orchestrate` skill:
   - Prefer sibling user-scope path `../orchestrate/SKILL.md` relative to this skill directory.
   - Otherwise use `${CODEX_HOME:-$HOME/.codex}/skills/orchestrate/SKILL.md`.
   - If working inside the source repo, use `../../SKILL.md` when it has `name: orchestrate`.
2. Read the canonical `orchestrate` `SKILL.md` fully before acting.
3. Treat the user request as `/orchestrator:setup`.
4. Follow the canonical setup route and read its referenced files, especially `references/setup.md`, `references/blocking-questions.md`, and `references/private-ledger.md`.

If the canonical `orchestrate` skill is missing, stop and tell the user to install `$orchestrate` first. Do not recreate the orchestration workflow from memory.

## Guardrails

- Ask required setup questions one at a time.
- Do not create implementation workers during setup.
- Do not expose private thread ids, automation ids, or local env paths in public docs.
- Record setup state in the private ledger according to the canonical skill.

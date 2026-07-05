---
name: orchestrate
description: Run coding orchestration for one ticket, a ticket set, or a campaign through requirements intake, CE planning, worker execution, review subagents, PR creation, UAT, merge policy, automation, status, and cleanup. Use when the user invokes /orchestrate, /orchestrator:setup, /orchestrator:status, asks to orchestrate ready Linear/GitHub tickets, asks to run multiple worktree workers, wants a main orchestrator/intake/UAT thread system, or wants Codex automations to keep agent work moving without losing review and cleanup discipline.
---

# Orchestrate

This skill makes the active agent behave as a persistent engineering lead: it owns orchestration state, asks blocking policy questions before dispatch, creates and monitors workers, verifies claims, routes PRs to UAT, and cleans up completed work.

Use repo instructions when present, especially `ORCHESTRATOR.md` and `AGENTS.md`. If no repo orchestration contract exists, use the baked-in defaults here without exposing them publicly. Setup can offer to write repo docs, but `/orchestrate` must work cold.

## Command Router

Recognize these commands and route immediately:

- `/orchestrator:setup` - establish the orchestration operating model for this repo. Read `references/setup.md`.
- `/orchestrate` - run one orchestration unit through planning, workers, review, PR, UAT, merge policy, and cleanup. Read `references/execution.md`.
- `/orchestrator:status` - report current or latest orchestration state. Read `references/status.md`.

If the user says "orchestrate this" without a slash command, treat it as `/orchestrate`.

Normalize common aliases before routing:

- `/ochestrate` or `/orchestrator:run` -> `/orchestrate`.
- `/ochestrator:setup` -> `/orchestrator:setup`.
- `/ochestrator:status` -> `/orchestrator:status`.

## Non-Negotiables

- Use blocking questions as a first-class workflow gate. Do not start workers until required orchestration policy is known.
- Ask one question at a time. Prefer single-select multiple choice when choosing a policy or next step.
- In Codex, use the platform blocking question tool when available. If it is unavailable or errors, ask a numbered question in chat and wait for the answer.
- Never silently default important policy: UAT shape, merge authority, worktree environment setup, QA depth, worker/main heartbeat cadence, and whether the unit is a single ticket, ticket set, or campaign.
- Keep prompts compact and point workers to durable context. Do not stuff the whole project transcript into worker prompts or automations.
- Keep private orchestration state private. Do not publish thread ids, heartbeat ids, internal blocker notes, or local env details in public docs or PR text unless the user explicitly wants that.
- Treat worker claims as untrusted until checked against branch, diff, tests, PR metadata, CI, and visible behavior when relevant.
- Do not merge, archive, delete worktrees, mark issues done, or stop heartbeats merely because a worker says it finished.
- Carry plan alignment forward at every handoff. Every worker lane must know its source plan, unit IDs, requirement IDs, non-goals, drift stops, and verification gates.
- Treat CE skills as subroutines. The orchestrator owns the tail unless the user explicitly hands ownership to another workflow.

## Baked-In Defaults

When no `ORCHESTRATOR.md` exists, use this default contract:

- The current thread is the command center.
- Requirements live in an issue, a plan, or an explicitly confirmed user brief before implementation begins.
- If no implementation-ready plan exists, run or hand off to `ce-plan` before `ce-work`.
- Work is sliced into small PR-sized chunks.
- One worker is the default; use up to three only when file ownership and verification resources are clean.
- Workers implement; the orchestrator integrates.
- Worker heartbeats are worker-owned and compact.
- The main orchestrator heartbeat tracks active lanes and routes ready PRs to UAT.
- UAT receives the PR link, scope, verification evidence, screenshots/browser notes when relevant, and specific user-test prompts.
- Blocked lanes are parked with evidence; unrelated safe lanes continue.
- Cleanup is part of done: delete worker heartbeat, remove safe worktree, archive worker thread, update issue tracker, and report residual state.

## Required Blocking Questions

Use `references/blocking-questions.md` whenever setup or execution lacks required policy.

Minimum setup questions:

- Final UAT policy: combined test PR, individual PR UAT, or hybrid.
- Worktree env setup: repo script, symlink/copy local env, no worktrees for env-sensitive work, or ask per run.
- QA approach: fast, standard, or strict.
- Heartbeat cadence: worker and main orchestrator cadence.
- PR shipping authority: open PR only, notify UAT, merge after UAT approval, or auto-merge under explicit policy.

Minimum execution questions:

- Orchestration unit: single ticket, ticket set, or campaign.
- Source of requirements: existing issue/plan, create/repair plan first, or intake thread should refine.
- Concurrency: serial, limited parallel lanes, or campaign loop.
- UAT routing for this run when setup has no policy.

## Setup Responsibilities

When running `/orchestrator:setup`:

- Mark the current thread as the Main Orchestrator in private state.
- Create an Intake thread on local `main` for Linear/ticket requirements, `ce-brainstorm`, and `ce-plan`.
- Create a UAT thread on local `main` for PR acceptance testing and user-facing validation.
- Rename the Main Orchestrator thread to `ORCHESTRATOR`, the Intake thread to `INTAKE`, and the UAT thread to `UAT` so the user can find them in the Codex app.
- Store thread ids and setup policy in a private ledger. Prefer `.codex/orchestrator/state.json` only when it is ignored/local; otherwise use `$CODEX_HOME/orchestrator-state/<repo-id>/state.json`.
- Offer to create or update `ORCHESTRATOR.md`; do not require it.
- Create no implementation worker during setup.
- Use `references/private-ledger.md` for repo id derivation, safe local-vs-CODEX_HOME storage, locking, stale detection, and schema upgrades.

Use Codex thread tools when available. If they are not loaded, search for `create_thread`, `list_threads`, `read_thread`, `send_message_to_thread`, `set_thread_title`, `set_thread_archived`, and `automation_update`.

## Execution Responsibilities

When running `/orchestrate`:

- Discover repo root, current branch, dirty state, existing plans, active issues, active worktrees, active threads, and active automations.
- Classify the orchestration unit as a single ticket, ticket set, or campaign.
- Ensure requirements are durable enough. If not, route to Intake or `ce-brainstorm`/`ce-plan` before implementation.
- Enforce the alignment contract before worker launch: implementation-ready source, traceable unit IDs, explicit non-goals, drift stops, and verification gates.
- Build or update a private ledger entry before creating workers.
- Launch workers only after branch, worktree, and env readiness are checked.
- Create compact worker heartbeats and a main orchestrator heartbeat when work continues beyond the current turn.
- Use `references/automation-lifecycle.md` for heartbeat naming, payload shape, update/delete behavior, and status recovery.
- Require CE-style evidence from every worker handoff: behavior-change signal, tests inspected, tests added/changed/used unchanged, red failure or characterization evidence when applicable, verification run, and no-test exception reason when applicable.
- Run `ce-code-review` or equivalent review subagents after implementation and before shipping. Use machine-readable review mode when available so the orchestrator can apply or route findings.
- Use `ce-commit-push-pr` for shipping when the branch is ready.
- Use `references/uat-merge-policy.md` before combined or hybrid UAT, integration branches, merge stacks, and cleanup.
- Notify the UAT thread when a PR is ready for user validation.
- Watch checks when policy requires it, then merge only under explicit user or setup policy.
- Clean up after merge, cancellation, or deferral.

## Status Responsibilities

When running `/orchestrator:status`:

- Read private ledger first.
- If no ledger exists, reconstruct from recent Codex threads, git worktrees, branches, PRs, issue tracker state, and automations.
- Report by orchestration unit, not raw activity.
- Include active workers, branches, worktrees, PRs, heartbeats, UAT state, blockers, verified evidence, skipped checks, and next action.
- Label reconstructed facts as verified, inferred, stale, or missing. Do not present inferred state as verified.

## References

- `references/blocking-questions.md` - required question discipline and menus.
- `references/setup.md` - `/orchestrator:setup` wizard and private state.
- `references/execution.md` - `/orchestrate` lifecycle for single ticket, ticket set, and campaign.
- `references/private-ledger.md` - private state location, repo id, locking, stale detection, and schema upgrades.
- `references/automation-lifecycle.md` - heartbeat automation names, payloads, lifecycle, and recovery.
- `references/alignment-contract.md` - plan readiness, U-ID/R-ID traceability, and drift stop rules.
- `references/evidence-and-review.md` - proof strategy, worker evidence fields, and review finding handling.
- `references/ce-subroutine-contract.md` - how to invoke CE skills without losing orchestrator tail ownership.
- `references/uat-merge-policy.md` - individual, combined, and hybrid UAT branch/merge behavior.
- `references/status.md` - `/orchestrator:status` and recovery behavior.
- `references/templates.md` - worker, heartbeat, UAT, and status templates.

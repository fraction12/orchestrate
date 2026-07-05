---
name: orchestrate
description: Run coding orchestration for one ticket, a ticket set, or a campaign through Compound Engineering requirements intake, CE planning, dependency-aware parallel worktree workers, review subagents, PR creation, UAT, merge policy, automation, recovery, doctor health checks, status, cleanup, and repo-backed skill updates. Requires the Compound Engineering skill set for setup/execution; stop and request/install CE if missing. Use when the user invokes /orchestrate, /orchestrator:setup, /orchestrator:status, /orchestrator:recover, /orchestrator:doctor, /orchestrator:update, asks to orchestrate ready Linear/GitHub tickets, asks to recover orchestration work, asks to check/fix orchestrator setup health, asks to update the Orchestrator skill from GitHub, asks to run multiple worktree workers, wants a main orchestrator/intake/UAT thread system, or wants Codex automations to keep agent work moving without losing review and cleanup discipline.
---

# Orchestrate

This skill makes the active agent behave as a persistent engineering lead: it owns orchestration state, asks blocking policy questions before dispatch, creates and monitors workers, verifies claims, routes PRs to UAT, and cleans up completed work.

Use repo instructions when present, especially `ORCHESTRATOR.md` and `AGENTS.md`. If no repo orchestration contract exists, use the baked-in defaults here without exposing them publicly. Setup can offer to write repo docs, but `/orchestrate` must work cold.

This skill requires Compound Engineering. Before `/orchestrator:setup` or `/orchestrate`, read `references/compound-engineering-dependency.md` and verify the required CE skills are available. If CE is missing, stop and request/install the Compound Engineering plugin or tell the user how to install it. Do not proceed with an ad hoc orchestration substitute.

## Command Router

Recognize these commands and route immediately:

- `/orchestrator:setup` - establish the orchestration operating model for this repo. Read `references/setup.md`.
- `/orchestrate` - run one orchestration unit through planning, workers, review, PR, UAT, merge policy, and cleanup. Read `references/execution.md`.
- `/orchestrator:status` - report current or latest orchestration state. Read `references/status.md`.
- `/orchestrator:recover` - reconstruct and repair interrupted or stale orchestration work. Read `references/recover.md`.
- `/orchestrator:doctor` - check and fix Orchestrator setup health. Read `references/doctor.md`.
- `/orchestrator:update` - update the installed user-scope Orchestrator skills from the latest GitHub repo version. Read `references/update.md`.

If the user says "orchestrate this" without a slash command, treat it as `/orchestrate`.

Normalize common aliases before routing:

- `/ochestrate` or `/orchestrator:run` -> `/orchestrate`.
- `/ochestrator:setup` -> `/orchestrator:setup`.
- `/ochestrator:status` -> `/orchestrator:status`.
- `/ochestrator:recover` -> `/orchestrator:recover`.
- `/ochestrator:doctor` -> `/orchestrator:doctor`.
- `/ochestrator:update` -> `/orchestrator:update`.

## Non-Negotiables

- Require Compound Engineering. Do not run setup or execution without the required CE skills available.
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
- Prefer dependency-aware parallel worktree workers for ticket sets and campaigns. Use serial execution only when dependencies, shared files, or env limits require it.

## Baked-In Defaults

When no `ORCHESTRATOR.md` exists, use this default contract:

- The current thread is the command center.
- Requirements live in an issue, a plan, or an explicitly confirmed user brief before implementation begins.
- If no implementation-ready plan exists, run or hand off to `ce-plan` before `ce-work`.
- Work is sliced into small PR-sized chunks.
- One worker is the default for truly single-lane work; ticket sets and campaigns should use as much safe parallelism as dependency analysis allows.
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

- Verify the Compound Engineering dependency first. If missing, stop for install.
- Mark the current thread as the Main Orchestrator in private state.
- Create an Intake thread on local `main` for Linear/ticket requirements, `ce-brainstorm`, and `ce-plan`.
- Create a UAT thread on local `main` for PR acceptance testing and user-facing validation.
- Rename the Main Orchestrator thread to `ORCHESTRATOR`, the Intake thread to `INTAKE`, and the UAT thread to `UAT` so the user can find them in the Codex app.
- Store thread ids and setup policy in a private ledger. Prefer `.codex/orchestrator/state.json` only when it is ignored/local; otherwise use `$CODEX_HOME/orchestrator-state/<repo-id>/state.json`.
- Offer to create or update `ORCHESTRATOR.md`; do not require it.
- Create no implementation worker during setup.
- Use `references/thread-lifecycle.md` for Codex thread provisioning delays and stable thread titles.
- Use `references/private-ledger.md` for repo id derivation, safe local-vs-CODEX_HOME storage, locking, stale detection, and schema upgrades.
- Use `references/parallel-orchestration.md` to capture default parallelism policy and worktree/worker limits.

Use Codex thread tools when available. If they are not loaded, search for `create_thread`, `list_threads`, `read_thread`, `send_message_to_thread`, `set_thread_title`, `set_thread_archived`, and `automation_update`.

## Execution Responsibilities

When running `/orchestrate`:

- Verify the Compound Engineering dependency first. If missing, stop for install.
- If setup/ledger/thread health is missing or broken, route to `/orchestrator:doctor` or `/orchestrator:setup` before launching workers.
- Discover repo root, current branch, dirty state, existing plans, active issues, active worktrees, active threads, and active automations.
- Classify the orchestration unit as a single ticket, ticket set, or campaign.
- Use `references/parallel-orchestration.md` to decide whether to run a ticket set/campaign in parallel worktrees or ask whether a single ticket should become a parallel campaign.
- Ensure requirements are durable enough. If not, route to Intake or `ce-brainstorm`/`ce-plan` before implementation.
- Enforce the alignment contract before worker launch: implementation-ready source, traceable unit IDs, explicit non-goals, drift stops, and verification gates.
- Build or update a private ledger entry before creating workers.
- Launch workers only after branch, worktree, and env readiness are checked.
- Name every worker thread as `WORKER <lane-id> - <short work name>` and handle Codex thread provisioning delays through `references/thread-lifecycle.md`.
- Create compact worker heartbeats and a main orchestrator heartbeat when work continues beyond the current turn.
- Use `references/automation-lifecycle.md` for heartbeat naming, payload shape, update/delete behavior, and status recovery.
- Require CE-style evidence from every worker handoff: behavior-change signal, tests inspected, tests added/changed/used unchanged, red failure or characterization evidence when applicable, verification run, and no-test exception reason when applicable.
- Run `ce-code-review` or equivalent review subagents after implementation and before shipping. Use machine-readable review mode when available so the orchestrator can apply or route findings.
- Use `ce-commit-push-pr` for shipping when the branch is ready.
- Use `references/uat-merge-policy.md` before combined or hybrid UAT, integration branches, merge stacks, and cleanup.
- Notify the UAT thread when a PR is ready for user validation.
- Watch checks when policy requires it, then merge only under explicit user or setup policy.
- Clean up after merge, cancellation, or deferral.

## Recovery Responsibilities

When running `/orchestrator:recover`:

- Read `references/recover.md`.
- Reconstruct current/latest orchestration state from ledger, threads, automations, worktrees, branches, PRs, and issue tracker.
- Repair safe stale state only under recorded policy; otherwise produce an explicit recovery plan.
- Do not launch new implementation work unless recovery concludes the unit is healthy and the user asks to resume.

## Doctor Responsibilities

When running `/orchestrator:doctor`:

- Read `references/doctor.md`.
- Check CE availability, user-scope skill install, update script, repo setup, ledger, setup threads/titles, thread tools, automation tools, worktree/env policy, and GitHub auth.
- Fix safe setup drift when possible and report manual blockers.
- Route to `/orchestrator:setup` when setup is missing and the user wants to initialize it.

## Status Responsibilities

When running `/orchestrator:status`:

- Read private ledger first.
- Check and report Compound Engineering dependency availability.
- If no ledger exists, reconstruct from recent Codex threads, git worktrees, branches, PRs, issue tracker state, and automations.
- Report by orchestration unit, not raw activity.
- Include active workers, branches, worktrees, PRs, heartbeats, UAT state, blockers, verified evidence, skipped checks, and next action.
- Label reconstructed facts as verified, inferred, stale, or missing. Do not present inferred state as verified.

## Update Responsibilities

When running `/orchestrator:update`:

- Do not require Compound Engineering first.
- Read `references/update.md`.
- Update from the canonical private GitHub repo into user-scope skills.
- Validate the installed canonical skill and wrapper skills.
- Report the installed commit/ref and remind the user to restart Codex.

## References

- `references/blocking-questions.md` - required question discipline and menus.
- `references/compound-engineering-dependency.md` - required CE skills and install-gate behavior.
- `references/setup.md` - `/orchestrator:setup` wizard and private state.
- `references/execution.md` - `/orchestrate` lifecycle for single ticket, ticket set, and campaign.
- `references/parallel-orchestration.md` - dependency-aware parallel worktree and worker policy.
- `references/thread-lifecycle.md` - thread creation wait behavior, stable titles, and worker naming.
- `references/recover.md` - `/orchestrator:recover` state reconstruction and repair behavior.
- `references/doctor.md` - `/orchestrator:doctor` setup health checks and safe fixes.
- `references/private-ledger.md` - private state location, repo id, locking, stale detection, and schema upgrades.
- `references/automation-lifecycle.md` - heartbeat automation names, payloads, lifecycle, and recovery.
- `references/alignment-contract.md` - plan readiness, U-ID/R-ID traceability, and drift stop rules.
- `references/evidence-and-review.md` - proof strategy, worker evidence fields, and review finding handling.
- `references/ce-subroutine-contract.md` - how to invoke CE skills without losing orchestrator tail ownership.
- `references/uat-merge-policy.md` - individual, combined, and hybrid UAT branch/merge behavior.
- `references/status.md` - `/orchestrator:status` and recovery behavior.
- `references/update.md` - `/orchestrator:update` GitHub refresh behavior.
- `references/templates.md` - worker, heartbeat, UAT, and status templates.

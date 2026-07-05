# Execution

`/orchestrate` runs an orchestration unit. A unit can be a single ticket, a ticket set, or a campaign.

## Contents

- Phase 0: Resume Or Classify
- Phase 0A: Compound Engineering Gate
- Phase 0B: Setup Health Routing
- Phase 1: Intake And Readiness
- Phase 2: Plan Or Campaign Contract
- Phase 3: Worker Launch
- Phase 4: Watch And Unblock
- Phase 5: Review
- Phase 6: Ship
- Phase 7: Cleanup
- Unit-Specific Notes

## Phase 0: Resume Or Classify

Read private ledger first. If an active unit matches the prompt, resume it instead of starting a duplicate.

Read `private-ledger.md` before creating or updating state. If the ledger is locked or stale, reconstruct status first and avoid launching duplicate workers.

If no match exists, classify:

- Single ticket: one issue, plan, PR-bound slice, or requirement.
- Ticket set: multiple issues, a label/query, or a named group.
- Campaign: an objective that should keep producing PR-sized chunks until complete, blocked, or stopped.

If unclear, ask the Orchestration Unit blocking question.

## Phase 0A: Compound Engineering Gate

Read `compound-engineering-dependency.md` and verify required CE skills. If any required skill is missing, stop before planning, Intake handoff, worker creation, review, PR, UAT, or cleanup changes. Request/install Compound Engineering when the platform supports it, otherwise tell the user to install it and restart Codex.

## Phase 0B: Setup Health Routing

If setup is missing, partial, or contradictory:

- Route to `/orchestrator:setup` when no setup ledger/threads exist.
- Route to `/orchestrator:doctor` when partial setup exists or health is degraded.
- Route to `/orchestrator:recover` when active work exists but state is stale.

Do not launch workers until the setup path is healthy enough to track them.

## Phase 1: Intake And Readiness

Read repo instructions and existing orchestration contract:

- `ORCHESTRATOR.md` if present.
- `AGENTS.md` or equivalent instructions.
- Existing implementation-ready plan in `docs/plans/` if referenced.
- Issue tracker ticket(s) if available.
- Current branch, dirty state, active worktrees, active PRs, active threads, and automations.
- Existing heartbeat automations and whether they match the ledger.

Ready means:

- Product scope and acceptance criteria are known.
- Stop conditions/non-goals are known.
- Verification expectations are known.
- Tail ownership is known.
- For sets/campaigns, inventory and sequencing are known.

If readiness is missing:

- Route to Intake thread when setup exists.
- Otherwise run `ce-brainstorm` for product shape or `ce-plan` for implementation planning.
- Do not dispatch implementation workers from under-specified requirements.

If using CE skills during readiness, read `ce-subroutine-contract.md` first. The orchestrator owns the tail: CE planning can create or enrich the plan, but worker launch, review routing, UAT notification, merge policy, and cleanup stay with `/orchestrate`.

Read `parallel-orchestration.md` before deciding concurrency.

## Phase 2: Plan Or Campaign Contract

Single ticket:

- Use an existing implementation-ready plan or run `ce-plan`.
- Confirm worker scope, verification, and UAT route.
- Read `alignment-contract.md` and create a lane packet with source plan, U-IDs, R/F/AE/KTD references, non-goals, drift stops, and verification gates.
- If the ticket is large or has separable implementation units, ask whether to split it into a parallel campaign. If splitting, create/confirm the parent plan first, then require child plans for worker lanes.

Ticket set:

- Build or update a campaign plan with inventory, dependencies, lane ownership, stop conditions, verification, and definition of done.
- Sequence shared primitives first.
- Parallelize safe dependency layers in worktrees/workers by default.
- Require every lane to map to a plan unit, ticket, or explicit campaign slice. Do not allow generic "cleanup" lanes without a traceable objective.

Campaign:

- Create or update a durable campaign doc or issue state.
- Define scoreboard/backlog boundary, current slice selection rule, stop/continue rules, and status cadence.
- Keep automation prompt compact and point to the campaign state.
- Keep each loop iteration PR-sized and traceable to the campaign boundary. Update the ledger rather than editing plan progress checkboxes.
- Use parallel workers for independent campaign slices whenever dependency and env limits allow.

## Phase 3: Worker Launch

Use visible Codex worker threads for PR-bound implementation when available.

Read `thread-lifecycle.md` before creating worker threads. Every worker thread must have an intended title:

```text
WORKER <lane-id> - <short work name>
```

Launch pattern:

1. Create worker thread/worktree in standby.
2. If thread id is not immediately available, wait 60 seconds and perform one focused lookup before treating creation as failed.
3. Rename the worker thread to its intended `WORKER ...` title when the id is available.
4. Worker reads repo instructions and reports cwd, branch, and relevant plan visibility.
5. Orchestrator checks worker cwd and worktree env readiness.
6. Run repo setup script or configured env setup from the orchestrator side when needed.
7. Send the real implementation prompt.
8. Create worker heartbeat if the work may continue beyond the current turn.
9. Record thread id or pending id, thread title, title status, worktree, branch, issue, heartbeat, and expected deliverable in the ledger.

Before creating heartbeats, read `automation-lifecycle.md`. Reuse or update matching automations instead of creating duplicates.

Do not make the worker hand-run setup as its first meaningful task when the orchestrator can prepare the worktree.

Worker prompt must include:

- Goal and why it matters.
- Worker title and lane id.
- Issue or plan path.
- Unit IDs and requirement IDs when a plan exists.
- Branch policy.
- Files/surfaces to inspect first.
- Scope and non-goals.
- Drift stop rules.
- Verification commands.
- Evidence strategy expected for behavior-bearing work.
- Whether it may commit, push, open PR, or only hand off.
- Final handoff shape: changed files, behavior-change signal, tests inspected, tests added/changed/used unchanged, red failure or characterization evidence when applicable, verification run, no-test exception reason when applicable, commit/PR, blockers, residual risk.

## Phase 4: Watch And Unblock

The orchestrator must monitor until the unit is integrated, deferred, or canceled.

When a worker reports:

- Done: inspect branch, diff, tests, PR, visible behavior where relevant, and returned evidence fields. Mark omitted evidence as unverified rather than inventing it.
- Blocked: classify the blocker as worker-local, lane-specific, campaign-wide, external auth/tooling, or user decision.
- Needs decision: ask one blocking question, then send a narrow unblock prompt.

For lane-specific blockers, park the lane and continue unrelated safe lanes when policy allows.

Stop and ask or route back to Intake when implementation needs to change product behavior, acceptance criteria, source-plan requirements, excluded files, dependency posture, UAT policy, or merge authority.

## Phase 5: Review

After implementation and before shipping:

- Read `evidence-and-review.md`.
- Run `ce-code-review mode:agent plan:<plan-path> base:<base-ref>` when available and a plan/base can be resolved. Use the closest equivalent when not available.
- Spawn review subagents appropriate to risk: correctness, testing, maintainability, security, performance, product/design, API/data migration, or project standards.
- Pass raw diff/context, not your intended answer.
- Integrate valid review fixes.
- Re-run affected verification.
- Do not ship with unresolved P0/P1 findings. Record unresolved P2/P3 as residual risk only when policy allows.

Do not ship on worker self-review alone.

## Phase 6: Ship

Read `ce-subroutine-contract.md`. Use `ce-commit-push-pr` when the branch is ready and the user/policy permits shipping.

Read `uat-merge-policy.md` before notifying UAT, creating integration branches, or merging any PR.

Before PR:

- Confirm branch base and changed files.
- Run relevant verification.
- Ensure PR body includes scope, unit IDs/requirements when available, tests run, tests not run, UAT notes, residual risk, and issue links.
- Avoid sweeping staging. Stage intentional files only.

After PR:

- Notify UAT thread when policy says to.
- Include PR URL, scope, verification evidence, visual/browser evidence when relevant, and suggested user checks.
- After a successful UAT handoff, delete the main orchestrator heartbeat for this unit unless other worker lanes remain active.
- If policy requires continued watch after UAT handoff, create or update the separate UAT follow-up heartbeat; do not keep the main heartbeat alive as a UAT monitor.
- Watch CI/checks when policy requires it.
- Merge only under explicit policy.
- For combined or hybrid UAT, decide whether this PR is individually testable, part of an integration branch, or waiting for final combined test. Record that state in the ledger.

## Phase 7: Cleanup

After merge, cancellation, or explicit deferral:

- Read `references/cleanup.md` and follow the `/orchestrator:cleanup` safety gates for completed lanes.
- Delete worker heartbeat.
- Remove clean/safe worktree.
- Archive worker thread.
- Update issue tracker state.
- Update campaign doc or ledger.
- Keep branch cleanup separate unless user/policy explicitly says to delete local/remote branches.
- Report remaining active state.

For automations, read `automation-lifecycle.md` and delete only heartbeats whose unit/lane is truly complete, canceled, or deliberately parked. Leave `ORCHESTRATOR`, `INTAKE`, and `UAT` threads persistent.

## Unit-Specific Notes

### Single Ticket

Optimize for one clean PR or one small PR chain. Avoid creating a campaign doc unless the work grows.

When the user chooses to split, promote the single ticket into a campaign and track parent/child plans explicitly.

### Ticket Set

Track each ticket as a lane. Status should show ticket, plan, worker, branch, PR, UAT, blocker, and next action.

For combined UAT, keep a separate integration lane in the ledger instead of overloading a work lane.

Use dependency-layer parallelism by default.

### Campaign

Ship small PR-sized chunks. Keep the loop running through heartbeat automation. Do not let the automation prompt grow; move state into the ledger, issue tracker, or campaign doc.

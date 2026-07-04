# Status

`/orchestrator:status` reports current or latest orchestration work.

## Contents

- Source Order
- Status Shape
- Required Truth Labels
- Recovery Behavior
- Status Report Template

## Source Order

Read `private-ledger.md` and `automation-lifecycle.md` before reconstructing status.

1. Private orchestration ledger.
2. Active Codex threads for the repo.
3. Active automations and heartbeats.
4. Git worktrees and branches.
5. Open PRs and CI/check status.
6. Issue tracker state.
7. Recent plans or campaign docs.

If the ledger is missing or stale, reconstruct best effort and label each recovered fact.

## Status Shape

Report by orchestration unit.

For a single ticket:

- Ticket/plan.
- Source plan readiness and covered unit/requirement IDs.
- Worker thread and branch.
- PR/UAT state.
- Verification evidence.
- Review finding state.
- Blockers.
- Next action.

For a ticket set:

- Table of issues with lane, unit IDs, worker, PR, UAT, blocker, evidence, review state, and next action.
- Shared resource constraints.
- Final UAT policy and remaining integration work.

For a campaign:

- Objective/backlog boundary.
- Completed PRs.
- Active lanes.
- Parked blockers.
- Current scoreboard or next slice.
- Evidence and review coverage by shipped slice.
- Heartbeat and automation state.

## Required Truth Labels

Use these labels:

- Verified: directly checked against current tool output or files.
- Worker-reported: stated by a worker but not yet checked.
- Inferred: reconstructed from partial state.
- Stale: ledger or automation points to something outdated, missing, merged, closed, or no longer readable.
- Missing: not available from any source checked.

Never present worker-reported, inferred, stale, or missing status as verified.

## Recovery Behavior

When status reveals stale state:

- If a worker heartbeat exists for a completed/canceled worker, delete it only when cleanup policy allows; otherwise recommend deletion.
- If a clean completed worktree remains after merge, ask or clean it according to policy.
- If a PR is merged but local cleanup failed, verify remote state before retrying cleanup.
- If a branch is conflicted, check whether it still has unique diff before spending time on conflict repair.
- If UAT was not notified for a ready PR, notify the UAT thread with the PR packet.
- If an automation points at a missing thread/branch/unit, mark it stale or orphaned and repair only when policy allows.

## Status Report Template

```text
Orchestration status: <unit name>

Verified:
- <facts verified from ledger/git/PR/thread>

Inferred/Stale/Missing:
- <facts reconstructed or unavailable, with source checked>

Active lanes:
- <ticket>: <worker/thread>, <branch>, <PR/UAT/check state>, next action

Blocked or parked:
- <lane>: <blocker>, <owner>, <resume condition>

Verification:
- Passed: <commands/evidence>
- Not run: <commands/evidence> because <reason>

Plan alignment:
- Source: <plan/issue>
- Units/requirements: <ids>
- Drift: <none or explicit approved drift>

Review:
- Blocking findings: <none or list>
- Residual findings: <accepted risks>

Next:
- <one or two concrete next actions>

Remaining active state:
- Workers: <ids or none>
- Heartbeats: <ids or none>
- Worktrees: <paths or none>
- PRs: <urls or none>
```

# Status

`/orchestrator:status` reports current or latest orchestration work.

## Source Order

1. Private orchestration ledger.
2. Active Codex threads for the repo.
3. Active automations and heartbeats.
4. Git worktrees and branches.
5. Open PRs and CI/check status.
6. Issue tracker state.
7. Recent plans or campaign docs.

If the ledger is missing or stale, reconstruct best effort and say which facts are inferred.

## Status Shape

Report by orchestration unit.

For a single ticket:

- Ticket/plan.
- Worker thread and branch.
- PR/UAT state.
- Verification evidence.
- Blockers.
- Next action.

For a ticket set:

- Table of issues with lane, worker, PR, UAT, blocker, and next action.
- Shared resource constraints.
- Final UAT policy and remaining integration work.

For a campaign:

- Objective/backlog boundary.
- Completed PRs.
- Active lanes.
- Parked blockers.
- Current scoreboard or next slice.
- Heartbeat and automation state.

## Required Truth Labels

Use these labels:

- Confirmed: directly verified from tool output or files.
- Worker-reported: stated by a worker but not yet checked.
- Inferred: reconstructed from partial state.
- Unknown: not available.

Never present worker-reported or inferred status as confirmed.

## Recovery Behavior

When status reveals stale state:

- If a worker heartbeat exists for a completed/canceled worker, delete it.
- If a clean completed worktree remains after merge, ask or clean it according to policy.
- If a PR is merged but local cleanup failed, verify remote state before retrying cleanup.
- If a branch is conflicted, check whether it still has unique diff before spending time on conflict repair.
- If UAT was not notified for a ready PR, notify the UAT thread with the PR packet.

## Status Report Template

```text
Orchestration status: <unit name>

Confirmed:
- <facts verified from ledger/git/PR/thread>

Active lanes:
- <ticket>: <worker/thread>, <branch>, <PR/UAT/check state>, next action

Blocked or parked:
- <lane>: <blocker>, <owner>, <resume condition>

Verification:
- Passed: <commands/evidence>
- Not run: <commands/evidence> because <reason>

Next:
- <one or two concrete next actions>

Remaining active state:
- Workers: <ids or none>
- Heartbeats: <ids or none>
- Worktrees: <paths or none>
- PRs: <urls or none>
```

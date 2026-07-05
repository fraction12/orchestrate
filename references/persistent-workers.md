# Persistent Workers

Use this when setup or execution allows long-lived worker threads/worktrees for a campaign, code area, or product surface.

## Policy Meaning

Persistent workers are reusable area owners. They keep a Codex thread, worktree, branch, local env setup, and heartbeat across multiple slices while a campaign is active.

Use persistent workers when:

- A campaign will touch the same code areas repeatedly.
- Worker context about a subsystem is valuable across slices.
- The user wants fewer worker threads, fewer throwaway worktrees, and fewer per-lane PRs.
- The orchestrator will create checkpoint PRs only after meaningful integrated progress.

Do not use persistent workers when:

- The work is a small one-off ticket.
- The worktree cannot be kept safely up to date.
- The worker area ownership is unclear.
- Secrets/env state would become harder to protect.
- The user asked for clean throwaway worker lanes.

## Lifecycle Modes

Record one setup policy:

- `ephemeral-lanes`: workers are created for a lane and cleaned after merge/cancel/defer.
- `persistent-campaign-workers`: campaigns and broad ticket sets prefer reusable area workers; one-off tickets may still use ephemeral lanes.
- `ask-per-run`: choose worker lifecycle during `/orchestrate`.

Recommended default: `persistent-campaign-workers` when the user is building an ongoing campaign system; otherwise `ephemeral-lanes`.

## Persistent Worker Pool

A persistent worker owns an area, not one ticket:

- `areaId`: short stable id such as `shell`, `diagrams`, `workspace-core`, or `qa`.
- `title`: `WORKER <area-id> - <area name>`.
- `ownedSurfaces`: directories, modules, product surfaces, or verification resources it usually owns.
- `excludedSurfaces`: files/surfaces it must not touch without approval.
- `worktree`: durable worktree path.
- `branch`: durable campaign/area branch or current slice branch.
- `heartbeatId`: worker heartbeat, active while the worker has assigned or watch work.
- `state`: `available`, `assigned`, `blocked`, `parked`, `retired`.

Keep the pool in the private ledger. Do not publish worker ids, local worktree paths, or heartbeat ids in public issue/PR text.

## Assignment Rules

Before creating a new worker, check the pool:

1. Match the slice to an existing worker by `areaId`, owned surfaces, source plan unit, and current branch state.
2. Reuse the worker when the worktree is clean or intentionally carrying that area's unmerged campaign work.
3. Reprompt the existing thread with the new slice packet instead of creating a new thread.
4. Create a new persistent worker only when no existing worker owns the area or parallel capacity needs a new area owner.

Do not overload one persistent worker with unrelated areas just to avoid creating a thread. Area ownership must reduce drift, not hide it.

## Branch And PR Policy

Persistent workers normally do not open PRs.

Allowed worker outputs:

- Commit a coherent area slice on its persistent branch when policy allows.
- Leave a verified diff for the orchestrator to integrate.
- Report evidence, blockers, and residual risk.

Orchestrator-owned checkpoint PRs:

- The orchestrator decides when progress is significant enough for UAT.
- The orchestrator builds an integration/checkpoint branch or PR from verified worker outputs.
- The PR body cites the campaign slice, included worker commits/diffs, verification, UAT policy, and residual risk.
- UAT receives checkpoint PRs, not every internal worker slice, unless policy says otherwise.

## Reconciliation

At every main heartbeat, reconcile persistent workers before assigning more work:

- current branch and base;
- commits ahead of base;
- uncommitted diffs;
- stale or missing worker heartbeat;
- unread worker output;
- whether the worker is available, assigned, blocked, or parked;
- whether the worker branch has been integrated into the current checkpoint.

If a persistent worker is done with a slice, do not archive it by default. Mark it `available`, keep its thread/worktree, and delete or pause its heartbeat only when no wakeup is needed.

## Cleanup And Retirement

Cleanup must not remove persistent workers merely because a slice merged.

Allowed cleanup:

- Clean temporary checkpoint/integration branches after UAT/merge.
- Delete per-slice heartbeats that are no longer needed.
- Mark a persistent worker `available` or `parked`.

Retire a persistent worker only when:

- the campaign ends;
- the area ownership is no longer useful;
- the worktree is stale beyond repair;
- the user explicitly asks to clean it;
- or recovery determines the worker is unsafe to reuse.

Before retiring, verify all unique commits/diffs are merged, copied, parked, or intentionally discarded under explicit policy.

# Cleanup

`/orchestrator:cleanup` removes completed orchestration residue. It is not setup, status, or recover: cleanup acts only after work is merged, canceled, or explicitly parked with no wakeup required.

## Scope

Cleanup owns:

- Heartbeat and follow-up automations.
- Ephemeral worker worktrees, plus explicitly retired persistent worker worktrees.
- Local and remote branches for merged worker PRs.
- Merged/closed PR state in the private ledger and issue/task tracker.
- Ephemeral worker Codex threads, plus explicitly retired persistent worker threads.
- Completed ledger entries.
- Issue/task tracker completion notes when policy allows.

Cleanup must leave these persistent setup threads alone:

- `ORCHESTRATOR`
- `INTAKE`
- `UAT`

Do not archive, rename, delete, or recreate those threads during cleanup.

Cleanup must also preserve active persistent workers. Read `persistent-workers.md`. Persistent worker threads/worktrees/branches are protected while their campaign is active or their state is `available`, `assigned`, `blocked`, or `parked`.

## Evidence Gate

Before deleting anything, verify current state from available sources:

- Private ledger.
- Git worktrees and branches.
- PR state and merge commit/status.
- Active automations.
- Worker thread ids/titles.
- Issue tracker status when available.

Safe cleanup requires one of:

- PR is merged and the branch/worktree/thread belongs to that merged lane.
- Lane was explicitly canceled and the user/policy allows cleanup.
- Lane was explicitly deferred/parked with no wakeup required.
- Persistent worker was explicitly retired, the campaign ended, and all unique commits/diffs are merged, parked, or intentionally discarded under policy.

Ask one blocking question before cleaning anything outside the ledger, outside the `WORKER <lane-id> - <short work name>` naming pattern, or not clearly tied to a merged/canceled/deferred lane.

## Cleanup Order

1. Read `private-ledger.md`, `automation-lifecycle.md`, and `thread-lifecycle.md`.
2. Classify each unit/lane/worker as `cleanable`, `active`, `persistent-protected`, `parked`, `ambiguous`, or `protected`.
3. Delete cleanable heartbeat automations:
   - worker heartbeats for completed/canceled/deferred lanes;
   - main heartbeats after UAT handoff or completion when no active worker lanes remain;
   - UAT follow-ups after UAT/merge/deferral is settled.
4. Remove cleanable ephemeral worktrees:
   - never remove the main repo worktree;
   - run `git status --short` in the worktree and stop if dirty unless the user explicitly approves;
   - use `git worktree remove <path>` only after the branch/PR state is verified.
5. Delete merged branches:
   - never delete the current branch, default branch, or protected branches such as `main`, `master`, `develop`, `release/*`, or `production`;
   - local branch deletion requires verified merge into its target base or merged PR evidence;
   - remote branch deletion requires merged PR evidence and a branch name tied to the worker lane; ask before deleting remote branches outside the orchestrator/worker naming policy.
6. Update merged PR records:
   - keep the PR itself as source-of-truth history;
   - record merged/closed PR state, merge commit, branch cleanup, UAT result, and residual risk in the ledger;
   - update issue/task tracker status only when policy allows.
7. Archive ephemeral worker threads:
   - archive only threads recorded as ephemeral worker lanes or titled `WORKER ...` and not protected by persistent worker policy;
   - never archive `ORCHESTRATOR`, `INTAKE`, or `UAT`;
   - never archive active persistent worker threads; mark them available/parked unless retiring them under policy;
   - if `set_thread_archived` is unavailable, record the skipped archive action.
8. Move cleaned lanes from active to completed/cleaned state in the ledger and preserve evidence.
9. Report deleted, archived, skipped, and still-active items.

## Protected Items

Never clean these without explicit user instruction:

- Persistent setup threads: `ORCHESTRATOR`, `INTAKE`, `UAT`.
- Persistent worker threads/worktrees/branches for active campaigns.
- Main/default branch and its worktree.
- Branches with unmerged commits or unknown PR state.
- Dirty worktrees.
- Threads not known to be worker threads.
- Automations that point to active work.
- Ledgers or setup policy.

## Output

Report:

- Cleaned automations.
- Removed ephemeral or retired worktrees.
- Deleted local/remote branches.
- Verified merged/closed PRs and ledger updates.
- Archived ephemeral or retired worker threads.
- Ledger updates.
- Protected items left alone.
- Ambiguous items skipped with the exact reason and safest next action.

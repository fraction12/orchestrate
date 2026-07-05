# Recover

`/orchestrator:recover` reconstructs and repairs interrupted orchestration work. It is separate from status: status reports, recover acts when policy allows.

## Inputs

Read in order:

1. `private-ledger.md`
2. `automation-lifecycle.md`
3. `status.md`
4. Git worktrees, branches, and remotes.
5. PRs and CI/check state.
6. Codex threads and automations.
7. Issue tracker state.

## Recovery Classes

Classify each unit/lane:

- `healthy`: ledger, thread, branch, PR, automation, and UAT state agree.
- `stale-ledger`: external state moved but ledger did not.
- `orphaned-worker`: worker/thread/worktree remains after completion/cancel.
- `lost-thread`: ledger references a thread that cannot be read.
- `lost-automation`: heartbeat is missing or points at stale state.
- `blocked`: needs user/tool/auth decision.
- `unsafe`: state is contradictory or destructive cleanup could lose work.

## Safe Repairs

Allowed when policy is known:

- Update ledger from verified PR/branch/UAT state.
- Delete orphaned heartbeats for completed/canceled lanes.
- Mark missing worker evidence as unverified.
- Recreate a compact main heartbeat for active work.
- Notify UAT for a ready PR when policy already says to notify.
- Rename setup threads back to `ORCHESTRATOR`, `INTAKE`, and `UAT`.

Ask before:

- Deleting worktrees or branches.
- Closing/archiving threads.
- Merging, rebasing, or force-pushing.
- Restarting implementation.
- Changing UAT/merge policy.

## Output

Return:

- Recovered units and confidence labels.
- Repairs applied.
- Repairs recommended but not applied.
- Blockers and owners.
- Exact next resume prompt for Main Orchestrator or each worker.

Do not start new feature implementation from recover unless the user explicitly asks to resume after the recovery report.

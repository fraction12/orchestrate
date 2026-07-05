# Private Ledger

Use this whenever setup, execution, status, or cleanup reads or writes orchestration state.

## Repo Id

Derive `repoId` from stable local facts:

1. Resolve repo root with `git rev-parse --show-toplevel`.
2. Resolve canonical remote with `git remote get-url origin` when present.
3. Normalize remote by trimming credentials and trailing `.git`.
4. Compute a short hash from `<normalized-remote>|<repo-root>`.
5. Use `<repo-name>-<hash>` as the directory name.

If no remote exists, use `<repo-name>-local-<hash-of-repo-root>`.

## Storage Selection

Prefer local repo storage only when it is demonstrably private:

```bash
git check-ignore -q .codex/orchestrator/state.json
```

If ignored, use:

```text
<repo-root>/.codex/orchestrator/state.json
```

Otherwise use:

```text
${CODEX_HOME:-$HOME/.codex}/orchestrator-state/<repo-id>/state.json
```

Do not create or edit `.gitignore` unless the user or repo setup explicitly permits it. Never commit the ledger.

## Writes And Locking

Before writing:

- Create the parent directory with user-only permissions when possible.
- Acquire a lock by creating `<state>.lockdir` with `mkdir`.
- If the lock exists, inspect age. Treat a lock older than 30 minutes as stale only after verifying no active automation/thread is currently writing.
- Write to `<state>.tmp`, validate parseability, then atomically rename to `state.json`.
- Remove the lock after the write.

If locking fails and status can still be reconstructed, report read-only status rather than risking state corruption.

## Schema

Minimum top-level fields:

- `version`
- `repoId`
- `repoRoot`
- `repoName`
- `updatedAt`
- `threads`
- `policies`
- `automations`
- `activeUnits`
- `completedUnits`
- `persistentWorkers` when persistent worker lifecycle is enabled

Preserve unknown fields when updating. When the skill expects a newer schema, migrate forward in memory, write a `.bak` copy, then write the upgraded state.

For every active lane, preserve reconciliation fields when known:

- `baseRef` or base commit used for ahead/behind checks
- `lastVerifiedCommit`
- `branchDirtyState`
- `workerEvidenceState` such as `missing`, `worker-reported`, `needs-collection`, `verified`, or `incomplete`
- `automationStatus` such as `active`, `lost`, `stale`, `orphaned`, or `unknown`
- `lastReconciledAt`
- `workerLifecycle` such as `ephemeral-lane` or `persistent-area`
- `areaId` and `ownedSurfaces` for persistent workers

For every persistent worker, record:

- `areaId`
- `threadId`
- `threadTitle`
- `worktree`
- `branch`
- `ownedSurfaces`
- `excludedSurfaces`
- `state`: `available`, `assigned`, `blocked`, `parked`, or `retired`
- `currentSlice`
- `heartbeatId`
- `lastReconciledAt`
- `integratedThroughCommit` when a checkpoint PR has absorbed its work

## Worker Thread Correlation

For every worker create request, record enough data to resolve the worker without broad thread discovery:

- `laneId`
- `threadId` when returned
- `pendingThreadId` when returned
- `pendingWorktreeId` when returned
- `threadResolutionSource`
- `threadTitle`
- `expectedThreadTitle`
- `issueOrPlanTerms`
- `seedPromptSummary`
- `createdAt`
- `repoRoot`
- `branch`
- `worktree`
- `resolutionQueriesTried`

Keep these fields even after `threadId` is resolved so recovery can explain how the worker was bound.

## Stale Detection

Mark ledger entries stale when:

- A referenced branch no longer exists locally or remotely.
- A PR is merged, closed, or missing.
- A worker thread cannot be read.
- A setup thread is archived, unreadable, wrong-role, or explicitly replaced.
- An automation points to a missing or completed unit.
- The ledger records an active automation id but the automation tool/files cannot find it.
- The automation name/id in live state does not match the ledger's recorded id/name for the same unit/lane.
- A worker branch has commits ahead of the recorded base or uncommitted diffs that the lane state has not recorded.
- A worker thread is idle with unread output while the lane still lacks verified evidence.
- `updatedAt` is older than the heartbeat cadence and active work exists.

Stale is not failed. Reconstruct from git, PRs, threads, and automations before asking the user.

## Public Boundary

Private state may contain thread ids, automation ids, local paths, blocker notes, and env policy. Do not copy those into public PRs or external issue comments. Public text may include only user-facing scope, PR URLs, verification, UAT state, and residual risk.

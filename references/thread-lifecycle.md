# Thread Lifecycle

Use this whenever the orchestrator creates, identifies, renames, or records Codex threads.

## Provisioning Delay

Codex thread creation can take time. A missing thread id immediately after creation does not mean failure.

After a create/fork request:

1. If a thread id is returned, record it and continue.
2. If only pending state is returned, or no usable id is visible, wait 60 seconds before declaring failure.
3. After the wait, do not call broad `list_threads`. Record the thread as `pending` in the private ledger with the pending id, seed title, seed prompt summary, pending worktree id, and timestamp.
4. Retry title setting only when a concrete thread id becomes available from a create response, explicit user-provided id, or later direct tool result.
5. Report the exact recovery step: use `/orchestrator:doctor` or provide the thread id manually after Codex finishes provisioning it.

Do not burn repeated agent turns polling newly-created threads. Do not use broad thread listing as a recovery mechanism.

## Thread Listing Safety

Avoid broad `list_threads` in setup, execution, cleanup, status, and recover. Use only:

- thread ids already stored in the private ledger;
- ids returned by `create_thread` or fork/create responses;
- ids explicitly supplied by the user;
- direct reads/sends/title updates against known ids.

If the only way to find a thread would be broad listing, mark the thread state as `pending` or `unknown` and report the exact manual recovery step.

## Bounded Worker Resolution

Worker threads are different from setup threads: the orchestrator often creates them during the current run and must bind the returned thread id back to the lane ledger.

Pending worktree handles are not thread ids. Never use a `pendingWorktreeId`, queued worktree id, worktree path, or branch name as the target for `send_message_to_thread`, `read_thread`, `set_thread_title`, or archive/title operations. Treat those values as correlation fields for finding the real thread id.

For worker threads created in the current run, bounded resolution is allowed when all are true:

- the worker create request happened in the current run;
- the lane id, expected worker title, issue/plan terms, seed prompt summary, repo root, branch/worktree, and creation timestamp are already recorded;
- the create response returned a thread id, pending id, pending worktree id, queued id, or other correlation token, or the expected worker title is unique inside this orchestration unit;
- each lookup can be constrained to this repo/unit/title/lane/time window or to a recorded correlation token.

Resolution ladder:

1. Use a thread id returned directly by the create response.
2. Query by the exact intended worker title: `WORKER <lane-id> - <short work name>`.
3. If the exact title is not found, query by lane id plus issue/plan terms from the worker packet, because Codex may initially materialize the thread under an app-generated title.
4. If the user or UI indicates the worker threads are visible but still unresolved, perform one recent local thread lookup with the smallest available page/limit and immediately filter to current-run correlation fields: repo, lane ids, issue/plan terms, pending worktree ids, branch/worktree paths, and creation time.
5. If exactly one candidate maps to a lane, record it and rename it to the canonical `WORKER ...` title.

This is not permission for global thread inventory. Do not scan the whole Codex history to discover unrelated threads. Across one resolution pass, use at most one exact-title query per unresolved lane, at most one lane/issue query per unresolved lane, and at most one recent local thread page for the whole orchestration unit.

When a bounded lookup resolves exactly one worker thread:

- record `threadId`;
- clear or retain `pendingThreadId` as historical evidence;
- set `threadResolutionSource` to `create-response`, `exact-worker-title-query`, `lane-issue-query`, `recent-local-page`, or `user-provided`;
- apply the intended `WORKER <lane-id> - <short work name>` title when title tool is available.

If it resolves zero or multiple candidates, do not guess. Keep the lane in `pending-thread` state and ask for the direct worker thread id or retry via `/orchestrator:doctor`.

## Thread Usability

A setup or worker thread id is usable only with positive active proof. Positive active proof is one of:

- the thread was created in the current setup/execution run and returned a fresh id;
- a direct read/metadata result explicitly reports the thread is active and not archived;
- the user explicitly provides the id and says it is active and should be reused.

In addition, all must be true:

- the id is known from the ledger, a create response, or explicit user input;
- the thread is not archived;
- the title/role matches the expected role when known;
- it belongs to the same repo or orchestration unit when that can be verified.

Thread existence, matching title, a ledger id, or a successful search result is not positive active proof.

Do not probe a thread by performing an operation that could revive it. In particular, setup must not call `set_thread_archived` and must not send messages to a thread just to learn whether it is archived.

Archived threads are not usable setup threads. If a ledger points to an archived `INTAKE` or `UAT`, or if the user says those threads were archived, setup should mark the old entry `archived` or `stale`, create a replacement thread, and update the ledger. Do not unarchive archived setup threads unless the user explicitly asks to restore that exact archived thread.

## Stable Titles

Setup threads use exact titles:

- `ORCHESTRATOR`
- `INTAKE`
- `UAT`

These three setup threads are persistent. Setup, execution, cleanup, status, and recover must identify and reuse them when they exist. Do not recreate, archive, or delete them as part of normal orchestration cleanup.

Persistent does not mean immortal. If the user manually archived one of these setup threads, treat it as no longer usable and create a replacement during setup.

Worker threads must be named for the work they own:

```text
WORKER <lane-id> - <short work name>
```

Examples:

- `WORKER NEP-42 - Workspace Filters`
- `WORKER U3 - Mock Fixture Split`
- `WORKER CAM-2 - API Cleanup`

Keep titles short enough to scan in the Codex sidebar. Do not include secrets, local paths, private thread ids, or long issue descriptions.

## Title Status

Record title state in the ledger:

- `title`: intended visible title.
- `titleStatus`: `set`, `pending`, `failed`, or `unavailable`.
- `titleReason`: optional short reason when not `set`.

If title setting fails, do not block implementation solely for title failure, but report it in setup/status/recover output.

## Worker Thread Ledger Fields

Each worker lane should record:

- `threadId`
- `threadTitle`
- `titleStatus`
- `pendingThreadId` when applicable
- `laneId`
- `source`
- `branch`
- `worktree`
- `createdAt`

The worker title is private orchestration state. Public PRs/issues should mention ticket/slice and PR URL, not local thread metadata unless the user asks.

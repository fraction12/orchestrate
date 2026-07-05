# Thread Lifecycle

Use this whenever the orchestrator creates, identifies, renames, or records Codex threads.

## Provisioning Delay

Codex thread creation can take time. A missing thread id immediately after creation does not mean failure.

After a create/fork request:

1. If a thread id is returned, record it and continue.
2. If only pending state is returned, or no usable id is visible, wait 60 seconds before declaring failure.
3. After the wait, search/list/read recent repo threads once to resolve the created thread by repo, title, seed prompt, or pending worktree id.
4. Retry title setting once after the id is resolved.
5. If still unresolved, record the thread as `pending` in the private ledger with the pending id or evidence, and report the exact recovery step.

Do not burn repeated agent turns polling newly-created threads. Use one deliberate wait and one focused lookup.

## Stable Titles

Setup threads use exact titles:

- `ORCHESTRATOR`
- `INTAKE`
- `UAT`

These three setup threads are persistent. Setup, execution, cleanup, status, and recover must identify and reuse them when they exist. Do not recreate, archive, or delete them as part of normal orchestration cleanup.

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

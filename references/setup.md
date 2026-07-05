# Setup

`/orchestrator:setup` installs the repo's orchestration operating model. It must not start implementation work.

## Contents

- Phase 1: Inspect
- Phase 1A: Compound Engineering Gate
- Phase 2: Ask Required Questions
- Phase 3: Create Or Identify Threads
- Phase 4: Rename Threads
- Phase 5: Private Ledger
- Phase 6: Optional ORCHESTRATOR.md
- Setup Completion Report

## Phase 1: Inspect

Read:

- `AGENTS.md` or equivalent repo instruction files.
- `ORCHESTRATOR.md` if present.
- `.codex/environments/*` if present.
- `.compound-engineering/config.local.yaml` if present.
- `package.json`, task config, CI config, and existing `docs/plans/` conventions when relevant.
- Existing private orchestration ledger if present.
- `compound-engineering-dependency.md` before creating threads or writing setup state.
- `private-ledger.md` before deciding where state belongs.
- `thread-lifecycle.md` before creating or renaming threads.
- `parallel-orchestration.md` before asking concurrency/worktree questions.

Determine:

- Repo root and default branch.
- Package manager and validation commands.
- Whether worktree setup already exists.
- Whether issue tracker tools are available.
- Whether thread tools and automation tools are available.

## Phase 1A: Compound Engineering Gate

Read `compound-engineering-dependency.md` and verify required CE skills. If any required skill is missing, stop setup before asking policy questions, creating threads, renaming threads, or writing the private ledger. Request/install Compound Engineering when the platform supports it, otherwise tell the user to install it and restart Codex.

## Phase 2: Ask Required Questions

Use `blocking-questions.md`. Ask one setup question at a time:

1. Final UAT policy.
2. Worktree environment setup.
3. QA policy.
4. Heartbeat cadence.
5. PR shipping authority.
6. Max safe parallel worker count and shared resource limits.

If Final UAT is combined or hybrid and repo policy does not already define integration behavior, also ask Combined UAT Strategy.

Do not create Intake/UAT threads until these policies are known, unless the user explicitly says to use defaults. If they say "use defaults", record the recommended option for each question.

## Phase 3: Create Or Identify Threads

Use Codex thread tools. If not loaded, search only for `create_thread`, `send_message_to_thread`, `set_thread_title`, and `automation_update`.

Do not call broad `list_threads` during setup. Large or old Codex histories can make thread listing unstable. Setup must rely on the private ledger, create-thread return values, pending ids, or explicit user-provided thread ids.

Do not call `set_thread_archived` during setup. Setup must never unarchive, restore, reopen, or otherwise bring back archived setup threads. If an archived setup thread is found, create a fresh replacement instead.

If thread tools are unavailable, do not fake thread creation. Record setup as partial, store the missing capability in the ledger, and tell the user that Intake/UAT routing will stay in the Main Orchestrator until tools are available.

Read `thread-lifecycle.md`. If created Intake/UAT threads do not immediately return ids, wait 60 seconds, then record `pending` state instead of listing threads.

Create or identify:

- Main Orchestrator: current thread.
- Intake Thread: local `main`, same repo, no worktree. Purpose: task-tracker-agnostic requirements intake, `ce-brainstorm`, `ce-plan`, ticket/doc grooming.
- UAT Thread: local `main`, same repo, no worktree. Purpose: PR acceptance testing, user validation, combined UAT, final approval notes.

Before creating Intake or UAT, check the private ledger and any explicit thread ids the user supplied for existing usable setup threads. A setup thread is usable only when `thread-lifecycle.md` says it has positive active proof. Archived, unreadable, missing, wrong-role, or merely found-by-title threads are not usable. If `ORCHESTRATOR`, `INTAKE`, and `UAT` already exist and have positive active proof for this repo, reuse them, refresh their ledger entries, and skip thread creation. Later `/orchestrate` runs in the same Main Orchestrator thread must not recreate Intake or UAT when usable active setup threads exist.

If the ledger points at archived Intake or UAT threads, or if the user says those setup threads were archived, do not reuse those ids even when Codex can still find them. Mark the old ledger entries `archived`/`stale`, create replacement Intake/UAT threads, and write the new ids or pending ids back to the ledger.

If the thread tool does not expose archive state, do not infer active state from the existence of an id, title, or successful lookup. Reuse only when there is positive active proof or the user explicitly confirms the id is active and should be reused.

Thread prompts must be compact.

Intake thread seed:

```text
Use /orchestrator:intake.

You are the INTAKE thread for this repo. Stay on local main. Own task-tracker-agnostic requirement capture, ticket/doc grooming, ce-brainstorm, and ce-plan. Read references/intake.md from the Orchestrator skill. Do not implement code. Do not ask ORCHESTRATOR to start work unless the user explicitly chooses that after intake output is ready.
```

UAT thread seed:

```text
Use /orchestrator:uat.

You are the UAT thread for this repo. Stay on local main. Read references/uat.md from the Orchestrator skill. When ORCHESTRATOR sends a ready PR, inspect the PR scope, verification evidence, screenshots/browser notes when relevant, and produce user-facing acceptance/blocker notes. Do not merge or edit implementation code unless explicitly asked.
```

## Phase 4: Rename Threads

Rename threads immediately after creation or identification:

- Main Orchestrator: `ORCHESTRATOR`
- Intake Thread: `INTAKE`
- UAT Thread: `UAT`

Use `set_thread_title` when available and the thread id is known. If a thread id is pending, title setting must stay pending too; do not list threads to find it. If title updates fail or the tool is unavailable, do not block setup. Record `titleStatus` as `failed`, `pending`, or `unavailable` in the ledger and include the fallback in the setup completion report.

Avoid adding repo names, ticket numbers, or dates to these three setup thread titles. Their job is stable sidebar findability.

## Phase 5: Private Ledger

Read `private-ledger.md`. Persist setup state privately. Prefer `.codex/orchestrator/state.json` only if local/ignored. Otherwise use:

```text
$CODEX_HOME/orchestrator-state/<repo-id>/state.json
```

Minimum state shape:

```json
{
  "version": 1,
  "repoId": "repo-hash",
  "repoRoot": "/abs/path",
  "repoName": "repo",
  "updatedAt": "iso-8601",
  "threads": {
    "main": {
      "id": "thread-id",
      "title": "ORCHESTRATOR",
      "titleStatus": "set",
      "lifecycleStatus": "active"
    },
    "intake": {
      "id": "thread-id",
      "pendingThreadId": null,
      "title": "INTAKE",
      "titleStatus": "set",
      "lifecycleStatus": "active",
      "replacesThreadId": null
    },
    "uat": {
      "id": "thread-id",
      "pendingThreadId": null,
      "title": "UAT",
      "titleStatus": "set",
      "lifecycleStatus": "active",
      "replacesThreadId": null
    }
  },
  "policies": {
    "finalUat": "hybrid",
    "worktreeEnv": "repo-setup-script",
    "qa": "standard",
    "workerHeartbeat": "5m",
    "mainHeartbeat": "10m",
    "shippingAuthority": "open-pr-notify-uat",
    "maxParallelWorkers": 3,
    "sharedResourceLimits": []
  },
  "automations": [],
  "activeUnits": [],
  "completedUnits": []
}
```

Do not commit this ledger. Do not expose it in public docs.

## Phase 6: Optional ORCHESTRATOR.md

If no `ORCHESTRATOR.md` exists, offer to create one after setup. It should include repo-specific policy and link to durable docs, not local thread ids or private automation ids.

If one exists, offer to update it only when setup decisions materially change repo policy.

## Setup Completion Report

Report:

- Main, Intake, and UAT thread ids, or pending state with the exact manual recovery step.
- Any archived/stale setup thread ids that were replaced.
- Thread titles and any title-setting fallback.
- Policy decisions.
- Ledger location.
- Whether `ORCHESTRATOR.md` was created, updated, left unchanged, or skipped.
- Any tools unavailable and the fallback used.

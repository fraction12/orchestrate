# Setup

`/orchestrator:setup` installs the repo's orchestration operating model. It must not start implementation work.

## Contents

- Phase 1: Inspect
- Phase 1A: Compound Engineering Gate
- Phase 2: Ask Required Questions
- Phase 3: Create Threads
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

If Final UAT is combined or hybrid and repo policy does not already define integration behavior, also ask Combined UAT Strategy.

Do not create Intake/UAT threads until these policies are known, unless the user explicitly says to use defaults. If they say "use defaults", record the recommended option for each question.

## Phase 3: Create Threads

Use Codex thread tools. If not loaded, search for them. Include `set_thread_title`.

If thread tools are unavailable, do not fake thread creation. Record setup as partial, store the missing capability in the ledger, and tell the user that Intake/UAT routing will stay in the Main Orchestrator until tools are available.

Create or identify:

- Main Orchestrator: current thread.
- Intake Thread: local `main`, same repo, no worktree. Purpose: Linear/ticket requirements, `ce-brainstorm`, `ce-plan`, issue grooming.
- UAT Thread: local `main`, same repo, no worktree. Purpose: PR acceptance testing, user validation, combined UAT, final approval notes.

Thread prompts must be compact.

Intake thread seed:

```text
You are the Intake thread for this repo. Stay on local main. Own Linear/ticket requirement refinement, ce-brainstorm, and ce-plan. Do not implement code unless the Main Orchestrator explicitly asks. Keep requirements durable in issues or docs/plans and report readiness back to the Main Orchestrator.
```

UAT thread seed:

```text
You are the UAT thread for this repo. Stay on local main. When the Main Orchestrator sends a ready PR, inspect the PR scope, verification evidence, screenshots/browser notes when relevant, and produce a user-facing UAT checklist plus acceptance/blocker notes. Do not merge or edit implementation code unless explicitly asked.
```

## Phase 4: Rename Threads

Rename threads immediately after creation or identification:

- Main Orchestrator: `ORCHESTRATOR`
- Intake Thread: `INTAKE`
- UAT Thread: `UAT`

Use `set_thread_title` when available. If title updates fail or the tool is unavailable, do not block setup. Record `titleStatus` as `failed` or `unavailable` in the ledger and include the fallback in the setup completion report.

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
      "titleStatus": "set"
    },
    "intake": {
      "id": "thread-id",
      "title": "INTAKE",
      "titleStatus": "set"
    },
    "uat": {
      "id": "thread-id",
      "title": "UAT",
      "titleStatus": "set"
    }
  },
  "policies": {
    "finalUat": "hybrid",
    "worktreeEnv": "repo-setup-script",
    "qa": "standard",
    "workerHeartbeat": "5m",
    "mainHeartbeat": "10m",
    "shippingAuthority": "open-pr-notify-uat"
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

- Main, Intake, and UAT thread ids.
- Thread titles and any title-setting fallback.
- Policy decisions.
- Ledger location.
- Whether `ORCHESTRATOR.md` was created, updated, left unchanged, or skipped.
- Any tools unavailable and the fallback used.

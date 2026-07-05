# Doctor

`/orchestrator:doctor` checks and fixes Orchestrator setup health. It is separate from recover: doctor handles environment/setup, recover handles active orchestration state.

## Checks

Run these checks:

- Orchestrator user-scope skills installed: `orchestrate`, `orchestrator-setup`, `orchestrator-intake`, `orchestrator-uat`, `orchestrator-status`, `orchestrator-recover`, `orchestrator-cleanup`, `orchestrator-doctor`, `orchestrator-update`.
- Installed skills validate.
- Update script exists and can run in dry or version-discovery mode when possible.
- Compound Engineering dependency is available or installable.
- GitHub CLI auth works for repo operations.
- Repo root/default branch are detectable.
- Setup ledger exists, is private, parseable, and current.
- Main, Intake, and UAT threads exist when setup has run.
- Ledger-known setup threads are usable, active, and not archived; archived Intake/UAT threads should be marked stale and recreated by setup.
- Thread titles are `ORCHESTRATOR`, `INTAKE`, and `UAT`.
- Worker threads for active lanes follow `WORKER <lane-id> - <short work name>` when their ids are available.
- Doctor avoids broad `list_threads`; missing thread ids are reported as pending/manual recovery instead of scanning all Codex threads.
- Doctor may run bounded worker resolution for workers created in the current run when the ledger has correlation fields. It should map resolved threads back to lanes, rename them to canonical worker titles, and record `threadResolutionSource`.
- Cleanup command is installed and can be routed for completed residue.
- Thread tools, automation tools, and `set_thread_title` availability.
- Worktree env policy and concurrency policy are recorded.
- No nested wrapper skills are installed under `orchestrate/skills`.

## Safe Fixes

Apply without asking when clearly safe:

- Reinstall Orchestrator user-scope skills from the current source checkout.
- Remove nested duplicate wrapper skills under the canonical install.
- Re-run skill validation.
- Rename setup threads to stable titles only when thread ids are positively active and title tool is available.
- Mark archived/unusable setup thread ledger entries stale and route to setup for replacement.
- Rename active worker threads to stable `WORKER ...` titles when thread ids and lane ids are known.
- Add missing non-secret ledger fields while preserving unknown fields.

Doctor must not unarchive setup threads or use archived setup threads as active. If the user archived INTAKE or UAT, doctor should mark the ledger stale and route setup to create fresh replacements.

Ask before:

- Running `/orchestrator:setup`.
- Installing Compound Engineering.
- Editing repo docs such as `ORCHESTRATOR.md`.
- Changing concurrency, UAT, QA, or merge policy.
- Deleting worktrees, branches, automations, or threads.

## Routing

When `/orchestrate` is invoked and setup is missing:

- If no setup ledger and no setup threads exist, route to `/orchestrator:setup`.
- If partial setup exists, route to `/orchestrator:doctor`.
- If active work exists but state is stale, route to `/orchestrator:recover`.

## Output

Report:

- Health: `healthy`, `degraded`, or `blocked`.
- Checks passed.
- Fixes applied.
- Manual actions needed.
- Whether setup, recover, or orchestration can safely continue.

# Update

`/orchestrator:update` refreshes the installed user-scope Orchestrator skills from the latest GitHub repo version.

## Behavior

This command updates skill installation only. It must not run orchestration setup, create threads, change repo worktrees, modify private ledgers, or require Compound Engineering.

Default source:

```text
https://github.com/fraction12/orchestrate.git
```

Default ref:

```text
main
```

Allow overrides only when explicitly provided:

- `ORCHESTRATE_REPO_URL`
- `ORCHESTRATE_REF`

## Steps

1. Run `scripts/update-user-scope-from-github.sh` from the installed or source skill.
2. Let the script clone/fetch the requested repo/ref into a temp directory.
3. Let the fetched repo run `scripts/install-user-scope.sh`.
4. Validate installed skills.
5. Report the updated commit/ref and tell the user to restart Codex.

## Failure Handling

If GitHub auth fails, tell the user to authenticate with GitHub if the selected repo/ref requires it and rerun `/orchestrator:update`.

If validation fails, stop and report the failing skill path. Do not partially invent fixes.

If network is unavailable, report that update could not reach GitHub. Existing installed skills remain in place unless the install script reports otherwise.

## Installed Skills

The update must leave exactly these top-level user-scope Orchestrator skills:

- `orchestrate`
- `orchestrator-setup`
- `orchestrator-intake`
- `orchestrator-uat`
- `orchestrator-status`
- `orchestrator-recover`
- `orchestrator-doctor`
- `orchestrator-update`

The canonical `orchestrate` install must not include nested `skills/*/SKILL.md` wrappers.

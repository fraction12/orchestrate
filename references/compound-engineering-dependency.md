# Compound Engineering Dependency

Use this before `/orchestrator:setup` and `/orchestrate`. Orchestration is not allowed without Compound Engineering.

## Required Skills

Verify these CE skills are available before setup or execution:

- `compound-engineering:ce-brainstorm`
- `compound-engineering:ce-plan`
- `compound-engineering:ce-work`
- `compound-engineering:ce-code-review`
- `compound-engineering:ce-commit-push-pr`
- `compound-engineering:ce-setup`

Recommended, but not a hard blocker unless the run needs them:

- `compound-engineering:ce-worktree`
- `compound-engineering:ce-doc-review`
- `compound-engineering:ce-simplify-code`
- `compound-engineering:ce-resolve-pr-feedback`

## Verification

Use the skill list available in the current Codex context. If the current context does not expose skill metadata clearly, look for the CE plugin skill paths under the Codex plugin cache only as a fallback.

Do not treat similarly named local skills as equivalent. The dependency is the Compound Engineering plugin skill set.

## Missing Dependency Behavior

If any required CE skill is missing:

1. Stop before setup, worker creation, planning, implementation, review, PR, UAT, or cleanup changes.
2. Tell the user which required CE skills are missing.
3. If plugin install tools are available, request installation of the Compound Engineering plugin.
4. If plugin install tools are unavailable, tell the user to install the Compound Engineering plugin and restart Codex.
5. After installation/restart, rerun the dependency check before continuing.

Do not fall back to hand-written planning, generic work execution, generic code review, or raw git push/PR behavior. This skill's premium behavior depends on CE contracts and handoffs.

## Setup And Status

`/orchestrator:setup` may inspect the repo enough to explain that CE is missing, but it must not create Intake/UAT threads, write the private ledger, or establish orchestration policy until CE is available.

`/orchestrator:status` may still run without CE so the user can diagnose state, but it must include `Compound Engineering: missing` or `Compound Engineering: available` in the report.

# CE Subroutine Contract

Use Compound Engineering skills as specialized phases while keeping `/orchestrate` as the owner of state, UAT routing, merge authority, and cleanup.

## Ownership Rule

The orchestrator owns:

- Private ledger.
- Worker/thread/heartbeat lifecycle.
- UAT notification.
- Merge policy.
- Cleanup.
- Cross-ticket/campaign sequencing.

CE skills own their local phase only:

- `ce-brainstorm`: product shape and requirements-only plan.
- `ce-plan`: implementation-ready plan.
- `ce-work`: implementation and local verification for a bounded unit.
- `ce-code-review`: review findings.
- `ce-commit-push-pr`: commit, push, and PR creation when policy allows.

## Planning

If source requirements are not implementation-ready:

```text
ce-plan <source>
```

After planning, re-read plan metadata and the relevant Goal Capsule, Implementation Units, Verification Contract, and Definition of Done. Do not assume planning succeeded just because a file was written.

## Work

When using `ce-work` as a subroutine, prefer caller-owned tail behavior when the harness/skill supports it:

```text
ce-work mode:return-to-caller <plan-path-or-unit-packet>
```

Expected effect: implementation and local verification return to the orchestrator; the orchestrator owns review, PR, UAT, and cleanup.

If return-to-caller mode is unavailable, make tail ownership explicit in the worker prompt: the worker may implement and locally verify, but must not merge or cleanup unless policy says so.

## Review

Prefer machine-readable review:

```text
ce-code-review mode:agent plan:<plan-path> base:<base-ref>
```

The orchestrator parses findings, applies valid fixes, and reruns verification. Do not treat review output as user-facing final status until findings are triaged.

## Shipping

Use `ce-commit-push-pr` only after:

- Source alignment passes.
- Worker evidence is complete or exceptions are recorded.
- Blocking review findings are fixed.
- Required verification has run or limitations are explicit.
- UAT and merge policy are known.

When invoking `ce-commit-push-pr`, preserve orchestrator context in the PR body:

- Source plan or issue.
- Unit IDs and requirement IDs.
- Scope and non-goals.
- Verification run.
- Checks not run and why.
- UAT notes.
- Residual risk.

## Handoff Menus

CE skills often end with menus. In orchestration runs, do not let a CE handoff menu stall the orchestration when policy already answers the next step. Continue according to the ledger policy. If the menu asks for a policy not in the ledger, ask one blocking question and record the answer.

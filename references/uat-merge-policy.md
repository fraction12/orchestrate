# UAT And Merge Policy

Use this before notifying UAT, building integration branches, merging PRs, or cleaning up completed work.

## Policy Meanings

Individual PR UAT:

- Each work PR is tested and accepted independently.
- A PR may merge after its own UAT approval and required checks, if merge authority allows.
- Combined regression testing is optional unless the setup policy says otherwise.

Combined UAT only:

- Do not ask the user to accept individual PRs as final.
- Create an integration branch or temporary local merge stack for testing the set together.
- Individual PRs may remain open until the combined test passes.

Hybrid UAT:

- Notify UAT for each ready PR.
- Also run a final combined test when a ticket set/campaign slice completes.
- Merge timing follows the setup policy: either after individual UAT, after final combined UAT, or after explicit user approval.

## Combined Test Options

Choose the safest available option:

1. Integration branch PR: create `orchestrator/<unit-id>-uat` from the base branch, merge candidate PR heads in dependency order, open a UAT-only PR, and delete it after final merge/deferral.
2. Temporary local merge stack: merge candidate branches locally for verification without pushing, then reset/clean up after reporting.
3. Sequential individual PR validation: use only when branches cannot be combined safely; label this as a limitation.

Ask one blocking question when policy does not specify which combined strategy to use and more than one is viable.

## Integration Branch Rules

Before creating an integration branch:

- Confirm all candidate PRs target the same base.
- Confirm no candidate PR is closed/merged/stale.
- Confirm dependency order.
- Confirm worktree and env setup can support the combined run.

During integration:

- Merge PR heads in dependency order.
- Stop on conflicts and route back to the owning lane.
- Run the agreed combined verification gates.
- Do not treat the integration PR as the final implementation PR unless the user explicitly asks.

After combined UAT:

- If accepted, merge the real work PRs according to policy.
- If rejected, route blockers to the owning lane and keep the integration branch parked or delete it after recording evidence.
- Delete temporary branches/worktrees when safe.

## Merge Authority

Merge only when all are true:

- Setup or user policy grants merge authority.
- Required checks pass or skipped checks are explicitly accepted.
- UAT policy is satisfied.
- No P0/P1 review findings remain open.
- Approved drift is recorded.
- Cleanup plan is known.

If any condition is unclear, ask one blocking question before merging.

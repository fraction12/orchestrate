# Execution

`/orchestrate` runs an orchestration unit. A unit can be a single ticket, a ticket set, or a campaign.

## Phase 0: Resume Or Classify

Read private ledger first. If an active unit matches the prompt, resume it instead of starting a duplicate.

If no match exists, classify:

- Single ticket: one issue, plan, PR-bound slice, or requirement.
- Ticket set: multiple issues, a label/query, or a named group.
- Campaign: an objective that should keep producing PR-sized chunks until complete, blocked, or stopped.

If unclear, ask the Orchestration Unit blocking question.

## Phase 1: Intake And Readiness

Read repo instructions and existing orchestration contract:

- `ORCHESTRATOR.md` if present.
- `AGENTS.md` or equivalent instructions.
- Existing implementation-ready plan in `docs/plans/` if referenced.
- Issue tracker ticket(s) if available.
- Current branch, dirty state, active worktrees, active PRs, active threads, and automations.

Ready means:

- Product scope and acceptance criteria are known.
- Stop conditions/non-goals are known.
- Verification expectations are known.
- Tail ownership is known.
- For sets/campaigns, inventory and sequencing are known.

If readiness is missing:

- Route to Intake thread when setup exists.
- Otherwise run `ce-brainstorm` for product shape or `ce-plan` for implementation planning.
- Do not dispatch implementation workers from under-specified requirements.

## Phase 2: Plan Or Campaign Contract

Single ticket:

- Use an existing implementation-ready plan or run `ce-plan`.
- Confirm worker scope, verification, and UAT route.

Ticket set:

- Build or update a campaign plan with inventory, dependencies, lane ownership, stop conditions, verification, and definition of done.
- Sequence shared primitives first.
- Parallelize only disjoint file ownership.

Campaign:

- Create or update a durable campaign doc or issue state.
- Define scoreboard/backlog boundary, current slice selection rule, stop/continue rules, and status cadence.
- Keep automation prompt compact and point to the campaign state.

## Phase 3: Worker Launch

Use visible Codex worker threads for PR-bound implementation when available.

Launch pattern:

1. Create worker thread/worktree in standby.
2. Worker reads repo instructions and reports cwd, branch, and relevant plan visibility.
3. Orchestrator checks worker cwd and worktree env readiness.
4. Run repo setup script or configured env setup from the orchestrator side when needed.
5. Send the real implementation prompt.
6. Create worker heartbeat if the work may continue beyond the current turn.
7. Record thread id, worktree, branch, issue, heartbeat, and expected deliverable in the ledger.

Do not make the worker hand-run setup as its first meaningful task when the orchestrator can prepare the worktree.

Worker prompt must include:

- Goal and why it matters.
- Issue or plan path.
- Branch policy.
- Files/surfaces to inspect first.
- Scope and non-goals.
- Verification commands.
- Whether it may commit, push, open PR, or only hand off.
- Final handoff shape: changed files, verification, commit/PR, blockers, residual risk.

## Phase 4: Watch And Unblock

The orchestrator must monitor until the unit is integrated, deferred, or canceled.

When a worker reports:

- Done: inspect branch, diff, tests, PR, and visible behavior where relevant.
- Blocked: classify the blocker as worker-local, lane-specific, campaign-wide, external auth/tooling, or user decision.
- Needs decision: ask one blocking question, then send a narrow unblock prompt.

For lane-specific blockers, park the lane and continue unrelated safe lanes when policy allows.

## Phase 5: Review

After implementation and before shipping:

- Run `ce-code-review` when available.
- Spawn review subagents appropriate to risk: correctness, testing, maintainability, security, performance, product/design, API/data migration, or project standards.
- Pass raw diff/context, not your intended answer.
- Integrate valid review fixes.
- Re-run affected verification.

Do not ship on worker self-review alone.

## Phase 6: Ship

Use `ce-commit-push-pr` when the branch is ready and the user/policy permits shipping.

Before PR:

- Confirm branch base and changed files.
- Run relevant verification.
- Ensure PR body includes scope, tests run, tests not run, residual risk, and issue links.

After PR:

- Notify UAT thread when policy says to.
- Include PR URL, scope, verification evidence, visual/browser evidence when relevant, and suggested user checks.
- Watch CI/checks when policy requires it.
- Merge only under explicit policy.

## Phase 7: Cleanup

After merge, cancellation, or explicit deferral:

- Delete worker heartbeat.
- Remove clean/safe worktree.
- Archive worker thread.
- Update issue tracker state.
- Update campaign doc or ledger.
- Keep branch cleanup separate unless user/policy explicitly says to delete local/remote branches.
- Report remaining active state.

## Unit-Specific Notes

### Single Ticket

Optimize for one clean PR or one small PR chain. Avoid creating a campaign doc unless the work grows.

### Ticket Set

Track each ticket as a lane. Status should show ticket, plan, worker, branch, PR, UAT, blocker, and next action.

### Campaign

Ship small PR-sized chunks. Keep the loop running through heartbeat automation. Do not let the automation prompt grow; move state into the ledger, issue tracker, or campaign doc.

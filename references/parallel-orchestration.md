# Parallel Orchestration

Use this during setup and `/orchestrate` planning. The default posture is to use safe parallel worktree workers whenever work can be separated by dependency and ownership.

## Setup Policy

During `/orchestrator:setup`, record:

- Max concurrent workers.
- Worktree env setup policy.
- Whether worker worktrees may run package install/dev servers.
- Shared resource limits: ports, databases, API quotas, browser sessions, simulators.
- Preferred lane branch naming.

Recommended default: up to three parallel workers when dependencies and resource limits are clean.

## Ticket Sets

For a ticket set, assume parallel execution is desired.

Before dispatch:

1. Build an inventory of tickets, plans, files/surfaces, dependencies, and verification gates.
2. Group lanes into dependency layers.
3. Run independent lanes in parallel worktrees/workers up to the setup concurrency limit.
4. Serialize lanes that share files, migrations, public APIs, shared state, singleton env resources, or unclear ownership.
5. Recompute the next layer after each merge or blocker.

Do not run broad ticket sets serially merely because serial is simpler. Serial execution requires a concrete dependency, conflict, or environment reason.

## Single Ticket Split

For one ticket, ask whether to keep it as one lane or split it into a parallel campaign when:

- It contains multiple independent user-facing changes.
- It has several implementation units or separable surfaces.
- The user values speed and parallel work is likely safe.
- The ticket is large enough that independent planning would reduce risk.

Do not force a split for small, tightly-coupled, or high-risk single-lane work.

## Parent And Child Plans

When splitting one ticket:

1. Require or create a parent implementation-ready plan for the original ticket using `ce-plan`.
2. Derive child lanes from the parent plan's implementation units, requirements, dependencies, and non-goals.
3. Each child lane must get its own child plan before implementation.
4. Worker agents may run `ce-plan` for their assigned child ticket/slice, but the orchestrator owns review of each child plan before `ce-work`.
5. Child plans must cite the parent plan, parent unit IDs, requirement IDs, non-goals, drift stops, and verification gates.

Do not let a worker invent a child scope without parent-plan traceability.

## Worker Dispatch

Each parallel worker must receive:

- Lane id and child/parent plan path.
- Dependency layer.
- Owned files/surfaces and excluded files.
- Worktree branch and env setup policy.
- Drift stops.
- Verification gates.
- Evidence fields required on handoff.
- Tail policy.

The orchestrator integrates in dependency order. Workers do not merge.

## Abort Parallelism

Stop or reduce parallelism when:

- Two workers modify the same file unexpectedly.
- A lane changes shared contracts outside its scope.
- Verification resources contend.
- Repeated merge conflicts appear.
- A child plan reveals hidden dependency on another active lane.

Record the reason in the ledger and continue serially or by smaller batches.

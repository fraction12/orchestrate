# Alignment Contract

Use this before launching workers and before shipping. The goal is to keep every lane traceable to the plan or explicitly approved user intent.

## Source Readiness

Classify the source before implementation:

- Unified plan with `artifact_contract: ce-unified-plan/v1`, `artifact_readiness: implementation-ready`, and `execution: code`: eligible for implementation.
- Unified plan with `artifact_readiness: requirements-only`: not eligible. Route to `ce-plan` first.
- Invalid readiness values such as `active`, `in_progress`, `complete`, or `done`: stop for plan repair.
- Issue or user brief only: eligible only for small/clear work; otherwise route to Intake, `ce-brainstorm`, or `ce-plan`.
- Ticket set or campaign: requires an inventory plus sequencing, stop conditions, verification expectations, and definition of done.

Do not treat implementation progress as plan state. Progress lives in git, PRs, issue tracker comments, and the private ledger.

## Lane Packet

Every worker lane must have:

- `unitId`: implementation unit ID such as `U3`, or a named ticket/campaign slice when no plan exists.
- `source`: plan path, issue id, PR, or confirmed user brief.
- `requirementIds`: relevant R/F/AE/KTD IDs when present.
- `goal`: one concrete outcome.
- `scope`: in-scope bullets.
- `nonGoals`: out-of-scope bullets.
- `firstFiles`: files/surfaces to inspect first.
- `patterns`: patterns or prior code/docs to follow.
- `verificationGates`: commands and evidence expected.
- `driftStops`: conditions that require stopping or asking.
- `tailPolicy`: commit/push/PR/merge/UAT permissions.

For large plans, send a bounded packet to workers instead of "read the whole plan": Goal Capsule, Definition of Done, the active U-ID section, relevant requirements, relevant verification entries, and cited pattern files.

## Drift Stops

Stop and ask one blocking question, or route to Intake, when work would:

- Change product behavior or acceptance criteria beyond the source contract.
- Touch explicit non-goals or excluded files.
- Add or change dependencies, external services, storage shape, migrations, auth/security posture, or public API contracts beyond the plan.
- Require a different UAT, QA, branch, merge, or release policy.
- Expand a ticket into a set/campaign or collapse a set/campaign into one risky PR.
- Ignore a plan dependency or sequencing rule.
- Skip a required verification gate without an environmental reason.

Record approved drift in the ledger and PR body. Unapproved drift blocks shipping.

## Ledger Alignment Fields

Track alignment in private state:

```json
{
  "unitId": "U3",
  "source": "docs/plans/example.md",
  "requirementIds": ["R2", "AE4"],
  "status": "active",
  "workerThreadId": "thread-id",
  "branch": "codex/example-u3",
  "baseRef": "origin/main",
  "changedFiles": [],
  "verificationGates": [],
  "evidence": {},
  "review": {
    "blockingFindings": [],
    "residualFindings": []
  },
  "uatState": "not-notified",
  "mergeState": "not-ready",
  "cleanupState": "not-started",
  "approvedDrift": []
}
```

## Shipping Alignment Check

Before PR creation or merge:

- Confirm every changed file belongs to the lane packet or approved drift.
- Confirm every claimed unit/requirement has evidence.
- Confirm no required stop condition is open.
- Confirm UAT notification policy is satisfied.
- Confirm unresolved review findings are either blocking or explicitly accepted residual risk.

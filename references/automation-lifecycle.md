# Automation Lifecycle

Use this when creating, updating, reading, or deleting orchestrator heartbeats.

## Tool Use

When automation tools are available, search for and use the platform automation tool instead of writing raw automation directives. If unavailable, record the missing tool in the ledger and keep status manual.

## Names

Use predictable names:

- Main heartbeat: `orchestrator:<repo-name>:<unit-id>:main`
- Worker heartbeat: `orchestrator:<repo-name>:<unit-id>:worker:<lane-id>`
- UAT follow-up: `orchestrator:<repo-name>:<unit-id>:uat`

Names are private tracker labels, not public issue text.

## Payload Shape

Keep automation prompts compact:

```text
Continue orchestrating <unit-id> for <repo-name>.

Read the private ledger at <ledger-location>. Verify thread, branch, PR, UAT, checks, blockers, and cleanup state. Move only safe next actions. If a PR is ready, notify UAT with the PR packet. If policy is missing or a drift stop is hit, ask one blocking question. Update the ledger before finishing.
```

Worker payloads must include lane id, expected branch/worktree, source plan or issue, verification gates, and the final evidence fields. Do not paste full plans into automations.

## Creation Rules

Create a heartbeat only when work may continue beyond the current turn or when a long-running worker/campaign needs monitoring.

Record in the ledger:

- `automationId`
- `name`
- `unitId`
- `laneId` when applicable
- `cadence`
- `threadId`
- `createdAt`
- `lastSeenAt`
- `status`

Do not create duplicate heartbeats for the same active unit/lane. Update the existing automation when cadence or payload changes.

## Status Recovery

During `/orchestrator:status`, classify each automation:

- `active`: target thread/unit exists and work is not done.
- `stale`: target branch, thread, PR, or unit is missing.
- `orphaned`: unit is complete/canceled but automation still exists.
- `unknown`: automation cannot be read.

For stale/orphaned automations, repair or delete only when policy allows. Otherwise report the exact cleanup recommendation.

## Deletion Rules

Delete worker heartbeats after the lane is integrated, canceled, or explicitly parked with no wakeup required.

Delete the main heartbeat immediately after the orchestrator successfully hands the ready PR or integration PR to the UAT thread, unless there are still active worker lanes that require main orchestration. Once work is in UAT, do not leave the main heartbeat lingering as a generic monitor.

If policy requires the orchestrator to watch UAT/checks after handoff, create or update a separate UAT follow-up automation named `orchestrator:<repo-name>:<unit-id>:uat`. Its payload must be limited to UAT/check status, merge-authority policy, and cleanup after UAT. Do not reuse the main heartbeat for this phase.

Delete the main heartbeat only after:

- all lanes are merged, canceled, or deferred;
- UAT and merge policy are satisfied or explicitly skipped;
- cleanup is complete or recorded as residual work;
- the final status has been reported.

This final-delete rule applies when the main heartbeat is still legitimately coordinating active implementation or integration lanes. A successful handoff to UAT is an earlier delete condition for the main heartbeat.

Never stop a heartbeat solely because a worker says it is done.

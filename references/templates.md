# Templates

Keep prompts compact. Point to durable context instead of copying whole transcripts.

## Contents

- Worker Standby Prompt
- Worker Implementation Prompt
- Worker Heartbeat Prompt
- Main Orchestrator Heartbeat Prompt
- Automation Payload
- UAT Notification
- Linear/Issue Comment

## Worker Standby Prompt

```text
Stand by as the implementation worker for <repo>/<ticket-or-slice>.

Expected thread title: WORKER <lane-id> - <short work name>
Lane id: <lane-id>
Lifecycle: <ephemeral lane or persistent area worker>
Owned area/surfaces: <owned surfaces when persistent>

Read:
- AGENTS.md or repo instructions
- ORCHESTRATOR.md if present
- <plan-or-issue-path>

Report:
- cwd
- current branch/ref
- whether the plan/issue is visible
- whether expected local env links/dependencies are present

Do not edit files yet. Wait for the Main Orchestrator's implementation prompt.
```

## Worker Implementation Prompt

```text
Implement <ticket/slice> now.

Goal:
- <concrete outcome and why it matters>

Thread:
- Title: WORKER <lane-id> - <short work name>
- Lane id: <lane-id>

Read and follow:
- <repo instructions>
- <ORCHESTRATOR.md if present>
- <plan/issue path>

Scope:
- In scope: <items>
- Non-goals: <items>
- Unit IDs: <U-IDs or none>
- Requirement IDs: <R/F/AE/KTD IDs or none>
- First files/surfaces to inspect: <files>
- Drift stops: stop and report before changing product behavior, acceptance criteria, excluded files, dependency posture, UAT/merge policy, or work outside the assigned unit.

Branch and PR policy:
- Branch: <branch expectation>
- You may <commit/push/open PR/handoff only>.
- Persistent worker policy: if this is a persistent area worker, do not open individual PRs unless ORCHESTRATOR explicitly asks; hand off verified slices for orchestrator checkpoint PRs.
- Do not merge to main.

Verification expected:
- <commands>
- <browser/UAT evidence if relevant>
- Evidence strategy: inspect existing tests first; for behavior changes, prefer failing proof or characterization before production changes when practical.
- If a gate cannot run, report exact command/error and residual risk.

Final handoff must include:
- changed files
- behavior changed? yes/no
- existing tests inspected
- tests added/changed/used unchanged
- red failure or characterization evidence when applicable
- commit hash if any
- PR URL if any
- verification commands/results
- no-test exception reason when applicable
- blockers
- residual risk
- heartbeat id/name if one exists and should be deleted
```

## Worker Heartbeat Prompt

```text
Continue <ticket/slice> in this worker thread.

Stay inside scope from <plan/issue>. Keep the branch/worktree and lifecycle policy. Run the agreed verification. If ready, hand off or open the expected PR according to policy. Persistent workers should normally hand off verified slices and remain available for the next assignment rather than opening PRs or expecting cleanup. If blocked, report the exact blocker and whether it blocks only this lane or the whole orchestration unit. Notify the Main Orchestrator when done, blocked, or needing a decision, and include the heartbeat name plus whether it should be deleted, paused, or kept.
```

## Main Orchestrator Heartbeat Prompt

```text
Continue orchestrating <unit>.

Read the private ledger and repo contract. First reconcile live state: actual automations by recorded id, persistent worker pool, worker branch/worktree commits or diffs, PRs/checks, UAT state, blockers, and ledger-known thread ids. Treat missing worker heartbeats, automation name/id mismatches, branch commits, dirty diffs, and idle worker threads with unread turns as state to verify and record before prompting workers. Reuse persistent area workers before creating new workers when policy enables them. Keep moving safe lanes. When a checkpoint or PR is ready, notify the UAT thread with PR URL, scope, included worker areas/commits, verification evidence, visual/browser evidence when relevant, and concrete user-test prompts. After successful UAT handoff, delete this main heartbeat unless active worker lanes remain; create/update the separate UAT follow-up heartbeat only if policy requires continued watching. Do not merge or cleanup unless policy allows. Keep the heartbeat compact; durable state belongs in the ledger, issue tracker, or campaign doc.
```

## Automation Payload

```text
Continue orchestrating <unit-id> for <repo>.

Read:
- private ledger: <location>
- ORCHESTRATOR.md if present
- active plan/issue: <path-or-id>

First reconcile ledger state against live automations, worker branches/worktrees, PRs/checks, UAT, review, verification, blockers, cleanup, and known thread ids. Treat missing active automation ids, automation name/id drift, branch commits/diffs, and idle workers with unread turns as state to verify and record. Move only safe next actions. Ask one blocking question if policy is missing or a drift stop is hit. Update the ledger before finishing.
```

## UAT Notification

```text
PR ready for UAT: <PR URL>

Scope:
- <what changed>
- Plan alignment: <unit IDs / requirements / approved drift>

Verification:
- Passed: <commands/evidence>
- Not run: <commands/evidence and reason>

Review:
- Blocking findings: <none or list>
- Residual risks: <risks>

Suggested UAT:
- <user-facing checks>

Known risks:
- <residual risks>

Policy:
- <individual/combined/hybrid UAT>
- Combined strategy: <integration branch / temporary local merge stack / not applicable>
- Merge authority: <policy>
```

## Linear/Issue Comment

```text
Orchestration started.

- Unit: <single ticket/ticket set/campaign>
- Scope: <scope>
- Non-goals: <non-goals>
- Worker thread(s): <ids if safe for private tracker; omit from public-facing trackers if not appropriate>
- Worker title(s): <private tracker only; omit from public-facing trackers if not appropriate>
- Branch/PR policy: <policy>
- Verification: <expected gates>
- UAT policy: <policy>
```

Use public issue comments carefully. Do not include local secrets, local env paths, or private heartbeat details in external/public trackers.

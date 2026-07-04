# Templates

Keep prompts compact. Point to durable context instead of copying whole transcripts.

## Contents

- Worker Standby Prompt
- Worker Implementation Prompt
- Worker Heartbeat Prompt
- Main Orchestrator Heartbeat Prompt
- UAT Notification
- Linear/Issue Comment

## Worker Standby Prompt

```text
Stand by as the implementation worker for <repo>/<ticket-or-slice>.

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

Stay inside scope from <plan/issue>. Keep the branch/worktree policy. Run the agreed verification. If ready, hand off or open the expected PR according to policy. If blocked, report the exact blocker and whether it blocks only this lane or the whole orchestration unit. Notify the Main Orchestrator when done, blocked, or needing a decision, and include the heartbeat name so it can be deleted.
```

## Main Orchestrator Heartbeat Prompt

```text
Continue orchestrating <unit>.

Read the private ledger and repo contract. Check active workers, PRs, UAT state, blockers, and heartbeats. Keep moving safe lanes. When a PR is ready, notify the UAT thread with PR URL, scope, verification evidence, visual/browser evidence when relevant, and concrete user-test prompts. Do not merge or cleanup unless policy allows. Keep the heartbeat compact; durable state belongs in the ledger, issue tracker, or campaign doc.
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
- Merge authority: <policy>
```

## Linear/Issue Comment

```text
Orchestration started.

- Unit: <single ticket/ticket set/campaign>
- Scope: <scope>
- Non-goals: <non-goals>
- Worker thread(s): <ids if safe for private tracker; omit from public-facing trackers if not appropriate>
- Branch/PR policy: <policy>
- Verification: <expected gates>
- UAT policy: <policy>
```

Use public issue comments carefully. Do not include local secrets, local env paths, or private heartbeat details in external/public trackers.

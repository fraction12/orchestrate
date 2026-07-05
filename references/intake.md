# Intake

`/orchestrator:intake` creates and refines durable requirements. It is task-tracking-system agnostic.

## Role

Intake owns:

- Capturing ideas, bugs, requests, and requirements.
- Choosing or asking where the work should live.
- Creating/updating task tracker tickets when a tracker is available and selected.
- Creating/updating markdown requirements or plan docs when local docs are selected.
- Running `ce-brainstorm` or `ce-plan` when requirements need product shaping or implementation planning.

Intake does not implement code, launch workers, merge PRs, run UAT, or start orchestration on its own.

## Preflight

On the first intake interaction for a repo, inspect:

- Repo instructions: `AGENTS.md`, `ORCHESTRATOR.md`, and docs conventions.
- Existing `docs/plans/`, `docs/intake/`, or issue templates.
- Available Codex task-tracker tools or skills, such as Linear, GitHub issues, Notion, or repo-local docs.
- User-provided tracker preference.

If the capture destination is unclear, ask one blocking question:

```text
Where should I capture this intake item?

1. Detected task tracker: <Linear/GitHub/Notion/etc.>
2. Markdown in repo docs: <docs/intake or docs/plans>
3. Ask me each time
```

Only show options that are actually available. If no tracker is available, offer markdown docs and ask whether the user wants help connecting a tracker.

Record the answer in private setup state when available.

## Ticket Creation

For every intake item, gather enough information to make it durable:

- Problem or opportunity.
- User-visible outcome.
- Acceptance criteria.
- Non-goals.
- Known constraints.
- Verification/UAT notes.
- Links, screenshots, logs, or source context.
- Whether it should become a single ticket, ticket set, or campaign candidate.

Use `ce-brainstorm` for vague product shape. Use `ce-plan` when the user wants implementation-ready planning.

## After Creation

After creating or updating a ticket/doc/plan, ask one blocking question:

```text
Intake is ready at <ticket/doc/plan>. What should I do next?

1. Leave it ready in Intake.
2. Notify ORCHESTRATOR to consider this next.
3. Keep refining it here.
```

Do not notify ORCHESTRATOR unless the user chooses that option.

When notifying ORCHESTRATOR, send a compact packet:

- Link/path/id.
- Readiness: idea, requirements-only, implementation-ready.
- Suggested unit type: single ticket, ticket set, or campaign.
- Any blockers or open questions.

## Public Boundary

Do not include private thread ids, local ledger paths, local env details, or automation ids in public task tracker text.

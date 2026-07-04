# Blocking Questions

Use blocking questions to prevent bad orchestration. Important policy must be explicit before workers start.

## Contents

- Rules
- Setup Questions
- Execution Questions

## Rules

- Ask one question per turn.
- Prefer single-select multiple choice for policy decisions.
- Use multi-select only when compatible options can coexist.
- Use an open-ended question only when options would distort the answer.
- In Codex, use the platform blocking question tool when available. If unavailable, ask numbered choices in chat and wait.
- Do not auto-resolve required setup or execution questions.
- Once answered, write the decision to the private orchestration ledger.

## Setup Questions

Ask these during `/orchestrator:setup` unless already present in trusted private state and the user is only refreshing setup.

### Final UAT Policy

Question: "How should final UAT work for orchestrated work in this repo?"

1. Hybrid UAT (recommended): individual PR UAT plus a final combined test when a set/campaign completes.
2. Individual PR UAT: each PR is tested and accepted independently.
3. Combined UAT only: merge work into one integration PR before user testing.

### Worktree Environment Setup

Question: "How should implementation worktrees get local environment setup?"

1. Repo setup script (recommended): run the repo's setup/link script from the worker worktree.
2. Link local env: symlink/copy approved local env files and dependencies from the canonical checkout.
3. No worktrees for env-sensitive work: use local main for measurement-sensitive campaigns.
4. Ask each run: decide per ticket or campaign.

### QA Policy

Question: "What QA bar should orchestrated work use by default?"

1. Standard (recommended): focused tests plus typecheck/build and UI/browser evidence when user-visible.
2. Fast: focused tests only unless risk grows.
3. Strict: full validation ladder plus browser/UAT evidence before PR handoff.

### Heartbeat Cadence

Question: "What heartbeat cadence should this repo use?"

1. Workers 5 min, main 10 min (recommended).
2. Workers 10 min, main 15 min.
3. Custom cadence.

If custom is chosen, ask one open-ended follow-up for the exact worker cadence and main cadence.

### PR Shipping Authority

Question: "What may the orchestrator do after implementation and review?"

1. Open PR and notify UAT (recommended): merge waits for user/UAT approval.
2. Open PR only: no UAT notification unless asked.
3. Merge after UAT approval: orchestrator may merge once UAT approves and checks pass.
4. Auto-merge under policy: only if the user explicitly grants standing merge authority.

## Execution Questions

Ask these during `/orchestrate` when not obvious from the prompt.

### Orchestration Unit

Question: "What is the orchestration unit?"

1. Single ticket: one issue or plan.
2. Ticket set: several known issues or a label/query.
3. Campaign: keep shipping PR-sized chunks until the objective is complete, blocked, or stopped.

If the prompt clearly names multiple tickets, a label, or "all", infer ticket set or campaign and confirm before dispatch.

### Requirements Source

Question: "Where should the worker take requirements from?"

1. Existing implementation-ready plan.
2. Existing issue or requirements-only plan; run `ce-plan` first.
3. Intake thread should refine requirements before implementation.

### Concurrency

Question: "How should worker lanes run?"

1. Serial (recommended when shared files or uncertain dependencies exist).
2. Limited parallel: up to two or three lanes with disjoint file ownership.
3. Campaign loop: keep creating the next safe PR-sized lane after each merge.

### UAT Routing For This Run

Ask only when setup has no UAT policy.

Question: "How should UAT happen for this run?"

1. Notify UAT thread for every ready PR.
2. Notify UAT after all set/campaign PRs are ready.
3. Skip UAT notification and report only in this thread.

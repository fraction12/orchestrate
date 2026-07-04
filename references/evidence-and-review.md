# Evidence And Review

Use this after worker implementation and before shipping.

## Evidence Strategy

Workers must choose and report an evidence strategy before marking work done.

For behavior-bearing work, prefer:

1. Existing failing test that already proves the intended behavior.
2. Updated/strengthened existing test, run before implementation to observe the expected failure.
3. New focused failing test, run before implementation.
4. Characterization test or baseline capture before changing legacy/risky behavior.
5. Deliberate no-test exception with replacement verification.

Do not fabricate red/characterization evidence after the fact. If the worker omitted it, mark it unverified or re-run what can still be proven.

## Worker Evidence Fields

Require these fields in worker handoff:

- `behavior_changed`: yes/no.
- `existing_tests_inspected`: paths or "none found".
- `tests_added_changed_or_used`: paths and purpose.
- `red_or_characterization_evidence`: command/result or "not applicable" with reason.
- `verification_run`: commands and results.
- `no_test_exception`: reason and replacement verification, if applicable.
- `visual_or_uat_evidence`: screenshots/browser/manual evidence, if applicable.
- `residual_risk`: remaining risk.

## Orchestrator Verification

The orchestrator must inspect actual branch/diff state. Reported paths are hints only.

Check:

- Changed files vs lane packet.
- Test changes vs behavior changes.
- Verification commands actually run.
- UI/browser evidence for user-visible work when policy requires it.
- Environmental limitations recorded as limitations, not success.

## Code Review

When CE is available, prefer:

```text
ce-code-review mode:agent plan:<plan-path> base:<base-ref>
```

Use `plan:<path>` when a source plan exists. Use `base:<ref>` when reviewing the current checkout against a known base. If a PR exists and the current checkout is not aligned, use the PR number/URL per CE's review rules.

The orchestrator applies or routes findings:

- P0/P1: block shipping until fixed or explicitly rejected by the user.
- P2: fix if straightforward; otherwise record residual risk.
- P3: optional; record only if useful.

After fixes, rerun targeted verification and repeat review when the fix is non-trivial.

## Review Coverage In Status

Record:

- Review command or equivalent subagents.
- Base reviewed.
- Plan used.
- Blocking findings fixed.
- Findings left as residual risk.
- Verification rerun after fixes.

# Multi-gate execution batches

## Goal

Allow an agent to complete an approved sequence of gates without unnecessary
human pauses while preserving deliberate checkpoints for decisions and risk.

## Approved scope

- Let a user authorize one gate, a range, or all current todo gates as a batch.
- Require the agent to inspect the batch and propose which gates need human
  checkpoints before execution begins.
- Require the user to confirm the gate range and checkpoint map once.
- Allow passed non-checkpoint gates to close and advance automatically under
  that confirmed delegation.
- Preserve gate evidence, ordered execution, progress reporting, and bounded
  stopping behavior throughout the batch.
- Stop for failed dependencies, blockers, scope changes, consequential actions,
  or decisions outside the approved batch.

## Non-goals

- Let the agent silently choose its own authority or checkpoint policy.
- Skip acceptance criteria, evidence, gate records, or safety boundaries.
- Treat approval of one batch as standing authorization for later gates.
- Release, version bump, or push.

## Completed work

- [x] Confirmed the desired multi-gate and selective-checkpoint behavior with
  the human.
- [x] Created this gate record and execution plan.
- [x] Updated the canonical skill and detailed method.
- [x] Updated durable project policy and user documentation.
- [x] Synchronized and validated installed artifacts.
- [x] Ran behavioral, skill, and project checks.
- [x] Prepared the work for a signed-off commit.

## Remaining work

- [ ] Obtain review under this gate's current checkpoint requirement.

## Acceptance criteria

- A request such as “complete all todo gates” produces an ordered batch proposal
  and checkpoint map for user confirmation before execution.
- The skill gives concrete criteria for checkpoint-required and automatically
  completable gates without claiming authority the user did not grant.
- Passed non-checkpoint gates close and advance automatically; checkpoint gates
  pause for review.
- Failed, blocked, out-of-scope, or consequentially changed work stops or is
  handled only within a user-confirmed policy.
- Every gate still records criteria, fresh evidence, review policy, and outcome.
- Both skill copies validate and match; `make check` and `git diff --check` pass.

## Evidence

- Scenario review confirmed that “all todo gates” requires an ordered batch and
  checkpoint-map proposal before execution.
- Scenario review confirmed that passed delegated gates close and advance,
  while passed checkpoint gates stop for review.
- Failure-path review confirmed that invalid dependencies, blockers, new scope,
  permissions, risks, and consequential effects stop automatic advancement.
- Both canonical and installed skills passed `quick_validate.py`.
- `diff -qr skills/hdae-development .hdae/skills/hdae-development` passed.
- `cmp -s install.sh .hdae/install.sh` passed.
- `make check` passed syntax, ShellCheck, and installer integration tests.
- `git diff --check` passed.
- Forward, reverse, coverage, and orphan review found no missing requirement,
  out-of-scope rule, relevant uncovered surface, or abandoned decision.

## Review policy and outcome

Checkpoint required. The human approved implementation and technical passage is
recorded; final review remains pending.

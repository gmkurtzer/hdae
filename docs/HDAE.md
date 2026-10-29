# HDAE Project State

## Intent and constraints

HDAE packages portable agent skills and a POSIX-shell installer for Codex and
Claude Code. Installer changes must preserve existing copy, link, update, and
uninstall workflows; protect locally modified skills; avoid partial state for
known validation failures; and remain portable across the documented SHA-256
tools.

## Completed gate: installer correctness

Status: accepted

The approved maintenance gate resolves four reviewed defects:

- reject the incompatible `--update --link` combination before mutation;
- validate every requested discovery path before installing payloads or links;
- make tree digests independent of SHA-256 utility output formatting; and
- include symlink paths and targets in modification detection.

Acceptance requires regression tests for each failure, existing installer
coverage, ShellCheck, and `make check`. Documentation and the installed HDAE
copy must match the canonical installer. Version bumps, releases, pushes, and
unrelated installer redesign are excluded.

## Checkpoint

The four defects were reproduced against v0.1.1 and are now covered by the
installer integration test. The canonical and installed copies of `install.sh`
match. Fresh evidence:

- `make check` passed syntax validation, ShellCheck, and all installer tests;
- `cmp -s install.sh .hdae/install.sh` passed; and
- `git diff --check` passed.

No acceptance criteria remain open. The human accepted the gate.

## Goal: simple default installation

Make the primary user workflow a one-command curl-to-shell installation from
`main`, while retaining the pinned release workflow for reproducibility.

## Completed gate: curl-to-shell installation

Status: accepted

Outcome: a user can run the documented curl command from a clean project and
receive a complete copy installation for Codex and Claude Code.

Scope:

- explicitly detect and support installer execution from standard input;
- make the curl command the primary README workflow;
- retain clone, pinned, manual-copy, update, and development-link workflows;
- test the exact pipe-to-shell behavior against a local source repository; and
- synchronize the installed entry point.

Non-goals: release, version bump, push, package signing, or unrelated installer
changes.

Task list:

- [x] Add explicit standard-input execution behavior.
- [x] Add a clean-project integration test and installed-entry-point reinstall.
- [x] Update user documentation and reproducibility guidance.
- [x] Synchronize the installed copy and run all acceptance checks.
- [x] Prepare the signed-off gate commit and stop for human acceptance.

Acceptance evidence: `make check`, the pipe-to-shell integration test,
canonical/installed comparison, `git diff --check`, and a clean committed
working tree.

Fresh evidence: `make check`, `cmp -s install.sh .hdae/install.sh`, and
`git diff --check` passed. The integration suite verified standard-input
installation into a clean Git project, ignored a decoy target `skills/`
directory, created both agents' discovery links, and reinstalled through the
copied entry point. No technical acceptance criteria remain open.

The human accepted the gate.

## Goal: clear and scalable HDAE execution

Make every HDAE plan understandable before work begins, preserve complete
goals, gates, tasks, and evidence across long projects, and give users honest
duration expectations and clean completion reports.

## Active gate: HDAE workflow refinement

Status: passed

Outcome: HDAE scales from a concise small-task plan to a durable long-project
system without losing scope, work, decisions, or evidence.

Scope:

- require a plan discussion before execution and plain-language gates;
- require goals, ordered plans, task states, dependencies, and checkpoints for
  long projects;
- add goal-to-evidence traceability, scope-change records, and forward, reverse,
  coverage, and orphan audits;
- communicate execution-loop scope, checkpoints, and evidence-based ETA ranges
  or explicit uncertainty;
- distinguish technical passage from human acceptance;
- require clean completion summaries and relevant source/copy reconciliation;
- require productive autonomous cycles, materially changed retries, and
  highest-information in-scope alternatives;
- stop and escalate with a durable checkpoint when progress, authority, or
  proportional resource use no longer supports another cycle;
- validate and synchronize the packaged skill.

Non-goals: prescribe large planning artifacts for small tasks, guarantee exact
completion times, change skill invocation policy, release, or push.

Task list:

- [x] Add proportional pre-work plan and duration communication.
- [x] Add durable long-project planning and traceability.
- [x] Add completeness audits and explicit scope-change control.
- [x] Strengthen gate templates, execution checkpoints, and completion reports.
- [x] Validate and synchronize the skill package.
- [x] Run repository checks and prepare the commit for human acceptance.
- [x] Define when autonomous execution continues and prohibit unchanged retries.
- [x] Define materially different alternatives and information-seeking actions.
- [x] Define bounded stopping conditions and the escalation report.
- [x] Revalidate and synchronize the convergence amendment.
- [x] Prepare the convergence amendment for a signed-off commit.

Acceptance requires skill validation, canonical/installed file comparison,
`make check`, `git diff --check`, a clean committed working tree, and a final
summary that clearly distinguishes passed from accepted.

Fresh evidence: the skill validator passed for both canonical and installed
copies; `diff -qr` confirmed those copies match; `make check` passed syntax,
ShellCheck, and the full installer integration suite; and `git diff --check`
passed. The forward, reverse, coverage, and orphan review found no unmapped
Gate 2 requirement, task, or acceptance criterion. The convergence amendment
also passed validation for both skill copies, canonical/installed comparison,
the full repository check suite, and `git diff --check`. No technical acceptance
criteria remain open; human acceptance is still required.

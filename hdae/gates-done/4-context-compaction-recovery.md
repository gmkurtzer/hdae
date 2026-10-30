# Context-compaction recovery

## Goal

Reload the complete HDAE workflow and durable project state after compaction,
reset, resume, or handoff without requiring the human to notice the transition.

## Approved scope

- Install a bounded recovery block in `AGENTS.md` for Codex copy installations.
- Preserve unrelated user instructions and track installer ownership.
- Require skill, reference, repository-instruction, and checkpoint reload.
- Record the active skill path and reload requirement in durable checkpoints.
- Test install, reinstall, conflict, preservation, and uninstall behavior.

## Non-goals

- Platform-level compaction hooks.
- Claude-specific project-instruction mutation.
- Release, version bump, or push.

## Completed work

- [x] Added the installer-managed recovery bootstrap.
- [x] Added the skill and method recovery protocol.
- [x] Added ownership, conflict, preservation, and uninstall regression tests.
- [x] Documented copy-installation behavior and link/manual limitations.
- [x] Synchronized installed artifacts and passed all technical checks.

## Remaining work

None.

## Acceptance evidence

- Both skill copies passed the skill validator and matched with `diff -qr`.
- Canonical and installed installers matched with `cmp -s`.
- `make check` and `git diff --check` passed.
- The suite covered user-owned and installer-owned recovery blocks.
- Implementation commit: `b055910 Recover HDAE after context compaction`.
- Fresh batch verification passed both skill validators, canonical/installed
  skill and installer comparisons, the full installer integration suite,
  `git diff --check`, and commit-presence checks.

## Review policy and outcome

Closed under the confirmed Gates 3–6 batch delegation after fresh verification.

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

## Active gate: curl-to-shell installation

Status: passed

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

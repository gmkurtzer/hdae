# HDAE Project State

## Intent and constraints

HDAE packages portable agent skills and a POSIX-shell installer for Codex and
Claude Code. Installer changes must preserve existing copy, link, update, and
uninstall workflows; protect locally modified skills; avoid partial state for
known validation failures; and remain portable across the documented SHA-256
tools.

## Active gate: installer correctness

Status: passed

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

No acceptance criteria remain open. The next action is human review of this
passed gate before any release or additional work.

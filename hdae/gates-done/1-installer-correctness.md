# Installer correctness

## Goal

Make copy, link, update, and uninstall behavior safe and deterministic across
supported environments.

## Approved scope

- Reject incompatible `--update --link` usage before mutation.
- Validate all requested discovery paths before installing state.
- Normalize tree digests across supported SHA-256 utilities.
- Include symlink paths and targets in modification detection.

## Non-goals

- Release or version changes.
- Unrelated installer redesign.

## Completed work

- [x] Reproduced all four installer defects against v0.1.1.
- [x] Added regression coverage for every defect.
- [x] Corrected validation order, digest normalization, and symlink hashing.
- [x] Synchronized the installed entry point.
- [x] Recorded human acceptance.

## Remaining work

None.

## Acceptance evidence

- `make check` passed shell syntax, ShellCheck, and installer integration tests.
- `cmp -s install.sh .hdae/install.sh` passed.
- `git diff --check` passed.
- Implementation commit: `f3e676a Fix installer validation and digests`.

## Human review

The human accepted this gate after reviewing the delivered fixes and evidence.

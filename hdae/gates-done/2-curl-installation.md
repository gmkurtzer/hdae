# Curl-to-shell installation

## Goal

Make a curl-to-shell command the primary installation workflow while retaining
a reproducible pinned alternative.

## Approved scope

- Detect and support execution from standard input.
- Make the curl command the primary README workflow.
- Preserve clone, pinned, manual-copy, update, and development-link workflows.
- Test the exact standard-input behavior against a local source repository.

## Non-goals

- Release, version bump, push, package signing, or unrelated installer changes.

## Completed work

- [x] Added explicit standard-input execution behavior.
- [x] Added a clean-project pipe-to-shell integration test.
- [x] Verified reinstall through the copied entry point.
- [x] Updated documentation and reproducibility guidance.
- [x] Recorded human acceptance.

## Remaining work

None.

## Acceptance evidence

- `make check` passed.
- `cmp -s install.sh .hdae/install.sh` passed.
- `git diff --check` passed.
- The integration suite ignored a decoy target `skills/` directory and created
  both agents' discovery links.
- Implementation commit: `88bbea1 Make curl the default installation path`.

## Human review

The human accepted this gate after reviewing the workflow and evidence.

# External curl-to-shell updates

## Goal

Keep the installer outside installed projects and update copied HDAE skills by
running the current `main` installer through a shell pipe.

## Approved scope

- Stop copying or refreshing `install.sh` inside `.hdae/` for copy installs.
- Remove a legacy self-copy only when an older installer manifest identifies
  the `.hdae/` tree as installer-managed.
- Mark new manifests so later installs preserve an unrelated user-created
  `.hdae/install.sh`.
- Replace `--update` and `--version` usage with clear curl-to-shell guidance.
- Teach the HDAE skill to update from GitHub `main`, preserve the configured
  project target, ensure every supported agent discovery link, reload the
  updated skill in context, and avoid Python or the obsolete installed entry
  point.
- Update documentation and installer integration tests.
- Remove this repository's obsolete installed self-copy.

## Non-goals

- Remove `install.sh` from a development checkout linked through `.hdae/`.
- Add Python or another runtime dependency.
- Add discovery paths for agents other than Codex and Claude Code.
- Change gate semantics or release versions.
- Release, tag, or push.

## Completed work

- [x] Confirmed the desired external update workflow with the human.
- [x] Reproduced the current self-copy and installed-updater documentation.
- [x] Established a passing baseline with `make check`.
- [x] Changed installer ownership and legacy migration behavior.
- [x] Added the skill-directed curl-to-shell update procedure.
- [x] Updated README commands and explanations.
- [x] Added regression coverage for install, migration, preservation, update,
  and uninstall behavior.
- [x] Made every install/update repair Codex and Claude Code discovery links.
- [x] Made the updating agent reload the updated skill and required references.
- [x] Synchronized installed artifacts and ran all technical checks.
- [x] Prepared the work for a signed-off commit.

## Remaining work

- [ ] Obtain human checkpoint review.

## Acceptance criteria

- Fresh and repeated copy installs never create `.hdae/install.sh`.
- A curl-to-shell reinstall from `main` updates managed skills without executing
  or replacing an installed script.
- Migration removes the obsolete self-copy from an old managed installation;
  new manifests preserve later user-created files at that path.
- Deprecated `--update` and `--version` invocations fail before mutation and
  explain the shell-pipe replacement.
- Every accepted agent selector ensures Codex and Claude Code both discover the
  same `.hdae/skills` copies, and reinstall repairs a missing managed link.
- The HDAE skill contains the exact update workflow, immediately reloads the
  updated skill and required references, and does not require Python.
- Development-link and uninstall behavior remain correct.
- Canonical and installed skills validate and match; `make check` and
  `git diff --check` pass.

## Evidence

- Baseline confirmed `.hdae/install.sh`, self-copy code, and installed-updater
  documentation were present; the pre-change `make check` passed.
- Fresh and repeated copy-install tests confirmed no installer self-copy.
- A local `main` shell-pipe fixture installed, changed its source skill, reran,
  and updated the managed skill without an installed entry point.
- Migration testing removed a legacy manifest-owned self-copy and wrote
  `installer_copy=0`.
- Preservation testing kept a pre-existing user file at `.hdae/install.sh`
  unchanged across install, reinstall, and uninstall.
- Deprecated `--update` and `--version` tests failed before target mutation and
  returned the curl-to-shell guidance.
- Development-link, conflict, checksum, recovery-block, modified-copy, and
  uninstall regression coverage passed.
- Selector compatibility tests proved `--codex` and `--claude` both create all
  supported links, and reinstall repaired a deliberately removed managed link.
- This turn reloaded the complete installed skill and required method reference
  immediately after synchronization.
- The bundled `quick_validate.py` could not start because PyYAML is unavailable;
  dependency-free Ruby YAML parsing validated all canonical and installed skill
  frontmatter, and the skill trees matched with `diff -qr`.
- This repository migrated successfully: `.hdae/install.sh` is absent and its
  manifest records `installer_copy=0`.
- `make check` and `git diff --check` passed after synchronization.
- Forward, reverse, coverage, and orphan review found no missing requirement,
  unrelated change, uncovered relevant path, or abandoned decision.

## Delivery strategy

- Working branch: current `main` branch.
- Intended base: not applicable.
- Pull request: not intended.
- Planned commits: external-installer ownership; universal discovery-link
  repair; HDAE reload and update-check guidance; final evidence and gate state.
- Actual commits: `ae3010e` externalized installer updates; `2dca8fa` added
  universal supported-agent links; `add9478` added reload and update workflows;
  final evidence is recorded by this gate file's containing commit.

## Review policy and outcome

Checkpoint required because this changes installer ownership and migration
behavior. Implementation is approved and technical passage is recorded; human
review remains pending.

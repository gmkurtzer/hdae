# Make installation copy-only

## Goal

Keep HDAE installation simple: copy managed skills into `.hdae/skills`, never
place `install.sh` under `.hdae/`, and remove development-link mode and obsolete
installer-copy metadata.

## Approved scope

- Remove the `--link` installation mode and its implementation.
- Remove `installer_copy` from manifests, code, documentation, and tests.
- Remove an obsolete `.hdae/install.sh` when migrating a copy installation.
- Keep direct execution of `install.sh` from any separate source checkout in
  normal copy mode.
- Update README, HDAE skill instructions, architecture, and integration tests.
- Synchronize canonical and installed skill copies.

## Non-goals

- Add another installation mode or runtime dependency.
- Preserve a complete HDAE source checkout under `.hdae/`.
- Change gate semantics, agent discovery paths, or publishing behavior.
- Push changes.

## Completed work

- [x] Confirmed copy-only installation and removal of development-link mode.
- [x] Confirmed current `main` branch with no pull request.
- [x] Establish a passing baseline and inventory affected behavior.
- [x] Remove link mode and installer-copy metadata.
- [x] Update documentation, skills, and tests.
- [x] Synchronize installed skills and run complete verification.

## Remaining work

- [x] Complete implementation and technical evidence.
- [ ] Obtain human checkpoint review.

## Acceptance criteria

- `install.sh` supports copy installation, update-by-reinstall, and uninstall,
  but no `--link` mode.
- New manifests contain no `installer_copy` field.
- A copy install removes an obsolete `.hdae/install.sh` and never creates one.
- Running `install.sh` directly from a separate checkout still copy-installs
  both skills and all supported discovery links.
- README and HDAE skills describe only the copy-based workflow.
- README provides both shell and natural-language agent installation commands.
- Installer regression tests, skill validation, canonical/installed comparison,
  `make check`, and `git diff --check` pass.

## Evidence

- Baseline `make check`: passed before implementation.
- Copy-only installer regression suite: passed after implementation.
- `--link` now fails before changing the target.
- Direct execution from a separate checkout installs copied skills without
  creating `.hdae/install.sh`.
- `diff -qr skills .hdae/skills`: passed; canonical and installed skills match.
- Discovery-link and manifest inspection: passed; both agent roots resolve to
  `.hdae/skills`, `.hdae/install.sh` is absent, and the manifest has no obsolete
  ownership field.
- Skill frontmatter validation: passed with Ruby's YAML parser. The standard
  `quick_validate.py` could not start because its runtime lacks PyYAML; it made
  no changes.
- Final `make check`: passed shell syntax, ShellCheck, and installer integration
  tests.
- Final `git diff --check`: passed.
- README agent-install prompt: added and verified alongside the shell command.
- Coverage: installation, rejection of removed mode, legacy migration, update,
  uninstall, agent discovery, documentation, and skill synchronization passed;
  security, privacy, performance, and deployment changes were not applicable.

## Decisions and limitations

- `.hdae/` is managed installation data, not a source checkout.
- A legacy `.hdae/install.sh` is obsolete and may be removed during migration;
  no ownership marker is needed.

## Delivery strategy

- Working branch: current `main` branch.
- Intended base: not applicable.
- Pull request: not intended.
- Planned commits: copy-only installer and regression tests; documentation,
  synchronized skills, and final gate evidence.
- Actual commits: `0a7816d` (copy-only installer and regression tests);
  `70e9626` (documentation, synchronized skills, and final evidence); this
  commit (natural-language agent installation prompt).

## Review policy and outcome

Checkpoint review because this removes a supported installation mode and
changes migration behavior. Gate 11 has technically passed; human review is
pending.

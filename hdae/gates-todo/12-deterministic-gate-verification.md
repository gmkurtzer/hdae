# Require deterministic gate verification

## Goal

Make deterministic, automated verification the default when HDAE gates are
created, while clearly documenting the few criteria that require subjective or
external evidence.

## Approved scope

- Require each acceptance criterion to identify an automated test, command, or
  reproducible procedure and its expected result.
- Require an explicit reason and the most objective available evidence when a
  criterion cannot be verified deterministically.
- Add a `Verification plan` section to the gate template.
- Prevent human review from replacing checks that can reasonably be automated.
- Update and synchronize the canonical and installed HDAE skill copies.

## Non-goals

- Require every product decision or qualitative outcome to become automated.
- Retrofit or rewrite completed historical gates.
- Add a gate-schema validator or new runtime dependency.
- Push changes.

## Completed work

- [x] Reviewed current HDAE requirements and historical gate evidence.
- [x] Confirmed current `main` branch with no pull request.
- [x] Add explicit deterministic-verification requirements.
- [x] Synchronize and validate the installed skill.

## Remaining work

- [x] Complete implementation and technical evidence.
- [ ] Obtain human checkpoint review.

## Acceptance criteria

- Gate creation explicitly maximizes deterministic automated verification.
- Every criterion must map to a command, test, or reproducible procedure with
  an expected result.
- Non-deterministic criteria must record why, the most objective available
  evidence, and whether human judgment is required.
- Human review cannot substitute for reasonable automated verification.
- The gate template contains a separate `Verification plan` section.
- Canonical and installed skills validate and match; `make check` and
  `git diff --check` pass.

## Verification plan

- Inspect the canonical skill and method reference for all required rules and
  the updated gate template.
- Parse canonical and installed skill frontmatter successfully.
- `diff -qr skills .hdae/skills` -> exit status 0.
- `make check` -> exit status 0.
- `git diff --check` -> exit status 0.
- Human checkpoint -> confirm that the new wording is clear and proportional.

## Evidence

- Current rules already require executable, falsifiable, positive, negative,
  regression, and fresh evidence, but do not explicitly require deterministic
  verification planning when a gate is created.
- Historical implementation gates generally use deterministic commands; some
  process and documentation gates use scenario or human review without always
  recording why automation is impractical.
- Rule inspection confirmed that gate creation and revision now require a
  criterion-by-criterion verification plan with expected results, deterministic
  checks where practical, and explicit exceptions otherwise.
- The architecture invariants now require deterministic planned verification
  where practical and documented objective exceptions.
- The gate template now contains a separate `Verification plan` section.
- Ruby YAML parsing validated canonical and installed skill frontmatter. The
  bundled validator remains unavailable because its runtime lacks PyYAML.
- `diff -qr skills .hdae/skills`: passed.
- `make check`: passed shell syntax, ShellCheck, and installer integration tests.
- `git diff --check`: passed.

## Decisions and limitations

- “Deterministic” means the same controlled inputs and environment should
  produce an objectively checkable result; external systems and subjective
  product review must be identified rather than disguised as deterministic.
- Proportionality still applies: a reproducible inspection may be sufficient
  when an automated test would add no meaningful confidence.

## Delivery strategy

- Working branch: current `main` branch.
- Intended base: not applicable.
- Pull request: not intended.
- Planned commits: deterministic gate-planning rules, synchronized skill, and
  final evidence.
- Actual commits: this commit (deterministic verification rules, synchronized
  skill, and final evidence).

## Review policy and outcome

Checkpoint review because this changes how every future gate is specified.
Gate 12 has technically passed; human review is pending.

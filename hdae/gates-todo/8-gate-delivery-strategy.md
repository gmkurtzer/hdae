# Gate delivery strategy

## Goal

Make branch intent and commit structure explicit before every gate is
implemented.

## Approved scope

- Ask whether each new gate uses the current branch or a dedicated PR branch.
- Store the branch, PR, planned-commit, and actual-commit decisions in the gate.
- Require multiple coherent commits for large, independently reviewable work.
- Update the HDAE skill, method reference, and project planning rules.

## Non-goals

- Automatically create, push, or publish a branch or pull request.
- Force artificial commit counts for tightly coupled work.
- Rewrite historical gate files or commits.

## Completed work

- [x] Confirmed current `main` without a pull request for Gates 7, 8, and 9.
- [x] Added delivery-strategy instructions and the gate template fields.
- [x] Validated and synchronized the installed skill copy.

## Remaining work

- [ ] Record final commit identifiers and checkpoint evidence.

## Acceptance criteria

- A new gate requires a recorded current-branch or dedicated-branch decision.
- Dedicated-branch gates record intended base branch and PR intent.
- Large gates plan multiple coherent commits and record actual commits or
  deviations without requiring artificial splits.
- Branch selection never implies permission to push or open a PR.
- Canonical and installed skills validate and match.

## Evidence

- Canonical and installed skill trees matched with `diff -qr`.
- Dependency-free Ruby YAML parsing validated required frontmatter for every
  canonical and installed skill; the bundled validator could not start because
  its optional PyYAML dependency is unavailable.
- Manual reconciliation confirmed the skill and method reference require branch
  choice, PR intent, planned commits, actual commits, and no implied publish
  authority.

## Decisions and limitations

- The human selected the existing `main` branch and no PR for Gates 7–9.
- “Large” is based on independently reviewable changes, components, migrations,
  or risks rather than a line-count threshold.

## Delivery strategy

- Working branch: current `main` branch.
- Intended base: not applicable.
- Pull request: not intended.
- Planned commits: installer/link refinement; HDAE delivery and update-check
  workflows; final evidence and gate records.
- Actual commits: pending.

## Review policy and outcome

Checkpoint review with Gates 7 and 9 because this changes the HDAE process the
human will inspect before pushing.

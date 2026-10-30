# Check HDAE for updates

## Goal

Let an agent determine whether an installed HDAE copy differs from GitHub
`main` without changing the project.

## Approved scope

- Recognize a natural-language request to check HDAE for updates.
- Fetch upstream `main` into a temporary location and compare skill content.
- Report whether updates exist and distinguish likely upstream changes from
  local managed-copy modifications using manifest and repository evidence.
- Keep checking separate from the existing explicit update workflow.
- Document development-link checking without mutating the checkout.

## Non-goals

- Add a persistent updater or checker inside `.hdae/`.
- Install an update as part of a check.
- Add Python, background polling, release publication, or push behavior.

## Completed work

- [x] Confirmed a natural-language, read-only update check with the human.
- [x] Added the update-check workflow to the HDAE skill.
- [x] Validated and synchronized the installed skill copy.

## Remaining work

- [ ] Run the local upstream-comparison fixture and record final evidence.

## Acceptance criteria

- “Check HDAE for updates” compares installed skills with GitHub `main` in a
  temporary location and makes no project changes.
- The report identifies equal or differing content and summarizes changed
  paths without automatically updating.
- Local changes are not mislabeled as upstream updates without checking the
  manifest and repository diff.
- Development-link checking does not fetch into or change that checkout.
- Canonical and installed skills validate and match.

## Evidence

- Not run yet.

## Decisions and limitations

- The command is an HDAE natural-language workflow, not a new installed shell
  script.
- Network access and Git are required to inspect GitHub `main`.

## Delivery strategy

- Working branch: current `main` branch.
- Intended base: not applicable.
- Pull request: not intended.
- Planned commits: HDAE delivery and update-check workflows; final evidence and
  gate records.
- Actual commits: pending.

## Review policy and outcome

Checkpoint review with Gates 7 and 8 before the human pushes and performs the
live upstream check.

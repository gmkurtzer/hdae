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
- [x] Ran the workflow against GitHub `main` after the human pushed.

## Remaining work

- [ ] Obtain human checkpoint review.

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

- A local `main` clone compared equal to `.hdae/skills` with `diff` status `0`.
- Checking out pre-refinement commit `ae3010e` in the temporary clone produced
  `diff` status `1` and named the changed skill and method paths.
- `git status --porcelain` was identical before and after the fixture, proving
  the project was not changed.
- After the push, the live check cloned GitHub `main` at `b2771f7`, returned
  `diff` status `0`, and left `git status --porcelain` unchanged.

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
- Actual commits: `add9478` added the workflow; final local evidence is recorded
  by this gate file's containing commit.

## Review policy and outcome

Checkpoint review with Gates 7 and 8 before the human pushes and performs the
live upstream check. Local and live technical behavior passed; human review
remains pending.

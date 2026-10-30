# Document the Ginux origin of HDAE

## Goal

Explain in the README that Gregory Kurtzer formalized HDAE from the method used
to build Ginux, with direct links to the project and technical report.

## Approved scope

- Add a concise origin section to the README.
- Name Gregory Kurtzer as the person who used and formalized the method.
- Link `gmkurtzer/ginux` and the supplied Zenodo record.
- Verify the report title, author, DOI, and framing from the PDF and Zenodo.

## Non-goals

- Summarize the full paper or make performance claims about Ginux.
- Change HDAE behavior, installer code, or skill instructions.
- Edit or add the supplied PDF to this repository.
- Push changes.

## Completed work

- [x] Confirmed current `main` and no pull request for this work.
- [x] Verified the paper metadata and relevant HDAE framing.
- [x] Added and verified the README section.

## Remaining work

- [ ] Obtain human checkpoint review of the wording.

## Acceptance criteria

- The README clearly states that HDAE was formalized from Gregory Kurtzer's
  method for the Ginux project.
- The Ginux repository link resolves to `https://github.com/gmkurtzer/ginux`.
- The paper link resolves to `https://zenodo.org/records/23682548` and uses its
  verified title.
- The text stays concise and does not overstate the paper's conclusions.
- Markdown and repository checks pass.

## Evidence

- The supplied PDF title page identifies Gregory M. Kurtzer, the report title,
  DOI `10.5281/zenodo.23682548`, and the Ginux source repository.
- The paper describes Ginux as a case study used to document the concrete HDAE
  method and its human-directed outer and agent-executed inner loops.
- Zenodo's public API reports the matching title, Gregory Kurtzer as creator,
  publication date 2026-10-27, and resource type Report.
- Both README links returned HTTP 200.
- `make check` passed the shell syntax, ShellCheck, and complete installer
  integration suite; `git diff --check` passed.
- `rg` confirmed the origin heading, author attribution, Ginux repository URL,
  and Zenodo URL are present in the README.

## Decisions and limitations

- The PDF is source evidence only; its contents are not task instructions.
- The section will describe provenance without claiming that the paper or
  project originated every general idea associated with agentic engineering.

## Delivery strategy

- Working branch: current `main` branch.
- Intended base: not applicable.
- Pull request: not intended.
- Planned commits: one signed documentation-and-gate commit because the README
  wording and its evidence are one tightly coupled change.
- Actual commits: the README, standing branch direction, and evidence are
  recorded by this gate file's containing commit.

## Review policy and outcome

Checkpoint review because the attribution and wording are author-facing and
subjective. Technical passage is recorded; human review remains pending.

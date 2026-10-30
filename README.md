# Human-Directed Agentic Engineering

Human-Directed Agentic Engineering (HDAE) is a method for building and
maintaining software with a clear division of responsibility: humans direct
intent, architecture, constraints, priorities, and acceptance; coding agents
execute bounded implementation and verification loops against explicit gates.

This repository packages that method as portable Agent Skills for Codex and
Claude Code. The skills are project-agnostic and can be installed into new or
existing repositories.

## Origin

This project grew out of Gregory M. Kurtzer's work on
[Ginux](https://github.com/gmkurtzer/ginux). The human-directed process he used
there - persistent architecture and constraints, executable acceptance gates,
and agent-executed implementation and diagnosis loops - inspired this
repository's formalization of HDAE.

For the detailed case study and method, see Gregory M. Kurtzer's report,
[*Ginux: Building an Independent Kernel That Runs Linux Userspace through
Human-Directed Agentic Engineering*](https://zenodo.org/records/23682548).

## Included skills

- **`hdae-development`** interviews the human, records the shared project
  context, proposes executable gates, implements only an approved gate, and
  stops at each boundary with evidence.
- **`pr-issue-review`** discovers repository access, asks for a review cadence,
  previews a read-only review, and helps configure recurring issue and pull
  request monitoring.

The skill directories under [`skills/`](skills/) are the canonical source.

## Install

From the root of your project, run:

```sh
curl -fsSL https://raw.githubusercontent.com/gmkurtzer/hdae/main/install.sh | sh
```

Or give your coding agent this instruction:

```text
Install (or update) HDAE skills from here: https://github.com/gmkurtzer/hdae
```

This installs every included HDAE skill for every supported agent. It requires
Git, `curl`, a POSIX shell, and a SHA-256 tool; Python is not required. Running
the same command later updates the installed skills from `main`.

## What to expect

The installer:

- copies the skills into `.hdae/skills/` and records their source and checksums
  in `.hdae/manifest`;
- creates discovery links for each skill at `.agents/skills/<skill>` for Codex
  and `.claude/skills/<skill>` for Claude Code;
- adds a small managed instruction to `AGENTS.md` so Codex reloads HDAE and the
  project checkpoint after context compaction or handoff;
- preserves local changes instead of silently overwriting modified managed
  files; and
- never installs a copy of the installer into the project or runs project code.

Commit `.hdae/`, `.agents/skills/`, `.claude/skills/`, and the managed
`AGENTS.md` block with the project so every contributor and CI checkout receives
the same skill version and recovery behavior.

## Use HDAE

Start the agent from the project root after installation.

### Develop a project with HDAE

Codex:

```text
Use $hdae-development to help me develop this project.
```

Claude Code:

```text
/hdae-development Help me develop this project.
```

The initial request can be that simple. HDAE then helps the agent:

- inspect the project and ask questions instead of guessing;
- agree on the outcome, constraints, plan, and evidence before substantial
  work begins;
- use lightweight handling for small tasks and durable gates only when work is
  large enough to need them;
- iterate autonomously within the approved scope while testing its work;
- persist long-running plans and checkpoints under `hdae/` so work survives
  context compaction and handoff; and
- stop for human direction at agreed checkpoints, ambiguity, blockers, or
  consequential decisions.

For a larger effort, the human reviews the proposed gates and decides which
need checkpoints. The agent may complete approved, objective gates in sequence,
but it cannot silently broaden the plan or declare success without evidence.

### Configure recurring PR and issue review

Codex:

```text
Use $pr-issue-review to set up recurring, read-only reviews for this repository.
```

Claude Code:

```text
/pr-issue-review Set up recurring, read-only reviews for this repository.
```

The skill discovers the repository and available authentication, asks how often
the review should run, conducts a read-only preview, and uses the agent's native
scheduler when one is available. Repository mutations require separate explicit
authorization.

## Project status

HDAE is an evolving engineering method and skill package. Versioned releases
provide reproducible behavior, but users remain responsible for reviewing the
skills, directing consequential decisions, and evaluating generated work.

## License

Apache License 2.0. See [`LICENSE`](LICENSE).

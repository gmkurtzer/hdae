# Human-Directed Agentic Engineering

Human-Directed Agentic Engineering (HDAE) is a method for building and
maintaining software with a clear division of responsibility: humans direct
intent, architecture, constraints, priorities, and acceptance; coding agents
execute bounded implementation and verification loops against explicit gates.

This repository packages that method as portable Agent Skills for Codex and
Claude Code. The skills are project-agnostic and can be installed into new or
existing repositories.

## Included skills

- **`hdae-development`** interviews the human, records the shared project
  context, proposes executable gates, implements only an approved gate, and
  stops at each boundary with evidence.
- **`pr-issue-review`** discovers repository access, asks for a review cadence,
  previews a read-only review, and helps configure recurring issue and pull
  request monitoring.

The skill directories under [`skills/`](skills/) are the canonical source.

## Requirements

Installation uses a POSIX shell and these common tools:

- `git`
- `curl` for the recommended installation command
- `cp`, `find`, `sort`, and `tar`
- `sha256sum`, `shasum`, or `openssl` for SHA-256 checksums

Python is not required.

## Install into another project

### Recommended: install the latest version

From the root of the project that should use HDAE:

```sh
curl -fsSL https://raw.githubusercontent.com/gmkurtzer/hdae/main/install.sh | sh
```

The downloaded installer fetches HDAE from `main`, installs both skills into
the current project, and configures discovery for Codex and Claude Code. To
select only one agent or another target, pass installer arguments through
`sh -s --`, for example:

```sh
curl -fsSL https://raw.githubusercontent.com/gmkurtzer/hdae/main/install.sh | \
    sh -s -- --codex --copy --target /path/to/project
```

The installer copies the canonical skills into `.hdae/skills/`, records their
source and checksum in `.hdae/manifest`, and creates Git-compatible relative
discovery links:

```text
.agents/skills/<name> -> ../../.hdae/skills/<name>  # Codex
.claude/skills/<name> -> ../../.hdae/skills/<name>  # Claude Code
```

For Codex copy installations, the installer also appends a short,
installer-managed recovery block to the project's `AGENTS.md`. It tells Codex
to reload the complete HDAE skill and durable project checkpoint after context
compaction, reset, resume, or handoff. Existing instructions remain in place;
ambiguous, duplicate, or locally modified managed markers stop the installer
instead of being overwritten. Uninstall removes only a block owned by HDAE.

Commit `.hdae/`, `.agents/skills/`, `.claude/skills/`, and the managed
`AGENTS.md` block with the project so every contributor and CI checkout receives
the same skill version and recovery behavior.

### Reproducible pinned installation

To inspect and pin the exact release before running it:

```sh
git clone --depth 1 --branch v0.1.1 https://github.com/gmkurtzer/hdae.git .hdae-source
./.hdae-source/install.sh --all --copy
rm -rf .hdae-source
```

The curl command tracks `main`; use this pinned workflow when reproducibility
or source review is more important than automatically selecting the latest
version.

### Interactive installation

Clone HDAE anywhere, enter the target project, and run its installer:

```sh
git clone https://github.com/gmkurtzer/hdae.git /tmp/hdae
cd /path/to/project
/tmp/hdae/install.sh
```

The installer asks whether to configure Codex, Claude Code, or both. It does
not overwrite an existing installation unless its recorded checksum still
matches or `--force` is explicitly supplied.

### Development link

To track or modify HDAE from within a project, clone it directly into `.hdae`
and link the agents to that checkout:

```sh
git clone https://github.com/gmkurtzer/hdae.git .hdae
./.hdae/install.sh --all --link
```

This mode preserves the HDAE Git checkout. It is best for contributing to HDAE,
while copy mode is better for reproducible project use.

### Copy without the installer

A skill is a complete directory. To install one skill manually for Codex:

```sh
mkdir -p .agents/skills
cp -R /path/to/hdae/skills/hdae-development .agents/skills/
```

For Claude Code:

```sh
mkdir -p .claude/skills
cp -R /path/to/hdae/skills/hdae-development .claude/skills/
```

Copy the complete directory, including `SKILL.md`, `agents/`, and
`references/`. Repeat with `pr-issue-review` if that workflow is wanted.

## Installer commands

```text
./install.sh                         Interactive copy installation
./install.sh --all --copy            Install for Codex and Claude Code
./install.sh --codex --copy          Install for Codex only
./install.sh --claude --copy         Install for Claude Code only
./install.sh --all --link            Link to this HDAE checkout
./install.sh --target /path/project  Select the target repository
./install.sh --update --version TAG  Fetch and install a tagged version
./install.sh --uninstall             Remove an installer-managed copy
```

`--update` downloads from `https://github.com/gmkurtzer/hdae.git`. Local
changes are detected using the recorded skill checksum and block replacement
unless `--force` is supplied. Checksums include regular-file content and
symlink targets and are portable across the supported SHA-256 tools. Link mode
always uses the current checkout, so `--link` cannot be combined with `--update`
or `--version`. The managed `AGENTS.md` recovery block is installed only for
Codex copy installations; development-link and manual-copy users should add an
equivalent repository instruction when compaction recovery is required. The
installer never runs project code.

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

The initial request can be that simple. The skill directs the agent to inspect
the project, interview the human until the outcome and constraints are clear,
persist the shared understanding, propose complete gates, and ask which gate is
approved. Implementation stops at every gate boundary for human evaluation.

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

## Updating

From an installed project:

```sh
./.hdae/install.sh --update --version v0.2.0 --all
```

Review the skill changes like any other dependency update before committing
them. For an installation cloned directly into `.hdae`, update the checkout
with Git and rerun `./.hdae/install.sh --all --link`.

## Project status

HDAE is an evolving engineering method and skill package. Versioned releases
provide reproducible behavior, but users remain responsible for reviewing the
skills, directing consequential decisions, and evaluating generated work.

## License

Apache License 2.0. See [`LICENSE`](LICENSE).

# HDAE Project

## Intent

HDAE packages portable agent skills and a POSIX-shell installer for Codex and
Claude Code. It gives humans control over intent, architecture, priorities, and
acceptance while agents execute bounded implementation and verification loops.

## Users and outcomes

- Project owners can establish and evolve software through explicit gates.
- Agents can recover durable scope, evidence, and next actions without relying
  on chat history.
- Contributors can inspect what remains, what was accepted, and what was
  deliberately deferred directly from the repository.

## Scope

- The `hdae-development` and `pr-issue-review` skills.
- Portable copy and development-link installation.
- Durable project-control records under `hdae/`.
- Repeatable verification and human acceptance boundaries.

## Non-goals

- Replacing human product or architecture decisions.
- Treating technical verification as human acceptance.
- Hiding project state in chat, generated indexes, or external services.
- Automatically publishing releases or pushing repository changes.

# HDAE Status

- Active skill: `hdae-development`
- Skill path: `.agents/skills/hdae-development/SKILL.md`
- Reload after context shift: required
- Active gate: `hdae/gates-todo/11-copy-only-installer.md`
- Current state: Gate 11 copy-only installer and regression tests pass;
  documentation and synchronized skill updates remain
- Last evidence: Gate 9 matched live GitHub `main` at `b2771f7` without project
  mutation; Gate 10's source metadata, links, README text, `make check`, and
  `git diff --check` all passed
- Open decisions or limitations: use current `main` for new work until directed
  otherwise; `.hdae/` will no longer support a source checkout
- Exact next action: commit installer behavior, update docs and skills,
  synchronize the installed copy, and run final verification

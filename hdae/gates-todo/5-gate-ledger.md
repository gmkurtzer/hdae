# Filesystem gate ledger

## Goal

Make completed, remaining, and deferred HDAE work directly visible in the
repository without duplicate indexes or ordering metadata.

## Approved scope

- Establish root-level project-control files under `hdae/`.
- Store gates in `gates-todo`, `gates-done`, and `gates-deferred`.
- Encode lifecycle in the directory and execution position in a decimal filename
  prefix.
- Teach agents the exact portable shell commands for ordered discovery.
- Preserve one gate file as its tasks, evidence, decisions, and review record.
- Migrate the four historical gates and remove the duplicate combined ledger.
- Synchronize and validate the packaged HDAE skill.

## Non-goals

- Add an HDAE CLI or generated gate indexes.
- Duplicate path-derived lifecycle or ordering fields inside gate files.
- Release, version bump, or push.

## Completed work

- [x] Confirmed directory names and lifecycle semantics with the human.
- [x] Confirmed decimal filename ordering and shell-based discovery.
- [x] Created the project-control structure and Gate 5 record.
- [x] Migrated the four historical gate records.
- [x] Defined next-integer discovery across all lifecycle directories, including
  an empty todo directory.
- [x] Updated the canonical skill and method reference.
- [x] Removed the superseded combined project ledger.
- [x] Synchronized and validated installed artifacts.
- [x] Verified ordered discovery, migration completeness, and project checks.
- [x] Prepared the work for a signed-off commit.

## Remaining work

- [ ] Obtain human acceptance.

## Acceptance criteria

- Each historical gate has exactly one authoritative record.
- Numeric shell sorting returns gates in execution order across lifecycle
  directories; the next-gate command returns the earliest todo gate.
- Next-integer discovery uses all lifecycle directories and returns `1` for an
  empty ledger or the integer after the greatest existing position otherwise.
- The skill requires gate records and correctly defines todo, done, and deferred
  transitions without duplicate indexes.
- Both skill copies validate and match; `make check` and `git diff --check` pass.
- The repository is clean after a signed-off commit.

## Evidence

- Ordered discovery returned Gates 1 through 5 in numeric order; the earliest
  todo command returned Gate 3.
- The append-number procedure returned `6` for this ledger and `1` for an empty
  temporary ledger.
- A temporary `1`, `1.5`, `2` ledger sorted in that exact order.
- Five historical/current records produced five unique numeric positions, and
  no legacy `docs/HDAE.md` or `docs/hdae/` ledger remained.
- Both canonical and installed skills passed `quick_validate.py`.
- `diff -qr skills/hdae-development .hdae/skills/hdae-development` passed.
- `cmp -s install.sh .hdae/install.sh` passed.
- `make check` and `git diff --check` passed.
- Forward, reverse, coverage, and orphan review found no unmapped requirement,
  out-of-scope change, omitted relevant surface, or abandoned decision.

## Human review

The human approved implementation of this gate. Technical passage is recorded;
human acceptance remains pending.

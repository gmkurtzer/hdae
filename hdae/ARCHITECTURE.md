# HDAE Architecture

## Canonical and installed artifacts

- `skills/` contains the canonical skill sources.
- `.hdae/skills/` contains installer-managed copies.
- `.agents/skills/` and `.claude/skills/` expose discovery links.
- `install.sh` is canonical; `.hdae/install.sh` is its installed copy.

Canonical and installed copies must be reconciled before a gate passes.

## Project-control state

The root `hdae/` directory is authoritative project state. It is separate from
the installer-managed `.hdae/` directory.

- `PROJECT.md` owns intent, outcomes, scope, and non-goals.
- `ARCHITECTURE.md` owns boundaries and invariants.
- `PLAN.md` owns planning conventions and cross-gate strategy.
- `STATUS.md` owns the resumable checkpoint.
- `gates-todo/`, `gates-done/`, and `gates-deferred/` own gate lifecycle.

The gate path is metadata: its directory is lifecycle state, its leading decimal
is execution position, and its remaining filename is the gate name. Gate files
must not duplicate those facts in identifiers, ordering fields, or gate indexes.

## Invariants

- Only human acceptance moves a gate into `gates-done/`.
- A technically passed gate remains in `gates-todo/` while acceptance is pending.
- Deferral records a reason and a condition for reconsideration.
- Decimal positions are unique and unnecessary trailing zeros are forbidden.
- Every acceptance criterion has fresh evidence before technical passage.
- Installer changes preserve user content and avoid known partial-state failures.

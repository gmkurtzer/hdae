# HDAE Architecture

## Canonical and installed artifacts

- `skills/` contains the canonical skill sources.
- `.hdae/skills/` contains installer-managed copies.
- `.agents/skills/` and `.claude/skills/` expose discovery links.
- Every install or update ensures both supported discovery roots link to the
  same canonical skill copies; selector flags are compatibility aliases only.
- `install.sh` is the external canonical installer and is never copied into a
  managed project installation.

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

- A gate moves into `gates-done/` only after it passes and is either accepted at
  a checkpoint or automatically closed under a user-confirmed batch policy.
- Before a batch begins, the human confirms its gate range and checkpoint map.
- Automatic completion authority applies only to the confirmed batch.
- Deferral records a reason and a condition for reconsideration.
- Decimal positions are unique and unnecessary trailing zeros are forbidden.
- Every acceptance criterion has fresh evidence before technical passage.
- Blockers, failed dependencies, scope changes, and consequential decisions stop
  automatic advancement unless the confirmed policy explicitly covers them.
- Installer changes preserve user content and avoid known partial-state failures.
- Copy-install updates run the current canonical installer from outside the
  target, normally through the documented GitHub `main` shell pipe.

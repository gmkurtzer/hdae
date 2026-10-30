# HDAE Plan

## Planning model

The numerically sorted gate files are the execution plan. New gates receive the
next integer position or a decimal midpoint when inserted between existing
gates. Existing gates are never renumbered merely to make space.

Each gate contains its own scope, tasks, criteria, evidence, decisions, and
remaining work. This file records only project-wide planning rules and strategy;
it does not duplicate the gate list or lifecycle state.

## Current strategy

1. Keep installation portable, reversible, and safe for existing projects.
2. Keep HDAE instructions concise while preserving detailed method guidance in
   references.
3. Persist enough project and gate state for reliable recovery after context
   compaction, reset, resume, or handoff.
4. Require fresh technical evidence and separate human acceptance for every
   gate.

## Scope changes

Material changes belong in the affected gate and require human approval before
implementation. Project-wide changes also update the appropriate authoritative
file in `hdae/`.

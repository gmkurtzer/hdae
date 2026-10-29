# Human-Directed Agentic Engineering Method

Use this reference to design HDAE for projects of any size, whether new or
already established.

## Division of responsibility

The human provides:

- the problem worth solving and the intended user outcome;
- domain knowledge and important real-world constraints;
- architectural direction, trust boundaries, and product tradeoffs;
- priorities, non-goals, and acceptable risk;
- acceptance of completed gates and direction for the next gate.

The agent provides:

- repository and implementation analysis;
- draft product, architecture, plan, and gate artifacts;
- implementation inside an approved boundary;
- automated builds, tests, experiments, diagnosis, and iteration;
- evidence, limitations, alternatives, and surfaced decisions.

Shared work includes Q&A, architecture refinement, gate definition, review of
observed behavior, and deciding what evidence is sufficient. Agent proposals do
not become architecture merely because they are plausible; human preferences do
not make a gate pass without evidence.

## Iterative discovery

The initial prompt may contain only an idea. The agent is responsible for
turning that idea into a reviewable brief through conversation and repository
inspection.

Ask questions in small rounds. Begin with the outcome, users, and motivation;
then follow the answers into constraints, non-goals, architecture, compatibility,
operations, risks, and evidence. Continue until remaining uncertainty is either
resolved or explicitly recorded as an open decision. Summarize the complete
understanding and obtain correction or confirmation before planning gates.

Do not present a long questionnaire when adaptive follow-up would produce better
answers. Do not fill gaps with plausible assumptions simply to reach coding
faster.

## Minimal artifact model

Use existing repository conventions. Keep these responsibilities distinct when
the project needs them, but do not create documents for ceremony:

- **Product intent:** users, outcomes, scope, non-goals, and success.
- **Architecture:** components, boundaries, invariants, trust, and decisions.
- **Plan:** milestones, dependencies, and order.
- **Gate:** one bounded unit of authorized work and its acceptance criteria.
- **Task:** one trackable action mapped to an approved gate and criterion.
- **Evidence:** commands, environment, observations, failures, and status.
- **Decision record:** a durable explanation for consequential choices.

Link to authoritative material rather than duplicating it.

## Scale planning to the work

Every task needs a plan discussion before execution, but not every task needs a
large planning system. For a small, bounded change, a concise outcome, scope,
verification, and stop point may be sufficient. For a long project, persist:

- explicit goals and non-goals;
- an ordered gate map with dependencies;
- a task list with pending, active, blocked, and completed states;
- acceptance criteria and required evidence;
- progress checkpoints, risks, decisions, and scope changes; and
- the current next action.

Before starting a long execution loop, tell the human what will run, its scope,
and when progress will be reported. Give an ETA range and confidence only when
there is enough evidence. Otherwise state the uncertainty and the checkpoint
that should make an estimate possible. Revise estimates when observations
invalidate them.

## Traceability and completeness for long projects

Use stable identifiers when they reduce ambiguity. Maintain the relationship:

```text
Goal -> Gate -> Acceptance criterion -> Task -> Evidence
```

Every goal must be covered by one or more gates. Every acceptance criterion
must have planned work and fresh evidence. Every task must belong to an approved
gate and criterion; new tasks that expand scope require a gate update and human
approval. Record removed or changed scope with its reason instead of silently
deleting it.

At planning and completion boundaries, perform four checks:

1. **Forward:** every goal reaches acceptance criteria, tasks, and evidence.
2. **Reverse:** every task and change maps to approved scope.
3. **Coverage:** every relevant functional, failure, regression, user,
   documentation, compatibility, operational, and security surface is included
   or explicitly not applicable.
4. **Orphan:** no goal, criterion, task, decision, failure, or open question is
   left unmapped or silently dropped.

## Durable context and continuation

Chat context is temporary. The repository must contain enough authoritative
state for a new agent or later session to resume safely.

Prefer existing product, architecture, planning, decision, and status files. If
none exist, use one compact `docs/HDAE.md` for small work or propose a split
under `docs/hdae/` for substantial work:

- `PROJECT.md`: intent, users, outcomes, scope, and non-goals;
- `ARCHITECTURE.md`: boundaries, invariants, constraints, and decisions;
- `PLAN.md`: milestone and gate ledger with acceptance criteria;
- `STATUS.md`: current gate, last verified evidence, limitations, open
  questions, required decisions, and next action.

Keep one source of truth for each fact. Link evidence and decision records rather
than copying them into every file.

At session start, reload repository instructions and the authoritative HDAE
state. Before a context shift, handoff, or gate stop, update `STATUS.md` or its
equivalent. It must answer:

1. What outcome and invariants govern the work?
2. Which gate is active and what is its exact status?
3. What changed and what evidence actually ran?
4. What remains incomplete, failed, blocked, or unverified?
5. Which human decision or exact next action is required?

Persisted state never overrides a newer explicit human decision. Reconcile the
difference and update the record.

## Gate quality

A useful gate is:

- **Observable:** success appears in behavior or a meaningful artifact.
- **Executable:** verification names concrete commands or procedures.
- **Falsifiable:** negative cases can prove the work wrong.
- **Bounded:** it can finish and be reviewed independently.
- **Regressive:** earlier capabilities are rechecked.
- **Evidence-bearing:** another person can see what ran and what happened.
- **Decision-aware:** unresolved human choices are surfaced before coding.

Avoid gates such as “improve quality,” “finish compatibility,” or “make it
secure.” Replace them with specific properties and limitations.

## Human gate-alignment conversation

The agent must make the proposed work visible enough for the human to find
omissions before implementation. Use this sequence:

1. summarize the intended outcome and constraints;
2. ask focused questions whose answers could change architecture, scope, or
   acceptance;
3. present the complete proposed gate map and dependencies;
4. show the coverage review below;
5. ask what is missing or incorrectly scoped; and
6. ask which specific gate is approved to begin.

The coverage review considers each relevant surface:

- functional behavior and failure paths;
- automated tests, regression checks, and required evidence;
- user workflows, interfaces, and discoverability;
- documentation and examples;
- compatibility, migration, persistence, and rollback;
- deployment, monitoring, maintenance, and recovery; and
- performance, security, privacy, and other nonfunctional constraints.

Not every project needs a gate for every surface. The agent must either include
the relevant work or state why it is not applicable. This is a completeness
check, not permission to expand the user's goal.

At gate completion, repeat the coverage review against the approved scope and
show evidence for every acceptance criterion. Missing or unverified work keeps
the gate partial.

## Gate template

```markdown
## Gate: <observable outcome>

Status: proposed | approved | in progress | passed | failed | blocked

### Goal
<Plain-language user or project outcome this gate advances.>

### Purpose
<User, product, architectural, or risk reason.>

### Scope
- <Authorized work>

### Dependencies
- <Required prior gate, input, or decision>

### Non-goals
- <Deferred or prohibited work>

### Deliverables
- <Code, tests, documentation, or behavior>

### Acceptance criteria
- <Positive behavior>
- <Negative or failure behavior>
- <Regression behavior>

### Evidence
- `<command or procedure>` -> <required observation>

### Task list
- [ ] <Task mapped to an acceptance criterion; include for substantial work>

### Stop
Stop for human review before beginning <dependent work>.
```

## Closed-loop execution

The outer human loop is:

```text
intent -> architecture and constraints -> gate -> observed evidence
       -> human review and direction -> next gate
```

The inner agent loop is:

```text
implement -> build/run -> observe -> diagnose -> revise -> verify
```

The agent may repeat the inner loop without hand-holding while it remains inside
the approved gate. It returns to the outer loop when the gate passes, a human
decision is required, or continued iteration would weaken scope or evidence.

## Convergence and stall control

An autonomous cycle is productive only when its next action remains inside the
approved gate and has a credible chance of producing measurable progress or new
evidence. Use this decision loop:

```text
observe -> form a hypothesis -> choose the highest-information in-scope action
        -> run it -> compare the result -> record the evidence and next action
```

Do not repeat an unchanged attempt. A retry must deliberately change at least
one hypothesis, input, implementation, environment, or diagnostic, with a
reason that the change could alter the result. When the current approach stalls,
retain its evidence and try a materially different in-scope alternative. Prefer
the action that is most likely to discriminate between explanations or remove a
known blocker, rather than the action that merely consumes more work.

Stop the inner loop and return to the human when any of these conditions holds:

- a required decision, credential, permission, or external dependency is
  missing;
- the remaining alternatives would expand approved scope, risk, authority, or
  consequential external effects;
- repeated materially different cycles yield no new evidence or measurable
  progress;
- the expected time or token cost is disproportionate to the gate's value or
  remaining uncertainty;
- no credible in-scope alternative remains; or
- the gate has passed and reached its human-review boundary.

Difficulty, an initial failure, or an uncertain diagnosis is not by itself a
reason to stop. Exhaust sensible bounded alternatives first. At escalation,
persist the current checkpoint and report what was attempted, what each result
showed, which alternatives remain, why the loop stopped, and the recommended
human decision or next action. Resume from that checkpoint after direction; do
not silently cross the gate boundary or broaden the plan.

## Completion language

- **Passed:** all mandatory criteria ran and succeeded.
- **Accepted:** the human reviewed and accepted a passed gate.
- **Failed:** at least one mandatory criterion ran and failed.
- **Blocked:** an external dependency or required decision prevents execution.
- **Not run:** verification has not occurred.
- **Partial:** useful progress exists, but the gate remains open.

Time spent, code volume, or near-success does not complete a gate.

At a gate boundary, report the gate and status first, then delivered work,
evidence, coverage, repository or artifact state, incomplete or unverified
items, and the exact decision or next action required from the human. Passing a
gate never silently authorizes the next one.

---
name: vertical-slice
description: >
  Break a feature, system change, migration, or technical initiative into
  incremental vertical slices using the Hamburger Method. Use when the user
  asks to "/vertical-slice" a change or wants an implementation plan broken into
  vertical slices. Starts by collaboratively modelling the change's complexity
  dimensions and variants from the current and target states, then derives
  thin end-to-end slices from the agreed complexity model.
disable-model-invocation: true
---

# Vertical Slice

Use this skill when the user wants to break a feature, system change, migration, or technical initiative into small vertical slices.

The goal is **not to immediately produce an implementation plan**.

First build an explicit **Complexity Model** of the change together with the user. Once that model has been challenged, refined, and accepted, derive an incremental vertical-slice implementation plan from it.

## Core idea

Large features are difficult to slice because they contain multiple independent dimensions of complexity.

Instead of decomposing the system horizontally by component or architectural layer, identify those dimensions and the variants or progression within each dimension.

Then construct slices by selecting a deliberately small combination of variants across the relevant dimensions.

Each slice should represent a thin but coherent path through the system.

Think:

> model the complexity first; slice the complexity second.

---

# Inputs

The skill needs enough information to understand two states:

## Current State

How the system behaves and is implemented today.

This may come from:

* the user's description
* source code
* existing documentation
* architecture documents
* previous implementation plans
* repository exploration

Do not require a formal Current State document if the information can be obtained from the available context.

## Target State

What should be true once the change is fully implemented.

This may come from:

* a PRD
* a technical design
* a Tech Spec
* requirements
* acceptance criteria
* architecture documents
* the user's description

A PRD or Tech Spec is therefore an input to the method, not the Complexity Model itself.

If either Current State or Target State is too unclear to meaningfully model the change, investigate the available sources or ask the user before proceeding.

---

# Process

The method has two distinct phases:

1. Complexity Modelling
2. Vertical Slicing

Do not collapse them into a single step.

The Complexity Model is a first-class artifact and must be discussed with the user before producing the final slicing plan.

---

# Phase 1 — Complexity Modelling

## 1. Understand the delta

Compare the Current State with the Target State.

Focus on the **change surface** rather than exhaustively modelling the whole system.

Ask:

> What needs to become possible, different, more robust, or more sophisticated for the Current State to become the Target State?

Use this delta to discover complexity dimensions.

---

## 2. Identify complexity dimensions

A complexity dimension is an independent axis along which the solution can become broader, more sophisticated, or handle additional cases.

Examples:

* one → many
* manual → automated
* happy path → rejection → technical failure
* stand-in → sandbox → real provider
* synchronous → asynchronous
* single actor → multiple actors
* single delivery → duplicate/out-of-order delivery
* one data variant → several variants
* logs → operational visibility
* simple permissions → multiple roles
* single resource → bulk operation

These are examples, not a predefined taxonomy.

Discover the dimensions from the actual problem.

### Components are not automatically dimensions

Do not mistake architectural decomposition for complexity modelling.

These are usually **not** useful complexity dimensions by themselves:

* database
* backend
* frontend
* API
* domain
* infrastructure

They describe where implementation happens, not how the behaviour grows.

A valid dimension should describe meaningful variation or progression in the behaviour, constraints, integration, operational characteristics, or scope of the change.

---

## 3. Identify variants and progressions

For each dimension, identify its relevant variants.

Whenever possible, determine whether the variants have a natural incremental progression.

For example:

```text
Provider
StandIn → Real provider

Volume
One → Many

Outcome
Success → Rejection → Technical failure

Automation
Manual → Assisted → Automatic
```

Prefer expressing variants as a progression when there is a meaningful order in which complexity can be introduced.

Do not invent intermediate variants merely to create more slices.

---

## 4. Produce the initial Complexity Model

Present the model explicitly.

Prefer a compact table such as:

| Dimension | Progression / Variants     | Why it matters                             |
| --------- | -------------------------- | ------------------------------------------ |
| Provider  | StandIn → Sumsub           | Introduces external integration complexity |
| Outcome   | Success → Rejected → Error | Produces different state transitions       |
| Execution | Sync → Async               | Requires suspended/resumed processing      |
| Delivery  | Once → Duplicate           | Introduces idempotency concerns            |

The exact representation may change when another format communicates the model better.

The important property is that the user can inspect and modify the model directly.

---

# Grill the Complexity Model

Do **not** immediately proceed from the first plausible Complexity Model to slicing.

The modelling conversation is the most important part of the method.

Actively challenge the model with the user.

Look for:

* missing dimensions
* dimensions that are actually two independent dimensions
* dimensions that should be merged
* variants that produce materially different behaviour
* variants that are irrelevant to the requested change
* accidental architectural layers disguised as dimensions
* assumptions hidden in the PRD or technical design
* unspecified behaviour
* unnecessary complexity
* dimensions whose progression is ordered incorrectly
* complexity that can be deliberately postponed
* complexity that belongs outside the scope of the feature

Ask **specific, high-value questions**, not generic questions such as:

> Does this look good?

Prefer questions such as:

> I'm treating provider rejection and provider failure as variants of Outcome, but they lead to different recovery behaviour. Should Recovery be a separate dimension?

or:

> The design mentions retries but doesn't specify whether they are automatic or operator-triggered. That distinction affects the slicing. Which behaviour do we actually want?

or:

> Admin visibility appears in the target design but isn't required for the customer flow to complete. Should it be part of this change or treated as a separate capability?

Do not interrogate the user about every dimension mechanically.

Focus the grilling on decisions that could materially change the resulting slices.

When several questions are independent and easy to answer together, batch them. When an answer may substantially reshape the model, resolve it before drilling deeper.

Update the Complexity Model as the conversation progresses.

---

# Complexity Model checkpoint

Do not generate the implementation slices while important disagreements or ambiguities remain in the Complexity Model.

Once the model appears stable, present the refined model clearly.

Proceed to slicing when the user indicates that the model is sufficiently correct.

The goal is not mathematical completeness.

The goal is a model that captures enough of the important complexity of the change to make good slicing decisions.

---

# Phase 2 — Vertical Slicing

Once the Complexity Model is stable, derive an implementation sequence from it.

## 1. Find the thinnest useful path

Start by looking for the smallest coherent combination of variants that can produce:

* observable end-to-end behaviour, or
* meaningful technical/product learning.

Prefer depth before breadth.

Given:

```text
A: A1 → A2 → A3
B: B1 → B2
C: C1 → C2 → C3
D: D1 → D2
```

prefer starting approximately with:

```text
A1 + B1 + C1 + D1
```

rather than implementing:

```text
A1 + A2 + A3
```

while leaving the other relevant dimensions untouched.

Not every dimension must necessarily appear in the first slice. Some complexity can remain entirely absent until needed.

---

## 2. Expand incrementally

Each subsequent slice should introduce the smallest useful amount of additional complexity.

Conceptually:

```text
S1 ⊂ S2 ⊂ S3 ... ⊂ Target State
```

Each slice expands the set of behaviours or situations supported by the system.

Prefer expanding one or a small number of dimensions at a time when that produces a coherent increment.

Do not mechanically generate one slice per variant or one slice per dimension.

The dimensions are a reasoning tool, not a template.

---

# Slice quality rules

Every slice should:

* be end-to-end where reasonably possible
* produce observable behaviour or meaningful learning
* leave the system in a coherent state
* introduce the minimum useful additional complexity
* be independently implementable and verifiable
* move the Current State materially toward the Target State

A slice should normally be describable as a capability:

> Given X, the system can now Y.

Good:

> An order requiring PoA can successfully complete a real Sumsub verification and continue its assessment.

Bad:

> Implement Sumsub client.

Bad:

> Create PoA database tables.

Bad:

> Add webhook endpoint.

Those may be tasks **inside** a slice, but they are not vertical slices themselves.

---

# Slice vs Task

Maintain a strong distinction between **slices** and **implementation tasks**.

A slice describes a coherent increment in system capability.

Tasks describe the technical work required to produce that capability.

For example:

```markdown
## Slice — Complete one successful real PoA verification

### Capability

An order requiring PoA can complete a successful verification through Sumsub and resume its assessment.

### Complexity introduced

- Provider: StandIn → Sumsub
- Execution: Sync → Async
- Outcome: Success only

### Implementation

- introduce PoA attempt persistence
- create Sumsub client
- request verification
- receive webhook
- correlate result with attempt
- resume assessment
- add end-to-end tests

### Verification

A test order can enter PoA-required state, complete Sumsub verification, receive the callback, and continue assessment successfully.

### Dependencies

None.
```

Do not turn implementation tasks into sibling slices.

---

# Avoid horizontal slicing

Reject plans whose sequence resembles:

```text
Slice 1 — Database
Slice 2 — Backend
Slice 3 — API
Slice 4 — Frontend
```

Also be suspicious of subtler horizontal slicing such as:

```text
Slice 1 — Implement all provider integration
Slice 2 — Implement all error handling
Slice 3 — Implement all observability
```

when a thinner combination across those concerns could produce a useful end-to-end capability earlier.

Infrastructure, migrations, APIs, UI, domain logic, integrations, and tests may all appear inside the same slice when necessary to deliver its capability.

---

# Avoid fake vertical slices

A slice is not good merely because it touches several architectural layers.

Do not create artificial end-to-end increments whose only purpose is satisfying the definition of "vertical."

Each slice should represent a meaningful increase in supported behaviour or learning.

---

# Prefer postponing complexity

Do not ask:

> How can we implement every requirement in smaller tasks?

Ask:

> What complexity can we avoid supporting yet while still having a coherent working system?

Good slicing often comes from deliberately postponing:

* additional actors
* additional outcomes
* automation
* scale
* concurrency
* recovery
* operational tooling
* rare edge cases
* generalized abstractions

until an earlier slice proves the simpler path.

---

# Ordering slices

Do not order slices only by apparent implementation dependency.

Prefer an order that optimizes for:

1. earliest end-to-end validation
2. reduction of important uncertainty
3. postponement of unnecessary complexity
4. coherent working states
5. small increments

When an external integration or architectural assumption represents significant uncertainty, an early slice may prioritize learning even if it delivers little user-visible value.

Make that rationale explicit.

Favor independent slices whenever possible: slices that do not depend on other slices can be implemented and verified in any order, or in parallel. When a dependency is unavoidable, keep it explicit and minimal rather than accepting broad coupling between slices for convenience.

---

# Output

The final output is an **Implementation Plan**, separate from the Target State / PRD / Tech Spec.

Recommended structure:

```markdown
# Implementation Plan

## Context

Briefly describe the Current State and Target State relevant to this plan.

## Complexity Model

[final agreed model]

## Slicing Strategy

Briefly explain the chosen thin path and why the slices are ordered this way.

## Slice 1 — <capability>

### Capability
What becomes possible after this slice.

### Complexity covered
Which variants/progressions this slice introduces.

### Implementation
Likely technical work involved.

### Verification
How we know the slice works.

### Dependencies
Which other slices, if any, must be completed before this one. State "None" when the slice is independent.

## Slice 2 — <capability>

...

## Target State Coverage

Show that the final sequence covers the relevant Target State and identify anything deliberately left out of scope.
```

The Implementation Plan is an execution artifact.

The PRD / Tech Spec / Target State documentation remains the description of the desired final system.

Do not unnecessarily rewrite the target-state document into the implementation plan.

---

# Behaviour when invoked

When first invoked:

1. inspect the available Current State and Target State information
2. investigate available sources when useful
3. identify the change surface
4. propose an initial Complexity Model
5. grill the model with the user

Do **not** rush to produce slices in the first response unless the user explicitly asks to skip the collaborative modelling phase or the model has already been established.

The highest-value outcome of the first interaction is usually a better understanding of the problem's dimensions, not an implementation plan.

---

# Guiding principle

When the slicing becomes difficult, do not immediately manipulate the slices.

Return to the Complexity Model.

Bad slices are often evidence that the dimensions or variants have been modelled poorly.

**Model complexity first. Slice complexity second.**

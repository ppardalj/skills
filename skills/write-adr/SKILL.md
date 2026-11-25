---
name: write-adr
description: "Decides whether a decision deserves an Architecture Decision Record (ADR), then writes or reviews it in the repo's own ADR folder and format. Use when a plan or change takes a decision that is costly to reverse, sets a repo-wide rule, or contradicts an accepted ADR; when asked whether something deserves an ADR; or when asked to write or review one."
---

# Write an ADR

An ADR records **what was decided and why**, and it is **normative**: while it is `accepted`,
code and agents follow its Decision, until a later ADR supersedes it. The rules a decision sets
live in its Decision and nowhere else; AGENTS.md and CLAUDE.md files point at the ADRs. A
`proposed` ADR binds nobody. Only the user accepts one.

This skill has three branches. **Admit** returns a verdict. **Write** produces a `proposed` ADR.
**Review** checks an existing ADR against its code and the checks below. Every branch starts
with steps 1 and 2.

## The repo's convention

Location, filename pattern, file format, status vocabulary, date format and language are the
repo's. Take each one from the first source that settles it:

1. What the repo states: CLAUDE.md, AGENTS.md, its docs, the ADR folder's README or template,
   `.adr-dir`.
2. What its existing ADRs do (`docs/adr`, `docs/adrs`, `docs/decisions`, or one such folder per
   app or module): the most recent ones, where they differ.
3. The defaults here: `docs/adrs/NNN-<slug>.md` (three digits), the [template](#template), the
   language of the repo's docs. Create the folder with its first ADR.

The repo's convention wins over the template here and over the ADR format of any other skill.
Existing ADRs keep their location, number and format.

The next number is the highest in the folder plus one, padded as its neighbours. The slug comes
from the title. With several ADR folders, the one whose scope covers the whole decision owns it.
A decision that spans repos goes where the repo's docs say; when they don't, ask the user.

This skill names ADR parts by their meaning. Map each to the repo's format:

- **Status**: the front matter field, the `Status:` line or the text under `## Status`. Write
  `proposed`, `accepted`, `deprecated` and `superseded by <the new ADR>` with the repo's words and
  shape: where the neighbours read `Accepted — 2031-05-04`, write `Proposed — 2031-06-10`. A
  format with nowhere for it gets a `Status: proposed` line under the title, in the new ADR only;
  its ADRs without status count as accepted.
- **Date**: the day the current status was set, where the repo writes it (its own field, or
  beside the status).
- **Summary**: the summary field; without one, the title plus the Decision's first sentence.
- **Other sections**: the repo's equivalent. Content the format has no section for goes in the
  closest one it has (alternatives in the Context or the Decision, related links where the text
  uses them).

## Admission test

A decision deserves an ADR when either of these holds:

- **All three**: it is **costly to reverse**, it would **surprise** a reader of the code who
  lacks its context, and it settled a **real trade-off** between viable options.
- It sets a **rule for a whole repo**, or for several, whose why the code does not show
  (example: every outgoing email goes through the outbox table, never straight to the provider).

Otherwise it belongs somewhere else. Name that place in the verdict, as the repo has it:

| What it is | Where it goes |
|---|---|
| Business rule, eligibility, domain invariant | The domain doc (`CONTEXT.md`, glossary or similar) and a test |
| Feature behaviour, rollout, migration steps | The tech spec, or the tracker issue |
| Design local to one module | The code, its tests, the module's docs |
| Naming or formatting without a non-obvious why | The conventions doc, a linter |
| Operational procedure | A runbook |
| How agents work | A skill, AGENTS.md or CLAUDE.md |

A business rule can carry an architectural decision. In a library system, "a loan keeps the fee
agreed when it started" is business. That the loan stores its own copy of the fee, instead of
reading it from the price list, is the ADR.

## Steps

### 1. Find the decisions already taken

Settle the [repo's convention](#the-repos-convention). List the decisions with the index script or
doc the repo names; without one, list every ADR folder and read each ADR's title, status and
summary. Read in full every ADR that touches the topic. Then grep the repo's docs (tech specs,
design docs, domain docs) for the topic, under every name the domain uses for it.

Done when you can name the folder, filename, format and status words a new ADR would take, every
ADR and design doc on the topic is read, and you know whether this decision is new, amends an
earlier one, or supersedes an accepted one.

### 2. Give the verdict

Apply the [admission test](#admission-test): **ADR**, or **not an ADR** plus where it goes.

Done when the verdict names the criterion that decided it. On the Admit branch, report it and
stop. On Write, a failing decision is reported the same way and nothing is written. On Review, a
failing ADR becomes a finding that proposes moving its content to the place the table names; go
on with [Review](#review-an-existing-adr).

### 3. Gather the facts (Write)

- The current state, against the code, with `file:line`.
- The evidence that forced the decision: incidents, counts, logs, measurements, each with its
  source.
- The alternatives that were really on the table, the status quo included when it was one, and
  why each one fell.

The facts are your job. The decisions and the intent are the user's: put each open one to them
with AskUserQuestion, recommended option first. For a decision already taken, record the reasons
it was taken for. Inventing a competition between options after the fact distorts the record.

Done when every claim the Context will make has a source, and every rejected alternative has a
reason that comes from the user or from evidence.

### 4. Write it

Fill the repo's format, or the [template](#template) when it has none, and pass every
[check](#checks). Set the status to proposed and the date to today. When the new ADR would
supersede another, say so and link it in the new one; the old one stays accepted until step 5.

Done when the file exists, every check passes, and the index the repo names, if any, lists it.

### 5. Report

Report the path, the summary line and any open questions, then put the next decision to the user:
accept it or not. When the user accepts it, set its status to accepted and its date to the day of
acceptance, and set the status of any ADR it supersedes to superseded, linking the new one. The
superseded body stays as written. Update the index the repo names, if it is kept by hand.

## Review an existing ADR

Read the ADR, then the code it governs: does the code follow each rule in its Decision? Run every
check. Sort the findings:

- **Substance**: a rule the code does not follow; a rule that is really a convention or a
  rollout step; a why that is missing; a decision that a later ADR or spec contradicts. Each
  finding carries its evidence (`file:line`, the doc). Put the change that settles each one to
  the user: amend the decision, supersede it, or move the rule elsewhere. Code that breaks a rule
  the user keeps is reported to the user, with its `file:line`.
- **Form**: departures from the repo's format, title, summary, wording. Apply these directly.

An accepted ADR's Decision changes only with the user's explicit answer, and where the repo treats
accepted ADRs as immutable, only through a new ADR. Record the change in the ADR itself, so the
history stays readable.

Done when every rule in the Decision has been checked against the code and every check run.

## Template

```markdown
---
status: proposed
date: YYYY-MM-DD
summary: <One line: the decision, worded so that an agent reading the index knows whether it applies to its change.>
---

# ADR-NNN: <The fact the decision makes true>

## Context

<The situation that forced the decision: current behaviour with file:line, the evidence with its
source, the constraints. Link the business rule instead of restating it.>

## Decision

<The rules, each one something code or an agent can be held to. Bold the rule, then explain it.
Name its scope: what it governs and what it leaves alone.>

## Alternatives considered

- **<Option>.** <What it would have given, and why it fell.>

## Consequences

### Positive
- <…>

### Negative
- <Costs, limits, meaning that changes, what reversing it would cost.>

## Validation

<Optional. For each rule, the test or check that catches a violation, or "not enforced".>

## Related

- <Business rules, tech spec, superseded or related ADRs, migrations.>
```

Status values: `proposed`, `accepted`, `deprecated`, `superseded by ADR-NNN`.

## Checks

Each check applies to its part wherever the repo's format holds it.

- **Title**: states the fact the decision makes true ("A loan carries its agreed fee"), unless
  the repo titles its ADRs otherwise.
- **One decision**: tightly coupled parts stay together, and unrelated choices go to separate
  ADRs.
- **Summary**: lets an agent decide, without opening the ADR, whether it applies.
- **Context**: every fact traces to a `file:line`, a doc or a query. A missing number is stated
  as unknown.
- **Decision**: rules, not a plan. Rollout steps, class-level mechanics that a refactor would
  change, and dates go to the tech spec or the tracker issue.
- **Alternatives**: viable and materially different, each with the reason it fell.
- **Consequences**: the negative side is as concrete as the positive: who loses what, what
  changes meaning, what reversing it would cost.
- **Validation**, when present: names real tests and checks, and marks every rule nothing
  enforces.
- **Consistency**: compatible with every accepted ADR, or it supersedes the one it contradicts.
- **Status**: `proposed` unless the user accepted it.
- **Convention**: location, number, format, status words, date and language are the repo's.

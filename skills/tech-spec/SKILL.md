---
name: tech-spec
description: "Plan a change and write its tech spec in docs/projects/. Use when asked to plan or design a feature, evaluate a proposed architecture, or write or amend a tech spec."
---

# Tech spec

A tech spec settles the _design_ of one project before it is sliced: what changes, why this
way, what it costs, what stays open. It is written in English and lives at
`docs/projects/<slug>/tech-spec-<slug>.md` until the project ships (see `docs/projects/README.md`
if present).

## Steps

### 1. Find prior art

Grep the topic, under every name the domain uses for it, across:

- `docs/projects/`: every `pending.md`, PRD and other live spec.
- Module- or package-level `docs/` folders: a recorded decision may already rule on it.
- Retired specs: `git log --diff-filter=D --name-only --format='%h %s' -- docs/projects`, then
  `git show <sha>^:<path>`.

Done when every hit is noted with its path and you know whether this is a new spec, an
amendment of a live one, or a slice already planned elsewhere.

### 2. Read the constraints

- The domain-language doc (`CONTEXT.md`, glossary or similar).
- The rules in the repo's architecture docs the design touches: module boundaries, public
  ports, schema ownership, cross-module reactions.
- The `README.md` and `docs/` of every module the change touches, including any API
  contract or auth docs.

Read one or two docs per command: output over ~20KB spills to disk and costs a second read.

Done when every touched module's README is read and every prior decision the design would
reverse is named.

### 3. Map the current state

Establish against the code what the design builds on: the state transitions and who calls
them, where persistence and transactions happen, what triggers the work (webhooks, background
jobs, API endpoints).

For a broad inventory, dispatch Explore subagents in parallel, each with one narrow question
set (one per module or per concern), and wait for their reports; leave the docs you already
read out of their brief. For code you read yourself, take the signatures first
(`grep -nE "public|internal" <file>`) and open the full file only where a body matters.

Done when every claim the spec's Current state will make carries a `file:line`.

### 4. Evaluate and decide with the user

Report in chat:

- the current state that matters to the design;
- the user's proposed approach judged on its merits: what holds, what breaks;
- a refined design;
- the alternatives you reject, each with the reason it falls.

Then put every decision that changes the shape of the design to the user with
AskUserQuestion, recommended option first. Iterate until they confirm the design.

Done when every decision that would change the design is answered; the rest go to Open
questions.

### 5. Write the spec

Fill the skeleton below: drop the sections that don't apply, add the ones the design needs.
Each fact has one home: link to it.

Done when the file exists and passes every check below.

### 6. Report

The path, a three-line summary and the open questions. Offer the implementation plan as the
next step: `implementation-plan.md` beside the spec, sliced the way
an earlier plan from the retired specs found in step 1 is, if any.

## Skeleton

```markdown
# <Title> — Tech Spec

**Status:** draft | accepted | amended | implemented. <date>. <what amended it, if anything>

<Two or three paragraphs: the problem, the constraint that shapes the answer, the answer in
one sentence.>

Read with <links to the docs this spec changes or depends on>.

## 1. Goal                  — the requirement, in the user's terms
## 2. Current state         — verified against code, with file:line
## 3. Design                — the shape first, then one subsection per moving part
## 4. Data                  — tables and migrations, per owning module and schema
## 5. Contracts             — ports, HTTP endpoints, provider and webhook wire changes
## 6. UI / admin            — screens and endpoints, when a UI is touched
## 7. Invariants            — before and after
## 8. Decisions             — what the user decided; prior decisions this spec reverses
## 9. Rejected alternatives — each with the reason it falls
## 10. Risks
## 11. Testing              — which suite covers which risk (per the repo's testing docs)
## 12. Open questions
## 13. Steps                — coarse order; the implementation plan slices it. Last step:
                              retire the spec (docs/projects/README.md), if the repo
                              retires shipped specs.
```

## Checks

- Every module rule the design touches is honoured, or the spec names the rule and argues
  the exception.
- Every prior decision it reverses (a module `docs/` decision, an auth or contract doc, a PRD line) is
  listed under Decisions with a link.
- The cost is counted: files, aggregates, migrations, new libraries.
- Each design choice traces to a requirement in Goal or a Decision.
- Domain terms are spelled as in the domain-language doc.

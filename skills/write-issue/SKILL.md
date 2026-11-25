---
name: write-issue
description: "Writes or rewrites tracker issues (GitHub, YouTrack, Jira...) so anyone reading them understands them: the business description with a concrete example, numbered acceptance criteria, the technical details apart. Use when creating an issue or epic, filing the slices of an implementation plan, or rewriting an issue that is hard to follow."
---

# Write an issue

An issue has **two readers**, and each text serves one of them. The **description** is for anyone
who reads the tracker: stakeholders, support, the user. The **technical details** are for whoever
does the work. Where each lives, the fields, the states and the language are the repo's: read
[issue tracking](issue-tracking.md) first.

Short beats complete. Length follows the size: an S issue fits on one screen, both texts together.
Each fact is said once, in one place, and a section exists only when it has something to say.

## When to write

Create or edit an issue when the user asked for it, or for the work it tracks. Anything else found
while working is a stray finding, and goes where [issue tracking](issue-tracking.md) says. A new
issue enters unrefined, with no priority unless the user gave one; making it ready is
`refine-issue`'s job.

## Steps

### 1. Find the context

Search the tracker for an issue that already carries this; when one does, rewrite it or report it.
Read the parent epic, two or three sibling issues, and the doc the issue comes from (PRD, tech
spec, implementation plan). Match the siblings' shape.

Done when you can name the issue's reader-visible change in one sentence, the epic it belongs to,
if any, the doc section it traces to, if any, and no open issue duplicates it.

### 2. Write the description

In product terms, in this order:

1. **Why**: what is wrong or wanted and who it affects, told through **one concrete example**: a
   named person, real-looking values ("Ana López renews a loan on its last day and is charged the
   late fee"). Two or three sentences; the example carries the abstraction. Invented people and
   values, unless the tracker is private and the real case is the evidence.
2. **What changes**, only when a picture says what the criteria cannot (a screen, a flow, an
   epic's journey): one before and after visual, with the `show-me` skill, limited to what the
   tracker renders.
3. **Acceptance criteria**: a numbered list (AC1, AC2...) of observable behaviours, one line each,
   a situation and its result. Only behaviours that could break: the change itself, the refusal or
   failure case, what must keep working when the change risks it. A criterion true by construction
   is not one. The ones checked in production are marked `(prod)`. The criteria are the issue's
   "done when".

Names users know (screens, buttons, states as the app shows them) belong here. Class names, paths,
endpoints, commands and field names go to the technical details. When the issue's users are
developers (a CLI, an API, a build, the repo's own tooling), the names they type are the names users know.

Done when someone outside engineering, given only the description, can say what changes for whom
and how anyone will know it is done.

### 3. Write the technical details

What the person doing the work needs and cannot get from the linked docs:

- the work: the moving parts and their order, as files or components, not a narrated diff;
- links to the exact sections: plan slice, spec section;
- evidence the starting point needs: the number, the log line, the file;
- **How to verify**: one line per acceptance criterion, `AC1 → <level>: <check>`. The level is a
  test (the behaviour it proves; the implementer names the file), CI, a manual step (who does
  what, where) or a check in production (the command and its expected result);
- rollback, when it is more than reverting the PR.

Done when a developer or agent can start from it, every link resolves, and every acceptance
criterion has a How to verify line.

### 4. Cut

Read both texts once more and delete every sentence, row and section a reader would not miss, and
every fact said twice. Done when an S issue fits on one screen.

### 5. Set fields and links

Set the fields per [issue tracking](issue-tracking.md), and create it unrefined. By kind:

- **Epic**: its description adds a map of the slices (an ASCII or Mermaid dependency diagram with
  the keys) and links to the PRD, spec and plan.
- **Slice of an implementation plan**: one issue per slice, child of the epic, named by the
  slice's capability ("A reader sees why a renewal was refused"), never by a component ("Add
  reason column"). **Depends on** links for the dependencies the plan states, and nothing more.
  Then write each key into the plan, on the slice's `Tracking:` line.
- **Related work**: relates to.

Done when each issue, re-read from the tracker, shows the texts, parent, fields and links you
intended, and every key you created appears in the doc it came from.

### 6. Report

Each issue's key, title and link. When it has a visual, ask the user to confirm it renders: the
API returns only the raw text.

---
name: refine-issue
description: "Refines one tracker issue to the Definition of Ready: investigates code and docs, decides what changes no product behaviour, asks the user only what would change what gets built, splits an oversized issue into sibling slices, and rewrites it with acceptance criteria and How to verify. Use when asked to refine an issue or make it ready to implement."
argument-hint: "<issue>"
---

# Refine an issue

Takes **one** issue that fails the Definition of Ready and leaves it, or the slices it splits
into, ready, with nothing left to guess.

**Investigate over asking, ask over guessing.** A question is worth the user's time only if a
wrong guess changes what gets built: product behaviour, scope or architecture. Everything else you
decide, and record.

Steps 1 to 4 only read; nothing is written to the tracker before the user answers in step 5.
Investigate in the tracker, the docs and the code. What only production would show becomes a step
of the work (a check before the fix), not a question.

## Preconditions

- Read [issue tracking](../write-issue/issue-tracking.md) and settle the repo's tracker, states,
  fields, Definition of Ready, size and priority rules.
- Read [`write-issue`](../write-issue/SKILL.md), which owns how the text is written.
- `git fetch` each repo the issue names, and read the fresh remote branch PRs target, not the
  working tree.

Done when every part the steps use is settled, or is a question for step 5, and the repos are
fetched.

## Steps

### 1. Read the issue

With its comments, parent, linked issues and the siblings that matter. Judge it against each item
of the Definition of Ready: pass or fail, with the reason.

Done when every item has a verdict.

### 2. Investigate

Read the code and docs the issue points at, and check its facts against them: a fact can be stale
(already fixed, a number changed), wrong (the fix would break something else) or missing (a second
hole of the same kind). Each finding carries its evidence: `file:line`, an issue key, a doc
section, a commit. A decision the docs or the user's earlier answers already settle is a finding,
not a question: cite where.

Done when every failing item is resolved by a finding, by a decision of yours, or is a question
for step 5.

### 3. Decide the shape

The issue stays one, or splits into **sibling issues**, never children. Split only when each piece
is still a slice: it delivers value by itself, can be prioritised by itself, and has an observable
result. Split when:

- it is Size L, sized as if step 5's questions were answered with your recommendations;
- its parts deserve different priorities, where the repo has priority rules;
- its parts have different dependencies, or one part unblocks other issues and the rest does not.

The original keeps the part its links and history fit best. A part another open issue carries
leaves this one with a pointer: search the tracker for each piece first. A part nobody needs now leaves it too: an
issue of its own where the repo has a priority for "someday", else a line in the trace, with the
signal that would bring it back. An L that does not split into slices needs a
design first: propose an epic with a `tech-spec`, and it stays unrefined.

Done when each resulting issue has a size, its dependencies and, where the repo has priority
rules, a priority with its reason.

### 4. Draft

Each resulting issue with `write-issue` steps 2 to 4, on the options you recommend in step 5.

Done when each draft passes the Definition of Ready once the questions are answered.

### 5. Ask the user

In the language of the conversation, brief. Per issue:

- the key, a short title, and the verdict in one line (ready, split, smaller than it said, stale);
- two or three findings that bear on the user's decision, one line each;
- the acceptance criteria of each resulting issue, so the answer approves something seen;
- when it splits, a table: issue, what, size, priority, depends on.

Then the questions, with AskUserQuestion (a numbered list where it is absent). Each names the key
**and its title**, so it stands on its own in the dialog, puts the recommended answer first, and
says what each option changes. An issue with no question gets one, asking to apply it as drafted.
The answers approve the criteria and the split shown.
What else you decided goes to the trace, not here.

Done when the user has answered every question. An answer that is itself a question ("wasn't this
fixed already?") is investigated and asked again.

### 6. Apply

Write only what the answers approve, with them folded into the drafts:

1. Re-read the original: when someone changed it since step 1, reconcile first, and ask again if
   the change touches an answer. Rewrite it in place: title, texts, fields.
2. Create each sibling with the original's parent, fields and visibility. Link it **relates to**
   the original, plus **depends on** where the shape says so. Write each new key where the plan or
   doc names the work.
3. Replace the links the shape changed.
4. Move to ready each resulting issue whose Definition of Ready holds. One the tracker rejects
   stays where it was and is reported.
5. On the original, the **trace**: a comment opening with `Refinement applied (<date>)`, then
   **Questions and answers** (as the user gave them), **Findings** (with evidence), **Decided by
   the agent**, and **Split**.

A stale issue (nothing left to do) is closed as discarded only on the user's answer, with the
evidence in the trace.

Done when each issue, re-read from the tracker, shows the intended texts, fields, links and state,
and the trace is on the original.

### 7. Report

One table (key, what, size, priority, state), any failed write, and what the user must do
personally.
To undo: the previous texts and fields are in the issue's history; siblings are closed as
discarded.

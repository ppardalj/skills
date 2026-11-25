---
name: refine-backlog
description: "Refines a batch of tracker issues with refine-issue, with one round of questions for the user. Use when asked to refine the backlog, several issues, or an epic's slices."
argument-hint: "[<count> | <epic>] [except <issue>...]"
---

# Refine the backlog

Runs [`refine-issue`](../refine-issue/SKILL.md) on a batch, so the user answers one round of
questions instead of one per issue. Refinement is pulled, not swept: the backlog needs ready work
for the next couple of weeks, not every issue refined. Batch size bounds both the tokens and the
user's attention. Nothing is written to the tracker before the user answers.

## Steps

### 1. Pick the batch

Settle `refine-issue`'s preconditions, then take the batch from the refinement queue
([issue tracking](../write-issue/issue-tracking.md)):

| Argument | Batch |
|---|---|
| none, or a count | **Loose**: the first N issues of the queue that are neither an epic nor part of one. N defaults to 4 |
| an epic | **Epic**: every unrefined slice of it. Read the epic and the spec or plan it links too |

Drop the issues the user excludes; in loose mode, take the next ones instead.

Done when the batch is listed. An empty one is reported, and the run stops.

### 2. Investigate

**Loose mode.** The issues are unrelated, so each gets a clean context: one `general-purpose`
subagent per issue, all launched in one message, each told to run `refine-issue` steps 1 to 4 on
its key, read-only.

**Epic mode.** The slices share a spec, code and dependencies, so they share one subagent,
read-only, in this order:

1. **Map**: read the epic, its spec and plan, and the text of every slice, before any code. From
   that alone: slices that duplicate, overlap or are made obsolete (merge or close, a question for
   the user), the dependency order, and the slices left to refine.
2. **Refine in dependency order**: `refine-issue` steps 1 to 4 on each, so what one slice decides
   is known when the next is drafted. The spec is the first source: investigate the code where the
   spec is silent or stale.

Over about ten slices, or when the map shows independent groups, the first subagent stops at the
map; then two or three subagents, one per group, each given the map. Tell the user the groups
before launching them.

Give every subagent the skill's path and the settled issue tracking. Each returns, per issue (the
epic's returns its map first):

```text
KEY | short title
VERDICT: ready | split | reprioritised | stale, one line
READY: each Definition of Ready item, pass or fail and why
FINDINGS: each with evidence (file:line, key, doc section)
DECIDED: what it settled itself
QUESTIONS: numbered, recommended answer, why a wrong guess matters
SHAPE: per resulting issue: title, size, priority and reason, depends on
DRAFTS: per resulting issue: description with acceptance criteria, technical details with How to verify
```

Keep each subagent's id: step 5 resumes it. Done when every subagent has returned its report.

### 3. Join the reports

Read them side by side for drafts that touch the same code in conflicting ways, the same change
drafted twice, and a dependency one found that another ignores. In epic mode, check the drafts
against the map. Each finding becomes a change to the drafts or a question.

Done when no two drafts contradict each other and every cross-issue question is written.

### 4. One round with the user

`refine-issue` step 5 for the whole batch: in epic mode, first the epic's picture in a few lines
(what the slices add up to, the order, what is merged or dropped); then each issue; then every
question, four per AskUserQuestion call. Issues with no question are approved together in one.

Done when the user has answered every question.

### 5. Apply

Resume each subagent with the final drafts, the user's answers for its issues and `refine-issue`
step 6. One subagent's write at a time where two issues link to each other, so each reads the
other's result. In epic mode, the epic's own text (its map of slices) is updated last.

Done when every subagent reports its issues written, or the failure, and the refinement queue no
longer lists the batch, except the issues that were left unrefined on purpose.

### 6. Report

`refine-issue` step 7 for the batch, in one table.

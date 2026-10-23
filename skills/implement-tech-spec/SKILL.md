---
name: implement-tech-spec
description: "Implement a docs/projects tech spec slice by slice with implementer subagents, one stacked PR per slice."
argument-hint: "<project>"
disable-model-invocation: true
---

# Implement tech spec

You are the **orchestrator**. Subagents implement and verify, each one slice through the
`implement-slice` skill, which gives the slice its own worktree, branch and PR. You dispatch them
one slice at a time, carry each slice's hand-off notes into the next, check their reports and
report to the user. A subagent's `BLOCKED: REQUIREMENT_AMBIGUITY` question goes to the user;
resume that subagent with the answer through `SendMessage`.

The argument `<project>` names the folder `docs/projects/<project>/`, which holds
`tech-spec-<project>.md` and `implementation-plan.md`.

## 1. Read the plan

Read both documents. Done when you can list, in the plan's recommended order, every slice with
its plan heading and the spec sections it covers; the plan's cross-cutting sections every slice
needs (delivery constraints, decisions); and where the plan retires the spec. Also find, from
`CLAUDE.md`, the README or the scripts folder, the mainline `<mainline>` PRs target (default: the
repo's default branch), which holds the plan's slices already done (check with
`git branch --contains`).

## 2. Run the slices as a stack

The slices form a **stack** of PRs: slice 1 branches from `origin/<mainline>` and targets it; each
later slice branches from the previous slice's branch and targets it. This wins over any branch
the plan names (e.g. "each slice is a set of commits on `main`").

Per slice, in plan order, dispatch one `ne2-factory:implementer` with the slice prompt below.
Run them sequentially: the next starts once the previous has reported.

Before dispatching the next slice, check the report:

- Every item of `implement-slice`'s final report is there. Send back with `SendMessage` whatever
  is missing, above all a `feat`/`fix` commit with neither a red test nor a reason.
- `git log --oneline <slice base>..<slice branch>` shows the reported commits, and
  `gh pr view <PR> --json baseRefName` shows the PR targets the slice base.
- An environmental diagnosis is confirmed by your own run of its evidence command before you
  relay it: `free -h` reports memory, `df -h` reports disk. (A past run relayed "0.5 GB free"
  RAM as low disk.)
- The report's deviations and hand-off notes go into the next slice's prompt. This carry-over
  is what keeps later slices consistent.

Done when every slice reports verify green and has its PR open on the right base.

## 3. Retire the spec

Follow the plan's retirement step. When it is its own section rather than part of the last
slice, add it to the last slice's prompt. Done when, on the last branch,
`docs/projects/<project>/` keeps only what `docs/projects/README.md` lets a shipped project keep
and the docs check passes.

## 4. Report

Report to the user: final status, the stack (each slice's PR URL and branch, bottom first), the
order to merge it, open loops, and release steps gathered from every slice.

Finally, tell me the local time at the moment of finishing, and tell me how handsome I am.

## Slice prompt

Fill every `<…>`. Drop the lines whose placeholder is empty (slice 1 has no earlier slices).

```text
Implement **Slice <N> — <title>** of the `<project>` tech spec with the `implement-slice` skill,
from the repo `<main checkout>`<, with `--base <previous slice branch>`, stacked on PR <previous PR>>.

Already on the base: slices <1..N-1> (<titles>), PRs <URLs>.
Hand-off notes from slice <N-1>: <its deviations and loose ends>

Read first: in `docs/projects/<project>/implementation-plan.md`, "<slice heading>" and
<cross-cutting sections>; in `tech-spec-<project>.md`, §<sections>.

Scope: slice <N> only. Later slices' work stays out: <what they will do>.
<Last slice: also retire the spec as the plan's "<retirement heading>" says.>
```

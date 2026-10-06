---
name: implement-tech-spec
description: "Implement a docs/projects tech spec slice by slice with implementer subagents in a worktree, then open a PR to the base branch."
argument-hint: "<project>"
disable-model-invocation: true
---

# Implement tech spec

You are the **orchestrator**. Subagents implement and verify. You dispatch them one slice at a
time, carry each slice's hand-off notes into the next, check their reports and report to the user.
A subagent's `BLOCKED: REQUIREMENT_AMBIGUITY` question goes to the user; resume that subagent
with the answer through `SendMessage`.

The argument `<project>` names the folder `docs/projects/<project>/`, which holds
`tech-spec-<project>.md` and `implementation-plan.md`.

## 1. Read the plan

Read both documents. Done when you can list, in the plan's recommended order, every slice with
its plan heading and the spec sections it covers; the plan's cross-cutting sections every slice
needs (delivery constraints, decisions); and where the plan retires the spec. Also find, from `CLAUDE.md`, the README or the scripts folder:
the base branch `<base>` PRs target (default: the repo's default branch), the full verification
command `<verify>` and the docs check `<verify-docs>` (omit if none).

## 2. Create the worktree

```sh
git worktree add -b feat/<project> ../"$(basename "$PWD")"-<project> <base>
```

All work lands on `feat/<project>` in that worktree. This rule wins over any branch the plan
names (e.g. "each slice is a set of commits on `main`"). The main checkout stays as the user left
it.

## 3. Run the slices

Per slice, in plan order, dispatch one `ne2-factory:implementer` with the slice prompt below.
Run them sequentially: the next starts once the previous has reported.

Before dispatching the next slice, check the report:

- Every item of the template's final report is there. Send back with `SendMessage` whatever is
  missing, above all a `feat`/`fix` commit with neither a red test nor a reason.
- `git -C <worktree> log --oneline <base>..HEAD` shows the reported commits.
- An environmental diagnosis is confirmed by your own run of its evidence command before you
  relay it: `free -h` reports memory, `df -h` reports disk. (A past run relayed "0.5 GB free"
  RAM as low disk.)
- The report's deviations and hand-off notes go into the next slice's prompt. This carry-over
  is what keeps later slices consistent.

Done when every slice reports `<verify>` green and its commits are on the branch.

## 4. Retire the spec

Follow the plan's retirement step. When it is its own section rather than part of the last
slice, add it to the last slice's prompt or dispatch one more implementer with the same template.
Done when `docs/projects/<project>/` keeps only what `docs/projects/README.md` lets a shipped
project keep and `<verify-docs>` passes.

## 5. Open the PR and report

Push `feat/<project>` and open the PR with `gh pr create --base <base>`. Its description carries:

- the slices, each with its commits;
- deviations from the plan;
- breaking changes;
- **release steps**: everything a deploy needs beyond the merge (a dev DB reset, config keys to
  add or remove), or "none".

Report to the user: final status, open loops and the PR URL.

Finally, tell me the local time at the moment of finishing, and tell me how handsome I am.

## Slice prompt

Fill every `<…>`. Drop the lines whose placeholder is empty (slice 1 has no earlier slices).

```text
You are implementing **Slice <N> — <title>** of the `<project>` tech spec.

Workspace: work only in the worktree `<worktree>` (branch `feat/<project>`), with absolute
paths in every command. Leave the main checkout `<main checkout>`, every other branch and
`git stash` untouched, and push nothing. This branch wins over any branch the plan names.

Already on this branch: slices <1..N-1> (<titles>). Inspect them with
`git -C <worktree> log --oneline <base>..HEAD`.
Hand-off notes from slice <N-1>: <its deviations and loose ends>

Read first: in `docs/projects/<project>/implementation-plan.md`, "<slice heading>" and
<cross-cutting sections>; in `tech-spec-<project>.md`, §<sections>.

Scope: slice <N> only. Later slices' work stays out: <what they will do>.

Commits: small and self-contained, one kind each (feat / fix / refactor). Tests go in the
commit with the code they test; refactor commits leave tests unchanged. Every commit builds and
passes its tests, so a changed public port moves all its consumers in the same commit. Docs
the change makes stale are updated in the same commit.

TDD: for each feat/fix behaviour, write the test first and see it red: a real test run failing
on its assertion (a compile error is not red). Then make it green.

Done: `<verify>` passes on the final commit. When verify fails for a cause outside
the code (ports, Docker, a concurrent run, memory, disk), confirm it with the command that shows
it (`docker ps`, `ss -ltnp`, `free -h`, `df -h`), re-run, and report it with that output.
Resolve minor ambiguity with the conservative choice consistent with the spec, and list it
under deviations.

Final report:
- commits: hash and subject;
- the `<verify>` result;
- red tests: for each feat/fix commit, the test seen red, or why none could be;
- deviations from the plan;
- breaking changes and release steps (dev DB reset, config to add or remove), or "none";
- hand-off notes for later slices;
- environmental failures met, with their evidence.
```

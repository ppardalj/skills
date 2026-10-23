---
name: implement-slice
description: "Implement one slice or task in its own worktree, test-first, and open a PR for review. Use when asked to implement a plan slice, a GitHub issue or a single task."
argument-hint: "<slice | issue | task> [--base <branch>]"
---

# Implement slice

The argument names the work: a slice heading of a `docs/projects/<project>/implementation-plan.md`,
a GitHub issue, or a task described in words. `--base <branch>` names the branch to start from and
target; a caller passes it to stack this slice on an earlier one.

## 1. Read the work

Read the slice (with the plan's cross-cutting sections and the spec sections it covers), the issue
with its comments, or the task. Also find, from `CLAUDE.md`, the README or the scripts folder:

- `<base>`: `--base`, else the mainline PRs target (the repo's default branch unless the docs or
  recent PRs say otherwise, e.g. `dev`);
- `<verify>`: the full verification command, and `<verify-docs>`: the docs check (omit if none).

Done when you can state the scope in one sentence, what later slices or out-of-scope work stays
out, and `<base>`, `<verify>`, `<verify-docs>`.

## 2. Create the worktree

Pick `<branch>` as `<type>/<slug>` (`feat`, `fix`, `refactor`, `test`, `docs`, `chore`), following
the repo's recent branch names. Without `--base`, start from the fresh remote mainline:

```sh
git fetch origin <base>
git worktree add -b <branch> ../"$(basename "$PWD")"-<slug> origin/<base>
```

With `--base`, start from the local `<base>` as it stands (it holds the earlier slices):
`git worktree add -b <branch> ../"$(basename "$PWD")"-<slug> <base>`.

All work lands on `<branch>` in that worktree, with absolute paths in every command. This rule
wins over any branch the plan names. The main checkout, every other branch and `git stash` stay
as the user left them.

## 3. Implement

Commits: small and self-contained, one kind each (feat / fix / refactor). Tests go in the commit
with the code they test; refactor commits leave tests unchanged. Every commit builds and passes
its tests, so a changed public port moves all its consumers in the same commit. Docs the change
makes stale are updated in the same commit. For a plan slice, once done, mark it done in the
plan's status line, in a `docs` commit.

TDD: for each feat/fix behaviour, write the test first and see it **red**: a real test run failing
on its assertion (a compile error is not red). Then make it green.

Resolve minor ambiguity with the conservative choice consistent with the spec, and list it under
deviations. An ambiguity that changes behaviour the user cares about is a question for the user
(or `BLOCKED: REQUIREMENT_AMBIGUITY` to your caller), not a guess.

Done when `<verify>` passes on the final commit. When verify fails for a cause outside the code
(ports, Docker, a concurrent run, memory, disk), confirm it with the command that shows it
(`docker ps`, `ss -ltnp`, `free -h`, `df -h`), re-run, and report it with that output.

## 4. Open the PR

Invoke the `pr` skill from the worktree, with `<base>` as the base and, when stacked, the PR of
`<base>`. Hand it the red tests, the `<verify>` result, deviations, breaking changes, release
steps and loose ends from the steps above. Done when the PR URL exists.

## 5. Report

- PR URL and `<branch>`;
- commits: hash and subject;
- the `<verify>` result;
- red tests: for each feat/fix commit, the test seen red, or why none could be;
- deviations from the plan;
- breaking changes and release steps (dev DB reset, config to add or remove), or "none";
- hand-off notes for later slices;
- environmental failures met, with their evidence.

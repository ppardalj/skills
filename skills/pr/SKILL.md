---
name: pr
description: "Push the current branch and open a GitHub PR whose description a human reviewer understands at a glance. Use when asked to open a PR, or to write or rewrite a PR description."
argument-hint: "[--base <branch>] [--stacked-on <PR>]"
---

# PR

Open a PR for the current branch. The description is for a **reviewer** who has not read the plan:
what changed and why, shown more than told, and what can go wrong when it merges.

## 1. Gather

- `<base>`: `--base`, else the mainline PRs target (the repo's default branch unless the docs or
  recent PRs say otherwise, e.g. `dev`).
- `git log --oneline <base>..HEAD` and `git diff --stat <base>...HEAD`.
- The why: the slice, issue or task behind the branch; the red tests and the verify result the
  caller handed you (else run the verify command yourself).
- The repo's conventions, from `gh pr list --state all --limit 5 --author @me` and one body: the
  title shape (Conventional Commits, scope) and the language of the description.

Done when you can say in two sentences what the reviewer will see change and what the merge risks.

## 2. Write the description

Follow the sibling skill [show-me](../show-me/SKILL.md) for the visuals, keeping to what GitHub
renders: a `diff` of the call tree or flow, a table of cases, a short `text` block of a test's
given/when/then, Mermaid. One or two visuals carry the summary; prose stays short. Sections, in
order; drop the ones that would be empty except Merge Danger and Release steps:

```markdown
Stacked on #<PR> (`<base>`); retarget to `<mainline>` once it merges.

## Summary
The problem or goal in 1–3 sentences (prod evidence when there is some), then the visual of
what changes. Bullets for details the visual doesn't show.

## Commits
`<hash>` <subject>, grouped by slice when the PR carries a plan's slices.

## Decisions / Deviations
Choices made and how the work departs from the plan or issue, each with its reason.

## Evidence
Tests seen red before the fix and green after (name, given/when/then), the verify command and
its result, anything checked by hand.

## Merge Danger
**Door:** one-way | two-way: what a revert does and doesn't undo (migrations, data written).
**Blast Radius:** <area>: who and what the merge touches, what to watch after deploy.

## Breaking changes
Contracts, APIs, DTOs that change for their consumers.

## Release steps
Everything a deploy needs beyond the merge (migrations, DB reset, config keys, deploy order),
or "None".

## Loose ends
Out of scope, open questions, known gaps.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

Done when every claim in the description is backed by a commit, a test or a command output you saw.

## 3. Open it

```sh
git push -u origin HEAD
gh pr create --base <base> --title "<title>" --body-file <file>
```

When the PR already exists, update it with `gh pr edit --body-file <file>`. Report the PR URL.

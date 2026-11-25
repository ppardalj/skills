# The repo's issue tracking

How `write-issue`, `refine-issue` and `refine-backlog` learn the way a repo tracks work. The repo
owns its policy; the skills own how to do the work well.

Take each part from the first source that settles it:

1. What the repo states: the issue-tracking line or doc its CLAUDE.md or AGENTS.md points at (in
   another repo, when several share one), then its other docs.
2. What the tracker shows: the project's fields, states, labels and link types, and three recent
   issues.
3. The default below.

Two parts are confirmed with the user when neither the repo nor the tracker settles them, and then
offered for the repo's doc: the **project**, asked before reading any issue, and, outside GitHub,
the state that means **ready**, asked with the step's other questions. On GitHub a missing `ready`
label is created with the first issue that needs it, once the user has approved that. Without an issue-tracking doc, offer the [skeleton](#skeleton) at the end of the
run.

| Part | Default |
|---|---|
| **Tracker** and access | The GitHub issues of the repo, through `gh` |
| **States**: unrefined → ready → in progress → in review → done, or discarded | GitHub: open; ready is the label `ready`; in progress and in review are the linked PR; done is closed as completed; discarded is closed as not planned |
| **Fields** | Only the ones the tracker requires |
| **Technical details** | A `## Technical details` section at the end of the description |
| **Definition of Ready** | [Below](#default-definition-of-ready) |
| **Priority** | The user's: keep what the issue has, order by it, propose none |
| **Size** | [Below](#default-size); a `Size: S` line opening the technical details, unless the tracker has a field |
| **Refinement queue** | Open issues that are neither ready nor started, by priority, then oldest first |
| **Epics** and slices | Parent and child issues; a tracker without them, a checklist of links in the epic |
| **Links** | Depends on (GitHub: blocked by) and relates to (GitHub: a link in the text) |
| **Stray findings** | Told to the user; no issue is created for them |
| **Language** of the issues | The one of the existing issues |
| **Own rules** (visibility, required fields, workflows that reject a move) | None |

## Default Definition of Ready

1. **Size S or M**, at most one PR per repo it touches.
2. **No open loop**: no pending decision in its text; every dependency linked and resolved, or
   planned.
3. **Acceptance criteria**: numbered, observable, each with its line in How to verify.
4. **Technical details to start from**: the moving parts and their order, links to the exact spec
   sections. An agent can begin without asking.
5. **Fields**: the required ones are set.

## Default size

Size measures risk and uncertainty, not volume.

- **S**: every step is routine and nothing is unknown.
- **M**: one step carries a risk beyond the routine (a migration, a manual change in production, a
  third party), or one technical question the slice itself resolves.
- **L**: an open decision nobody can settle by answering a question, more than one unknown, or an unknown that could change the design. An
  L is split, or becomes an epic with a tech spec; it is never ready.

## Skeleton

One doc per repo, or one for all the repos that share a tracker. Only the parts that differ from
the default:

```markdown
# Issue tracking

- Tracker: <URL>, through <MCP or CLI>. Projects: <repo → key>.
- States: unrefined <…>, ready <…>, in progress <…>, in review <…>, done <…>, discarded <…>.
- Fields: <field: when it is set, and its values>.
- Refinement queue: <search>.
- <Any other part of the table>
```

CLAUDE.md or AGENTS.md points at it: `Issues: project <KEY>, see <path>`.

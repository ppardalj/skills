# skills

Personal Claude Code skills.

This repo is both a Claude Code **plugin** and its own **marketplace**: it's
consumed directly from GitHub, no install scripts.

## Contents

Each directory under `skills/` is a skill with its `SKILL.md`.

## Install (once per machine)

```bash
claude plugin marketplace add ppardalj/skills
claude plugin install ppardalj@ppardalj-skills --scope user
```

This installs the plugin for your user, available in every project you open.

To pick up changes later:

```bash
claude plugin marketplace update ppardalj-skills
```

To remove it:

```bash
claude plugin uninstall ppardalj@ppardalj-skills
claude plugin marketplace remove ppardalj-skills
```

## Adding a skill

Create a new directory under `skills/` with its `SKILL.md`, bump `version` in
`.claude-plugin/plugin.json`, and push. Installed copies pick it up on the next
`claude plugin marketplace update ppardalj-skills`.

## Secrets

Secrets, tokens, and credentials must never be committed to this repository.

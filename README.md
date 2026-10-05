# skills

Personal Claude Code skills.

## Contents

Each top-level directory is a skill with its `SKILL.md`.

## Install

```bash
git clone <repo>
cd <repo>
./install.sh
```

`install.sh` symlinks every top-level directory of this repository into `~/.claude/skills/`, so
each personal skill is versioned here. It is idempotent and safe to run multiple times. Any
existing file at a target location is backed up (as `<file>.backup`, or a timestamped backup if
that already exists) before the symlink is created.

To add a new skill, create a new directory with its `SKILL.md` and re-run `install.sh`. Any
symlink in `~/.claude/skills/` that no longer points to an existing directory (e.g. a skill
removed from this repo) is deleted automatically, and a short report is printed.

## Secrets

Secrets, tokens, and credentials must never be committed to this repository.

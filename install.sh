#!/usr/bin/env bash
set -euo pipefail

# Resolve the repository directory from the location of this script.
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "OK: $dest already links to $src"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local backup="${dest}.backup"
        if [ -e "$backup" ] || [ -L "$backup" ]; then
            backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
        fi
        echo "Backing up existing $dest -> $backup"
        mv "$dest" "$backup"
    fi

    echo "Linking $dest -> $src"
    ln -s "$src" "$dest"
}

link_skills() {
    local skills_src_dir="$REPO_DIR"
    local skills_dest_dir="$HOME/.claude/skills"

    mkdir -p "$skills_dest_dir"

    echo "--- Syncing Claude skills ---"

    local name
    for skill_path in "$skills_src_dir"/*/; do
        [ -d "$skill_path" ] || continue
        name="$(basename "$skill_path")"
        link "$skills_src_dir/$name" "$skills_dest_dir/$name"
    done

    local broken_removed=0
    for dest in "$skills_dest_dir"/*; do
        [ -e "$dest" ] || [ -L "$dest" ] || continue
        if [ -L "$dest" ] && [ ! -e "$dest" ]; then
            echo "Removing broken skill symlink: $dest -> $(readlink "$dest")"
            rm "$dest"
            broken_removed=$((broken_removed + 1))
        fi
    done

    echo "Skills report: $(find "$skills_src_dir" -mindepth 1 -maxdepth 1 -type d -not -name '.git' | wc -l) skill(s) in repo, $broken_removed broken symlink(s) removed."
}

link_skills

echo "Done."

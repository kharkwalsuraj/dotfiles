#!/usr/bin/env bash
# Symlink every directory in config/ into ~/.config, replacing what is there.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$target"
for src in "$repo"/config/*/; do
    src="${src%/}"
    dest="$target/$(basename "$src")"
    if [[ -e "$dest" || -L "$dest" ]]; then
        rm -rf "$dest"
        echo "removed $dest"
    fi
    ln -s "$src" "$dest"
    echo "linked  $dest -> $src"
done

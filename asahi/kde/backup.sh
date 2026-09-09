#!/usr/bin/env bash
# Snapshot the live KDE/Wayland/font configuration into this profile.
# Destinations are driven by mapping.json.
#
# Run from anywhere:  ./asahi/kde/backup.sh
set -euo pipefail

PROFILE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MAP="$PROFILE_DIR/mapping.json"

command -v jq >/dev/null || { echo "jq is required"; exit 1; }

expand_home() { printf '%s\n' "${1/#\~/$HOME}"; }

backup_one() { # <src> <dest-relative>
    local src dest
    src="$(expand_home "$1")"
    dest="$PROFILE_DIR/$2"
    if [ ! -e "$src" ]; then
        echo "  skip (missing): $src"
        return
    fi
    mkdir -p "$(dirname "$dest")"
    cp -a -- "$src" "$dest"
    echo "  saved $src -> ${dest#"$PROFILE_DIR/"}"
}

echo "==> user files"
while IFS=$'\t' read -r src dest; do
    backup_one "$src" "$dest"
done < <(jq -r '.files[] | "\(.src)\t\(.dest)"' "$MAP")

echo "==> system files"
while IFS=$'\t' read -r src dest; do
    backup_one "$src" "$dest"
done < <(jq -r '.system[] | "\(.src)\t\(.dest)"' "$MAP")

echo
echo "Done. Review with: git -C \"$PROFILE_DIR/../..\" status"

#!/usr/bin/env bash
# Restore flatpak remotes + apps on a fresh Fedora Asahi install.
#
#   ./asahi/scripts/install-flatpak.sh [apps-file]
#
# apps-file defaults to flatpak-apps.txt next to this script
# (tab-separated: application <tab> remote <tab> branch).
set -euo pipefail

HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
APPS_FILE="${1:-$HERE/flatpak-apps.txt}"
REMOTES_FILE="$HERE/flatpak-remotes.txt"

command -v flatpak >/dev/null || { echo "flatpak is not installed" >&2; exit 1; }
[ -f "$APPS_FILE" ] || { echo "no apps file: $APPS_FILE" >&2; exit 1; }

# ── remotes ──────────────────────────────────────────────────
# The flathub/flathub-beta flatpakrepo URLs are stable; appcenter is added
# by plain repo URL because no .flatpakrepo file is published.
add_remote() { # add_remote <name> <url>
    sudo flatpak remote-add --if-not-exists "$1" "$2" 2>/dev/null \
        || echo "   (remote $1 already present)"
}
add_remote flathub      https://dl.flathub.org/repo/flathub.flatpakrepo
add_remote flathub-beta https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo
add_remote appcenter    https://flatpak.elementaryos.org/repo

# ── apps ─────────────────────────────────────────────────────
while IFS=$'\t' read -r app remote branch; do
    [ -n "${app:-}" ] || continue
    case "$app" in \#*) continue ;; esac
    remote="${remote:-flathub}"
    branch="${branch:-stable}"
    ref="$app"
    [ "$branch" != "stable" ] && ref="$app//$branch"
    echo ">> installing $ref ($remote)"
    sudo flatpak install -y --noninteractive "$remote" "$ref"
done <"$APPS_FILE"

echo
echo "done. installed apps:"
flatpak list --app --columns=application,version

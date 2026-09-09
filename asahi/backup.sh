#!/usr/bin/env bash
# Back up the machine-specific state you would lose on a reinstall:
#   - flatpak app list + remotes
#   - tailscale prefs + node identity (/var/lib/tailscale/tailscaled.state)
#   - FlClash config (subscriptions live in its data dirs)
#
# Usage: ./asahi/backup.sh [output-dir]
#        default output-dir: ~/asahi-backup-YYYYmmdd-HHMMSS
#
# WARNING: the backup contains secrets (tailscale node key, FlClash data).
# Keep it private. FlClash's config.age is age-encrypted, but database.sqlite
# and shared_preferences.json may contain subscription URLs in clear text.
set -euo pipefail

PROFILE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="${1:-$HOME/asahi-backup-$STAMP}"

# Safety: never write a backup inside the git repo. It contains secrets
# (tailscale node key, FlClash subscriptions) and the repo is public.
REPO_ROOT="$(git -C "$PROFILE_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
if [ -n "$REPO_ROOT" ]; then
    case "$(realpath -m -- "$OUT")" in
        "$REPO_ROOT"/*)
            echo "refusing to write a backup inside the git repo: $OUT" >&2
            echo "pick a path outside $REPO_ROOT" >&2
            exit 1
            ;;
    esac
fi

mkdir -p "$OUT"/{flatpak,tailscale,flclash}

echo ">> flatpak"
flatpak list --app --columns=application,origin,branch >"$OUT/flatpak/apps.txt"
flatpak remotes --columns=name,url >"$OUT/flatpak/remotes.txt"
echo "   $(wc -l <"$OUT/flatpak/apps.txt") apps, $(wc -l <"$OUT/flatpak/remotes.txt") remotes"

echo ">> tailscale"
tailscale debug prefs >"$OUT/tailscale/prefs.json" 2>/dev/null || echo "   warn: tailscale not reachable"
if sudo test -f /var/lib/tailscale/tailscaled.state; then
    sudo cp -a /var/lib/tailscale/tailscaled.state "$OUT/tailscale/tailscaled.state"
    sudo chown "$(id -u):$(id -g)" "$OUT/tailscale/tailscaled.state"
    chmod 600 "$OUT/tailscale/tailscaled.state"
    echo "   saved node identity"
else
    echo "   warn: /var/lib/tailscale/tailscaled.state not found"
fi

echo ">> flclash"
for d in "$HOME/.local/share/FlClash" "$HOME/.local/share/com.follow.clash"; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    # skip the big re-downloadable geo databases and lock files
    tar -C "$HOME/.local/share" \
        --exclude="$name/ASN.mmdb" \
        --exclude="$name/GEOIP.dat" \
        --exclude="$name/GEOIP.metadb" \
        --exclude="$name/GEOSITE.dat" \
        --exclude="$name/*.lock" \
        -czf "$OUT/flclash/$name.tgz" "$name"
    echo "   saved $name"
done

echo
echo "backup written to $OUT"
du -sh "$OUT"

#!/usr/bin/env bash
# Restore the KDE/Wayland/font configuration from this profile to the live
# system. Sources/destinations are driven by mapping.json.
#
# Run from anywhere:  ./asahi/kde/install.sh
set -euo pipefail

PROFILE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MAP="$PROFILE_DIR/mapping.json"

command -v jq >/dev/null || { echo "jq is required"; exit 1; }

expand_home() { printf '%s\n' "${1/#\~/$HOME}"; }

restore_one() { # <src-rel> <dest>
    local src dest
    src="$PROFILE_DIR/$1"
    dest="$(expand_home "$2")"
    if [ ! -e "$src" ]; then
        echo "  skip (missing): ${src#"$PROFILE_DIR/"}"
        return
    fi
    mkdir -p "$(dirname "$dest")"
    if [ -e "$dest" ] && ! cmp -s -- "$src" "$dest"; then
        cp -a -- "$dest" "$dest.bak.$(date +%s)"
        echo "  backed up existing $dest"
    fi
    cp -a -- "$src" "$dest"
    echo "  restored $dest"
}

echo "==> user files"
while IFS=$'\t' read -r src dest; do
    restore_one "$src" "$dest"
done < <(jq -r '.files[] | "\(.dest)\t\(.src)"' "$MAP")

echo "==> system files (sudo)"
while IFS=$'\t' read -r src dest; do
    sudo install -Dm644 -- "$PROFILE_DIR/$src" "$dest"
    echo "  restored $dest"
done < <(jq -r '.system[] | "\(.dest)\t\(.src)"' "$MAP")

echo "==> refresh caches"
fc-cache -f >/dev/null 2>&1 && echo "  fc-cache ok"
kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
if command -v fcitx5 >/dev/null && pgrep -x fcitx5 >/dev/null; then
    pkill -x fcitx5 || true
    sleep 1
    setsid -f fcitx5 -d >/dev/null 2>&1
    echo "  fcitx5 restarted"
fi
gdbus call --session --dest org.kde.KWin --object-path /KWin \
    --method org.kde.KWin.reconfigure >/dev/null 2>&1 || true
systemctl --user restart plasma-plasmashell.service >/dev/null 2>&1 || true
echo "  plasmashell restarted"

cat <<'EOF'

Done.

Notes:
  * 字体本体不在此仓库（体积大）。见 README.md 的 "Fonts" 一节，
    需要先把 MiSans / HarmonyOS Sans 装到 ~/.local/share/fonts/，
    并运行 scripts/fix-misans-weights.py。
  * 全局环境变量需要注销/重新登录后生效。
EOF

#!/usr/bin/env bash
# Install a set of popular fcitx5 themes into ~/.local/share/fcitx5/themes.
#
#   ./asahi/scripts/install-fcitx-themes.sh
#
# Themes:
#   - Catppuccin      (4 flavors x accents, 56 variants)
#   - Material Color  (blue / purple / pink / sakuraPink / teal)
#   - Nord            (Dark / Light)
#   - Gruvbox         (Dark / Light)
#   - Dracula
#
# Switch afterwards with `fcitx5-configtool` (Addons -> Classic UI -> Theme)
# or edit ~/.config/fcitx5/conf/classicui.conf
set -euo pipefail

THEMES_DIR="${FCITX_THEMES_DIR:-$HOME/.local/share/fcitx5/themes}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v git >/dev/null || { echo "git is required" >&2; exit 1; }
mkdir -p "$THEMES_DIR"

# Default to SSH because plain HTTPS to github.com can time out here.
# Override for HTTPS (e.g. behind a proxy):
#   FCITX_THEME_CLONE_BASE=https://github.com/ https_proxy=http://127.0.0.1:7890 \
#       ./asahi/scripts/install-fcitx-themes.sh
CLONE_BASE="${FCITX_THEME_CLONE_BASE:-git@github.com:}"
clone() { # clone <owner/repo> <dir>
    git clone --depth=1 -q "${CLONE_BASE}$1.git" "$TMP/$2"
}

echo ">> Catppuccin (56 variants)"
clone catppuccin/fcitx5 catppuccin
cp -r "$TMP/catppuccin/src/catppuccin-"* "$THEMES_DIR/"

echo ">> Material Color"
clone hosxy/Fcitx5-Material-Color material
for c in blue deepPurple pink sakuraPink teal; do
    d="$THEMES_DIR/Material-$c"
    mkdir -p "$d"
    cp "$TMP/material/theme-$c.conf" "$d/theme.conf"
    cp "$TMP/material/arrow.png" "$TMP/material/radio.png" "$d/"
done

echo ">> Nord"
clone tonyfettes/fcitx5-nord nord
cp -r "$TMP/nord/Nord-Dark" "$TMP/nord/Nord-Light" "$THEMES_DIR/"

echo ">> Gruvbox"
clone ayamir/fcitx5-gruvbox gruvbox
cp -r "$TMP/gruvbox/Gruvbox-Dark" "$TMP/gruvbox/Gruvbox-Light" "$THEMES_DIR/"

echo ">> Dracula"
clone drbbr/fcitx5-dracula-theme dracula
mkdir -p "$THEMES_DIR/Dracula"
cp "$TMP/dracula/theme.conf" "$TMP/dracula/"*.png "$THEMES_DIR/Dracula/"

echo
echo "installed themes ($(find "$THEMES_DIR" -name theme.conf | wc -l) total):"
find "$THEMES_DIR" -name theme.conf -printf '  %h\n' \
    | sed "s|^$THEMES_DIR/||" | sort

cat <<EOF

switch:
  fcitx5-configtool            # 附加组件 -> Classic UI -> Theme
  # or edit ~/.config/fcitx5/conf/classicui.conf:
  #   Theme=catppuccin-mocha-mauve
  #   DarkTheme=catppuccin-mocha-mauve
  #   UseAccentColor=False     # 保留主题自带强调色
EOF

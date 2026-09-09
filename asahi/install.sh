#!/usr/bin/env bash
# Install the Asahi profile:
#   - symlink bin/screenlight + bin/kbdlight into ~/.local/bin
#   - symlink bashrc into ~/.bashrc.d/asahi.sh
#   - install the udev rule that makes the keyboard backlight writable
#
# Run from anywhere:  ./asahi/install.sh
set -euo pipefail

PROFILE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="$HOME/.local/bin"
RC_DIR="$HOME/.bashrc.d"
UDEV_SRC="$PROFILE_DIR/udev/60-kbd-backlight.rules"
UDEV_DST="/etc/udev/rules.d/60-kbd-backlight.rules"

link() { # link <src> <dst>
    local src="$1" dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv -- "$dst" "$dst.bak.$(date +%s)"
        echo "backed up existing $dst"
    fi
    ln -sfn -- "$src" "$dst"
    echo "linked $dst -> $src"
}

mkdir -p "$BIN_DIR" "$RC_DIR"

for f in "$PROFILE_DIR"/bin/*; do
    link "$f" "$BIN_DIR/$(basename "$f")"
done

link "$PROFILE_DIR/bashrc" "$RC_DIR/asahi.sh"

# Fedora's ~/.bashrc already sources ~/.bashrc.d/*; add it if missing.
if ! grep -q 'bashrc\.d' "$HOME/.bashrc" 2>/dev/null; then
    cat >>"$HOME/.bashrc" <<'EOF'

# user profile snippets
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [ -f "$rc" ] && . "$rc"
    done
fi
unset rc
EOF
    echo "added ~/.bashrc.d sourcing to ~/.bashrc"
fi

# udev rule: make /sys/class/leds/kbd_backlight/brightness writable by the user
if ! cmp -s "$UDEV_SRC" "$UDEV_DST" 2>/dev/null; then
    sudo install -m 644 -- "$UDEV_SRC" "$UDEV_DST"
    sudo udevadm control --reload-rules
    sudo udevadm trigger --subsystem-match=leds --action=change
    echo "installed $UDEV_DST"
else
    echo "$UDEV_DST already up to date"
fi

echo
echo "done. open a new shell (or 'source ~/.bashrc'), then try:  light get"

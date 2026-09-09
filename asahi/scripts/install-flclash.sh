#!/usr/bin/env bash
# Install / upgrade FlClash (Clash Meta GUI) on Fedora Asahi (aarch64).
#
#   ./asahi/scripts/install-flclash.sh [version]
#
# Upstream only publishes an arm64 .deb for Linux, so this extracts the
# package manually instead of requiring alien.
set -euo pipefail

REPO="chen08209/FlClash"
PREFIX="/usr/share/FlClash"
BIN="/usr/bin/FlClash"
DESKTOP="/usr/share/applications/FlClash.desktop"

die() { echo "error: $*" >&2; exit 1; }

case "$(uname -m)" in
    aarch64 | arm64) ARCH=arm64 ;;
    x86_64 | amd64) ARCH=amd64 ;;
    *) die "unsupported architecture: $(uname -m)" ;;
esac

for c in curl ar tar; do command -v "$c" >/dev/null || die "missing command: $c"; done

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
    VERSION="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
        | grep -m1 '"tag_name"' | cut -d'"' -f4)"
fi
[ -n "$VERSION" ] || die "could not determine the latest FlClash version"
VER="${VERSION#v}"
DEB="FlClash-${VER}-linux-${ARCH}.deb"
URL="https://github.com/$REPO/releases/download/$VERSION/$DEB"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo ">> downloading $DEB"
curl -fL --retry 3 -o "$TMP/$DEB" "$URL"

echo ">> extracting"
( cd "$TMP" && ar x "$DEB" )
DATA="$(ls "$TMP"/data.tar.* | head -1)"
[ -n "$DATA" ] || die "no data.tar inside $DEB"

mkdir -p "$TMP/root"
tar -xaf "$DATA" -C "$TMP/root"

APP_DIR="$(find "$TMP/root" -type d -name FlClash -path '*/share/*' | head -1)"
[ -n "$APP_DIR" ] || die "cannot find the FlClash directory inside the package"

echo ">> installing to $PREFIX"
sudo rm -rf "$PREFIX"
sudo cp -a "$APP_DIR" "$PREFIX"
# the core needs to run as root (matches the upstream package)
sudo chown -R root:root "$PREFIX"
sudo chmod u+s "$PREFIX/FlClashCore"
sudo ln -sfn "$PREFIX/FlClash" "$BIN"

if [ -f "$TMP/root/usr/share/applications/FlClash.desktop" ]; then
    sudo install -Dm644 "$TMP/root/usr/share/applications/FlClash.desktop" "$DESKTOP"
fi
if [ -d "$TMP/root/usr/share/icons" ]; then
    sudo cp -a "$TMP/root/usr/share/icons/." /usr/share/icons/
fi
command -v update-desktop-database >/dev/null \
    && sudo update-desktop-database /usr/share/applications >/dev/null 2>&1 || true

echo
echo "installed FlClash $VER -> $BIN"
echo "your config in ~/.local/share/FlClash is untouched;"
echo "restore it from the backup if this was a fresh system."

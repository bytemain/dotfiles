#!/usr/bin/env bash
# Install (or reinstall) Tailscale on Fedora Asahi.
#
#   ./asahi/scripts/install-tailscale.sh
#
# If a tailscaled.state backup exists it is restored first, so the machine
# keeps its tailnet identity and does not need to log in again.
# Override the location with TAILSCALE_STATE_BACKUP=/path/to/tailscaled.state
set -euo pipefail

STATE_BACKUP="${TAILSCALE_STATE_BACKUP:-$HOME/asahi-backup/tailscale/tailscaled.state}"
REPO_FILE=/etc/yum.repos.d/tailscale.repo

# ── repo + package ───────────────────────────────────────────
if ! rpm -q tailscale >/dev/null 2>&1; then
    if [ ! -f "$REPO_FILE" ]; then
        echo ">> adding tailscale repo"
        curl -fsSL https://pkgs.tailscale.com/stable/fedora/tailscale.repo \
            | sudo tee "$REPO_FILE" >/dev/null
    fi
    echo ">> installing tailscale"
    sudo dnf install -y tailscale
fi

# ── restore node identity (optional) ─────────────────────────
if [ -f "$STATE_BACKUP" ]; then
    echo ">> restoring node identity from $STATE_BACKUP"
    sudo systemctl stop tailscaled || true
    sudo install -d -m 700 /var/lib/tailscale
    sudo install -m 600 -o root -g root "$STATE_BACKUP" /var/lib/tailscale/tailscaled.state
fi

# ── service + operator ───────────────────────────────────────
sudo systemctl enable --now tailscaled
sudo tailscale set --operator="${SUDO_USER:-$USER}" || true

echo
if [ -f "$STATE_BACKUP" ]; then
    tailscale status | head -5
else
    echo "installed. now log in with:"
    echo "    tailscale up"
fi

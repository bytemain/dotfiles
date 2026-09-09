# asahi

Profile for **Fedora Asahi Remix** on Apple Silicon — developed on a
MacBook Air M3 (Mac15,12), hostname `huan-fedora`.

The `macos*` profiles are zsh; this one is **bash** (Fedora Asahi Remix ships
bash by default), so it installs as `~/.bashrc.d/asahi.sh` instead of `~/.zshrc`.

## Layout

```
asahi/
├── bashrc                          # profile: DOTFILE_NAME, PATH, brightness functions
├── install.sh                      # link bin/ + bashrc + udev rule into place
├── backup.sh                       # snapshot flatpak / tailscale / flclash state
├── bin/
│   ├── screenlight                 # internal display brightness (kscreen-doctor)
│   └── kbdlight                    # keyboard backlight (/sys/class/leds/kbd_backlight)
├── udev/
│   └── 60-kbd-backlight.rules      # makes the keyboard LED writable without sudo
└── scripts/
    ├── install-flatpak.sh          # remotes + apps from flatpak-apps.txt
    ├── install-tailscale.sh        # repo + package + service (+ state restore)
    ├── install-flclash.sh          # extract the official arm64 .deb (no alien)
    ├── flatpak-apps.txt            # generated from `flatpak list`
    └── flatpak-remotes.txt
```

## Install the profile

```bash
~/dotfiles/asahi/install.sh
source ~/.bashrc
```

## Brightness

Apple Silicon has **no `/sys/class/backlight`**, so `brightnessctl` cannot
drive the panel (and `apple-panel-bl` is a T2/Intel device that does not exist
here). The panel is controlled through KWin/KScreen; the keyboard is a normal
LED.

```bash
light get              # screen: 100%   kbd:  40%
light down 10          # both, -10%
light 40               # both to 40%
light off / on         # screen -> 1%, keyboard off / restore
kbd set 80             # keyboard only
screen up              # screen only
```

## Back up before a reinstall

```bash
~/dotfiles/asahi/backup.sh              # -> ~/asahi-backup-YYYYmmdd-HHMMSS
```

It saves:

| What | File |
| --- | --- |
| flatpak apps | `flatpak/apps.txt` |
| flatpak remotes | `flatpak/remotes.txt` |
| tailscale prefs | `tailscale/prefs.json` |
| tailscale identity | `tailscale/tailscaled.state` |
| FlClash config | `flclash/FlClash.tgz`, `flclash/com.follow.clash.tgz` |

> The backup contains secrets (tailscale node key, FlClash subscriptions).
> Keep it private and never commit it.

## Restore on a fresh install

```bash
~/dotfiles/asahi/install.sh
~/dotfiles/asahi/scripts/install-flatpak.sh
~/dotfiles/asahi/scripts/install-tailscale.sh     # restores node identity if backup found
~/dotfiles/asahi/scripts/install-flclash.sh
tar -xzf ~/asahi-backup-*/flclash/FlClash.tgz          -C ~/.local/share
tar -xzf ~/asahi-backup-*/flclash/com.follow.clash.tgz -C ~/.local/share
```

Notes:

- **Tailscale** — restoring `tailscaled.state` keeps the node key, so no
  re-login is needed. Without a backup, run `tailscale up`. The script also
  sets `--operator=$USER` so `tailscale` works without sudo.
- **FlClash** — upstream only ships an arm64 `.deb`; the script extracts it
  with `ar`/`tar` and sets the setuid bit on `FlClashCore` (as the package
  does). No `alien` needed.
- **OpenClash / mihomo** — FlClash keeps profiles in `database.sqlite`
  (plus the age-encrypted `config.age`). To reuse a subscription in OpenClash
  or mihomo, export it from FlClash (Profiles → Share) or keep the original
  subscription URL; the `.tgz` backup above restores the GUI state.

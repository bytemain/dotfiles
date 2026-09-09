# asahi/kde

KDE / Wayland / 字体配置快照 — **Fedora Asahi Remix** (aarch64, KDE Plasma 6.7,
2560×1600 @ 150% 缩放)。

这里保存的是"让 HiDPI + 中文 + 输入法都舒服"的一整套配置。文件清单由
[`mapping.json`](./mapping.json) 驱动，`backup.sh` / `install.sh` 都读它。

## 用法

```bash
~/dotfiles/asahi/kde/backup.sh    # 把当前 live 配置快照进本目录
~/dotfiles/asahi/kde/install.sh   # 把本目录的配置恢复到系统（会先备份现有文件）
```

`install.sh` 结束后会 `fc-cache`、重启 fcitx5 / plasmashell / 重载 KWin。
**全局环境变量需要注销重新登录后才生效。**

## 文件

| 仓库内路径 | 系统路径 | 作用 |
|---|---|---|
| `config/fontconfig/fonts.conf` | `~/.config/fontconfig/fonts.conf` | 默认字体（MiSans）、CJK/emoji fallback、macOS 风格渲染（无 hinting + 灰度抗锯齿） |
| `config/kdeglobals` | `~/.config/kdeglobals` | KDE 全局字体：MiSans 10 / 标题栏 / 菜单 |
| `config/fcitx5/classicui.conf` | `~/.config/fcitx5/conf/classicui.conf` | 输入法候选窗字体 `MiSans 12` + `EnableFractionalScale=True` |
| `config/fcitx5/{config,profile}` | `~/.config/fcitx5/` | 输入法按键与方案 |
| `config/environment.d/99-wayland.conf` | `~/.config/environment.d/` | 用户级 Wayland 环境变量 |
| `config/plasma-workspace/env/10-wayland.sh` | `~/.config/plasma-workspace/env/` | KDE 会话启动时导出 Wayland 环境变量 |
| `config/ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty` | 终端字体 Hack + 中文 fallback MiSans |
| `config/applications/dida.desktop` | `~/.local/share/applications/dida.desktop` | 滴答清单强制 Wayland |
| `system/etc/environment.d/99-wayland.conf` | `/etc/environment.d/99-wayland.conf` | 系统级 Wayland 环境变量 |
| `system/flatpak-overrides-global` | `/var/lib/flatpak/overrides/global` | 所有 flatpak 应用自动走 Wayland |

## Fonts

字体本体**不在仓库里**（约 90 MB）。需要单独安装到 `~/.local/share/fonts/`：

### MiSans（默认字体）

```bash
mkdir -p ~/.local/share/fonts/MiSans
unzip -o -j ~/Downloads/MiSans_Global_ALL.zip \
  "MiSans Global _ALL/MiSans.zip" -d /tmp/misans
unzip -o -j /tmp/misans/MiSans.zip \
  "MiSans/MiSans VF.ttf" "MiSans/ttf/*.ttf" -d ~/.local/share/fonts/MiSans
rm -rf /tmp/misans

# 关键：修正字重元数据，否则正文会错、粗体会变成 Heavy
sudo dnf install -y python3-fonttools
python3 ~/dotfiles/asahi/kde/scripts/fix-misans-weights.py
fc-cache -f
```

修正后：

| 请求 | 命中 |
|---|---|
| regular（正文） | MiSans **Medium** |
| bold | MiSans Bold |
| medium | MiSans Medium |
| light | MiSans Regular |

### HarmonyOS Sans（备用）

```bash
mkdir -p ~/.local/share/fonts/HarmonyOS_Sans
unzip -o -j ~/Downloads/HarmonyOS+Sans.zip "HarmonyOS Sans/*.ttf" \
  -d ~/.local/share/fonts/HarmonyOS_Sans
fc-cache -f
```

切换系统字体到 HarmonyOS Sans 时，改 `kdeglobals` 和 `fonts.conf` 里的
`MiSans` → `HarmonyOS Sans SC` 即可。

### 其他

- **Inter**：`rsms-inter-fonts`，早期用于模仿 SF Pro，现被 MiSans 取代。
- **Hack**：等宽字体（macOS Menlo 近似），终端用。

## Wayland

所有应用强制走 Wayland（`ELECTRON_OZONE_PLATFORM_HINT=auto` +
`MOZ_ENABLE_WAYLAND=1`），Qt/GTK 本来就会自动选 Wayland，无需额外设置。

已知例外：

- **WeChat**：客户端本身只支持 X11，无解。
- **dida（滴答清单）**：Electron 21 太老，不认全局环境变量，靠
  `dida.desktop` 单独加 `--ozone-platform=wayland`。

检查哪些应用还在 XWayland：

```bash
DISPLAY=:0 xlsclients
```

## 踩过的坑

1. **fcitx5 配置是扁平格式，不能有 `[ClassicUI]` 段**。带段会导致整份配置被
   静默忽略（候选窗字体一直是默认 `Sans 10`）。用
   `gdbus ... GetConfig 'fcitx://config/addon/classicui'` 可以验证实际生效值。
2. **MiSans 字重元数据不规范**，必须跑 `fix-misans-weights.py`。
3. **Ghostty 中文 fallback** 默认走 fontconfig 的等宽 CJK（Noto Sans Mono
   CJK SC），因为 MiSans 是比例字体。需要在 `font-family` 里显式追加 MiSans。
4. **dida 的 rpm 架构是 `arm64`**，Fedora 只认 `aarch64`，`dnf` 会拒绝，
   需 `rpm -ivh --ignorearch`。

## 相关包

见 [`packages.txt`](./packages.txt)。

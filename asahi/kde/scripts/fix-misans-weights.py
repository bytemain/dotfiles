#!/usr/bin/env python3
"""Normalize MiSans static-font weights so fontconfig picks the intended faces.

The MiSans release ships non-standard `usWeightClass` values (Regular=330,
Medium=380, ...), which makes fontconfig treat Medium as the body weight but
also makes bold requests resolve to Heavy. This script rewrites the weight
classes so that:

  * a "regular" request -> MiSans Medium   (user's preferred body weight)
  * a "bold" request    -> MiSans Bold
  * light/medium/etc. keep sane ordering

Usage:
    python3 fix-misans-weights.py [font-dir]

Default font-dir: ~/.local/share/fonts/MiSans
Requires: python3-fonttools
"""
from __future__ import annotations

import os
import sys

try:
    from fontTools.ttLib import TTFont
except ImportError:  # pragma: no cover
    sys.exit("fontTools is required: sudo dnf install python3-fonttools")

WEIGHTS = {
    "Thin": 100,
    "ExtraLight": 200,
    "Light": 250,
    "Regular": 300,
    "Medium": 400,
    "Semibold": 600,
    "Bold": 700,
    "Heavy": 900,
}


def main() -> None:
    font_dir = os.path.expanduser(
        sys.argv[1] if len(sys.argv) > 1 else "~/.local/share/fonts/MiSans"
    )
    if not os.path.isdir(font_dir):
        sys.exit(f"not a directory: {font_dir}")

    for name in sorted(os.listdir(font_dir)):
        if not name.endswith(".ttf") or "VF" in name:
            continue
        key = name[len("MiSans-") : -len(".ttf")] if name.startswith("MiSans-") else None
        if key not in WEIGHTS:
            continue
        path = os.path.join(font_dir, name)
        font = TTFont(path)
        old = font["OS/2"].usWeightClass
        font["OS/2"].usWeightClass = WEIGHTS[key]
        font.save(path)
        print(f"{name:26s} {old:>4} -> {WEIGHTS[key]}")

    print("\nRun `fc-cache -f` afterwards.")


if __name__ == "__main__":
    main()

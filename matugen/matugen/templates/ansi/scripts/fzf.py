#!/usr/bin/env python3
import json
import os

from pathlib import Path


HOME = Path.home()
XDG_CONFIG_HOME = Path(os.environ.get("XDG_CONFIG_HOME", HOME / ".config")).expanduser()
XDG_STATE_HOME = Path(os.environ.get("XDG_STATE_HOME", HOME / ".local/state")).expanduser()

STATE_DIR = XDG_STATE_HOME / "matugen"
MATERIAL_COLORS = STATE_DIR / "m3colors.json"
ANSI_COLORS = STATE_DIR / "ansi.json"
FZF_COLORS = STATE_DIR / "fzf-colors"


with MATERIAL_COLORS.open("r", encoding="utf-8") as f:
    material = json.load(f)

with ANSI_COLORS.open("r", encoding="utf-8") as f:
    ansi = json.load(f)


content = ",".join([
    f"fg:{ansi['term7']}",
    f"bg:{ansi['term0']}",

    f"fg+:{material['on_surface']}",
    f"bg+:{material['surface_container_highest']}",

    f"hl:{material['primary']}",
    f"hl+:{material['on_primary_container']}",

    f"info:{ansi['term6']}",
    f"prompt:{ansi['term4']}",
    f"pointer:{ansi['term4']}",
    f"marker:{ansi['term5']}",
    f"spinner:{ansi['term5']}",
    f"header:{ansi['term6']}",
    f"border:{material['outline']}",
    f"gutter:{ansi['term0']}",
])


FZF_COLORS.parent.mkdir(parents=True, exist_ok=True)
FZF_COLORS.write_text(content, encoding="utf-8")

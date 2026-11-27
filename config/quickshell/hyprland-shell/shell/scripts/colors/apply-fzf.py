#!/usr/bin/env python3
"""Overwrite fzf/colors (an fzf options file) with the base16 colors of a colors.json.

fish points FZF_DEFAULT_OPTS_FILE at it, so every new fzf picks the colors up with no reload step.
Neovim's fzf-lua takes its colors from the Neovim highlight groups instead (see nvim/lua/plugins/fzf.lua).
"""
import json
import os
import sys
from pathlib import Path

config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
output = (config_home / "fzf/colors").resolve()

b = json.loads(Path(sys.argv[1]).read_text())["base16_colors"]

# transparent bg/gutter so fzf keeps the terminal background
colors = {
    "fg": b["base05"],
    "bg": "-1",
    "hl": b["base0D"],
    "fg+": b["base06"],
    "bg+": b["base02"],
    "hl+": b["base0D"],
    "info": b["base0E"],
    "prompt": b["base0D"],
    "pointer": b["base0D"],
    "marker": b["base0B"],
    "spinner": b["base0C"],
    "header": b["base04"],
    "border": b["base03"],
    "gutter": "-1",
    "label": b["base04"],
    "query": b["base05"],
}

line = ",".join(f"{name}:{value}" for name, value in colors.items())
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(f"# Overwritten by shell/scripts/colors/apply-fzf.py\n--color={line}\n")

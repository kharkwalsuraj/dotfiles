#!/usr/bin/env python3
import argparse
import json
import os
from pathlib import Path


HOME = Path.home()
XDG_STATE_HOME = Path(os.environ.get("XDG_STATE_HOME", HOME / ".local/state")).expanduser()
XDG_CACHE_HOME = Path(os.environ.get("XDG_CACHE_HOME", HOME / ".cache")).expanduser()

STATE_DIR = XDG_STATE_HOME / "matugen"
MATERIAL_COLORS = STATE_DIR / "m3colors.json"
ANSI_COLORS = STATE_DIR / "ansi.json"
WAL_DIR = XDG_CACHE_HOME / "wal"


parser = argparse.ArgumentParser(description="Generate NvChad Base46 theme")
parser.add_argument("--mode", choices=["dark", "light"], required=True)
args = parser.parse_args()


# Load colors
with MATERIAL_COLORS.open("r", encoding="utf-8") as f:
    material = json.load(f)

with ANSI_COLORS.open("r", encoding="utf-8") as f:
    ansi = json.load(f)


# Output file -: trust me it works
BASE46_OUTPUT = WAL_DIR / f"base46-dark.lua"


# Generate theme
content = f"""local M = {{}}

local lighten = require("base46.colors").change_hex_lightness

M.base_30 = {{
  white = "{material["on_background"]}",
  black = "{material["surface_container"]}",
  darker_black = lighten("{ansi["term0"]}", -1),
  black2 = lighten("{material["background"]}", 6),
  one_bg = lighten("{material["background"]}", 10),
  one_bg2 = lighten("{material["background"]}", 16),
  one_bg3 = lighten("{material["background"]}", 22),
  grey = "{material["surface_variant"]}",
  grey_fg = lighten("{material["surface_variant"]}", -10),
  grey_fg2 = lighten("{material["surface_variant"]}", -20),
  light_grey = "{material["outline"]}",
  red = "{ansi["term1"]}",
  baby_pink = lighten("{ansi["term1"]}", 10),
  pink = "{material["tertiary"]}",
  line = "{material["surface_container_high"]}",
  green = "{ansi["term2"]}",
  vibrant_green = lighten("{ansi["term2"]}", 10),
  blue = "{ansi["term4"]}",
  nord_blue = lighten("{ansi["term4"]}", 10),
  yellow = "{ansi["term3"]}",
  sun = lighten("{ansi["term3"]}", 10),
  purple = "{material["tertiary"]}",
  dark_purple = lighten("{material["tertiary"]}", -10),
  teal = "{material["secondary_container"]}",
  orange = "{ansi["term1"]}",
  cyan = "{ansi["term6"]}",
  statusline_bg = "{ansi["term0"]}",
  pmenu_bg = "{material["primary"]}",
  folder_bg = "{material["primary_fixed_dim"]}",
  lightbg = lighten("{material["background"]}", 10),
}}

M.base_16 = {{
  base00 = "{ansi["term0"]}",
  base01 = "{material["surface_variant"]}",
  base02 = lighten("{material["surface_variant"]}", 3),
  base03 = "{material["outline"]}",
  base04 = "{material["on_surface_variant"]}",
  base05 = "{material["on_surface"]}",
  base06 = "{material["on_surface"]}",
  base07 = "{material["surface"]}",
  base08 = "{ansi["term1"]}",
  base09 = "{ansi["term3"]}",
  base0A = "{ansi["term4"]}",
  base0B = "{ansi["term2"]}",
  base0C = "{ansi["term6"]}",
  base0D = lighten("{ansi["term4"]}", 20),
  base0E = "{material["tertiary"]}",
  base0F = "{material["inverse_surface"]}",
}}

M.type = "{args.mode}"

M.polish_hl = {{
  defaults = {{
    Comment = {{ italic = true, fg = "{ansi["term3"]}" }},
  }},

  tbline = {{
    TbFill = {{ bg = "{ansi["term0"]}" }},
    TbBufOn = {{ bg = "{material["surface_container_high"]}" }},
    TbBufOnClose = {{ bg = "{material["surface_container_high"]}", fg = "{ansi["term1"]}" }},
    TbBufOff = {{ bg = "{ansi["term0"]}" }},
    TbBufOffClose = {{ bg = "{ansi["term0"]}", fg = "{ansi["term1"]}" }},
  }},

  nvimtree = {{
    NvimTreeNormal = {{ bg = "{ansi["term0"]}" }},
    NvimTreeNormalNC = {{ bg = "{ansi["term0"]}" }},
    NvimTreeEndOfBuffer = {{ bg = "{ansi["term0"]}" }},
    NvimTreeWinSeparator = {{ bg = "{ansi["term0"]}", fg = "{ansi["term0"]}" }},
  }},

  treesitter = {{
    ["@comment"] = {{ fg = M.base_16.base03 }},
    ["@string"] = {{ fg = "{material["tertiary"]}" }},
  }},
}}

return M
"""


# Write file
WAL_DIR.mkdir(parents=True, exist_ok=True)
BASE46_OUTPUT.write_text(content, encoding="utf-8")

#!/usr/bin/env python3
import json
import os
import subprocess

from pathlib import Path


HOME = Path.home()
XDG_CONFIG_HOME = Path(os.environ.get("XDG_CONFIG_HOME", HOME / ".config")).expanduser()
XDG_STATE_HOME = Path(os.environ.get("XDG_STATE_HOME", HOME / ".local/state")).expanduser()


STATE_DIR = XDG_STATE_HOME / "matugen"
MATERIAL_COLORS = STATE_DIR / "m3colors.json"
ANSI_COLORS = STATE_DIR / "ansi.json"
KITTY_COLORS = XDG_CONFIG_HOME / "kitty/themes/Matugen.conf"


with MATERIAL_COLORS.open("r", encoding="utf-8") as f:
    material = json.load(f)
    

with ANSI_COLORS.open("r", encoding="utf-8") as f:
    ansi = json.load(f)


content = f"""# Main Colors
background            {ansi["term0"]}
foreground            {ansi["term7"]}
cursor                {ansi["term7"]}

selection_background  {material["on_secondary_container"]}
selection_foreground  {material["secondary_container"]}

# ANSI Colors
color0                {ansi["term0"]}
color1                {ansi["term1"]}
color2                {ansi["term2"]}
color3                {ansi["term3"]}
color4                {ansi["term4"]}
color5                {ansi["term5"]}
color6                {ansi["term6"]}
color7                {ansi["term7"]}
color8                {ansi["term8"]}
color9                {ansi["term9"]}
color10               {ansi["term10"]}
color11               {ansi["term11"]}
color12               {ansi["term12"]}
color13               {ansi["term13"]}
color14               {ansi["term14"]}
color15               {ansi["term15"]}

# Starship Prompt Bubbles
color255              {material["primary"]}
color254              {material["primary_container"]}
color253              {material["secondary"]}
color252              {material["secondary_container"]}
color251              {material["tertiary"]}
color250              {material["tertiary_container"]}
color249              {material["error"]}
color248              {material["error_container"]}

color232              {material["on_primary"]}
color233              {material["on_primary_container"]}
color234              {material["on_secondary"]}
color235              {material["on_secondary_container"]}
color236              {material["on_tertiary"]}
color237              {material["on_tertiary_container"]}
color238              {material["on_error"]}
color239              {material["on_error_container"]}
color240              {material["on_primary"]}

# Matched with unthemed light/dark
color243              {material["primary"]}
color244              {material["error"]}
color245              {material["outline_variant"]}

"""


KITTY_COLORS.parent.mkdir(parents=True, exist_ok=True)
KITTY_COLORS.write_text(content, encoding="utf-8")


subprocess.run(["kitty", "+kitten", "themes", "--reload-in=all", "Matugen"], check=True)

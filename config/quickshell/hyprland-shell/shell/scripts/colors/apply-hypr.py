#!/usr/bin/env python3
"""Overwrite hypr/colors.lua with the material colors of a colors.json and reload Hyprland."""
import json
import os
import subprocess
import sys
from pathlib import Path

config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
output = (config_home / "hypr/colors.lua").resolve()

material = json.loads(Path(sys.argv[1]).read_text())["material_colors"]

# hex without '#', the format the Hyprland rgb() helper uses
entries = "\n".join(f'    {name} = "{value.lstrip("#")}",' for name, value in material.items())
output.write_text(f"-- Overwritten by shell/scripts/colors/apply-hypr.py\nreturn {{\n{entries}\n}}\n")

subprocess.run(["hyprctl", "reload"])

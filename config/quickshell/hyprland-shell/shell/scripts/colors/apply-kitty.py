#!/usr/bin/env python3
"""Overwrite kitty/themes/Colors.conf from a colors.json and reload running kitty windows."""
import json
import os
import subprocess
import sys
from pathlib import Path

config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
output = (config_home / "kitty/themes/Colors.conf").resolve()

data = json.loads(Path(sys.argv[1]).read_text())
m = data["material_colors"]
ansi = data["ansi_colors"]
base16 = data["base16_colors"]

names = ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"]
names += [f"bright{name.capitalize()}" for name in names]
palette = "\n".join(f"color{i:<2} {ansi[name]}" for i, name in enumerate(names))

output.write_text(f"""# Overwritten by shell/scripts/colors/apply-kitty.py
foreground              {m["onSurface"]}
background              {base16["base00"]}
selection_foreground    {m["secondaryContainer"]}
selection_background    {m["onSecondaryContainer"]}
cursor                  {m["primary"]}
cursor_text_color       {m["onPrimary"]}
url_color               {m["tertiary"]}

active_border_color     {m["primary"]}
inactive_border_color   {m["outlineVariant"]}
bell_border_color       {m["error"]}

tab_bar_background      {m["surfaceContainerLowest"]}
active_tab_foreground   {m["onPrimary"]}
active_tab_background   {m["primary"]}
inactive_tab_foreground {m["onSurfaceVariant"]}
inactive_tab_background {m["surfaceContainer"]}

{palette}
""")

# SIGUSR1 reloads the config in every running kitty
subprocess.run(["pkill", "-USR1", "-x", "kitty"])

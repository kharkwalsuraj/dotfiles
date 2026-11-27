#!/usr/bin/env python3
"""Overwrite nvim/lua/editor/theme/colors.lua with the base16 colors of a colors.json and reload running Neovims."""
import json
import os
import stat
import subprocess
import sys
from pathlib import Path

config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
output = (config_home / "nvim/lua/editor/theme/colors.lua").resolve()

base16 = json.loads(Path(sys.argv[1]).read_text())["base16_colors"]
entries = "\n".join(f'    {name} = "{value.upper()}",' for name, value in base16.items())
output.write_text(f"-- Overwritten by shell/scripts/colors/apply-nvim.py\nreturn {{\n{entries}\n}}\n")

runtime_dir = Path(os.environ.get("XDG_RUNTIME_DIR") or f"/run/user/{os.getuid()}")
reload_expr = 'luaeval(\'require("editor.theme").reload()\')'

for server in runtime_dir.glob("nvim.*"):
    if not stat.S_ISSOCK(server.stat().st_mode):
        continue
    try:
        subprocess.run(["nvim", "--server", str(server), "--remote-expr", reload_expr], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=3)
    except subprocess.TimeoutExpired:
        pass

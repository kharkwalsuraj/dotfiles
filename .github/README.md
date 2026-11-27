# Dotfiles

This is the `hyprland` branch: a standalone Hyprland setup that tries to stay independent from other desktop environment applications as much as possible.

## Contents
- `config/hypr`: Hyprland, written in Lua
- `config/kitty`: kitty terminal with a Catppuccin Mocha theme on neutral black (dynamic Material colors take over when available)
- `config/fish`: fish shell with Starship (Jetpack preset in `config/starship`), fzf and a few helper functions
- `config/nvim`: Neovim 0.12+ built on `vim.pack` and the built-in LSP client

## Install
Check [DEPENDENCIES.md](DEPENDENCIES.md), then run `./setup.sh`. It symlinks every directory in `config/` into `~/.config` and replaces whatever is there, so back up existing configs first.

Machine-specific Hyprland overrides (monitors, devices) go in `config/hypr/local.lua`, which git ignores.

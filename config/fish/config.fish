# Environment

set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man! +'set nocursorcolumn scrolloff=999'"
set -gx LESSHISTFILE '-'

set -q XDG_CACHE_HOME   ||  set -gx XDG_CACHE_HOME   "$HOME/.cache"
set -q XDG_CONFIG_HOME  ||  set -gx XDG_CONFIG_HOME  "$HOME/.config"
set -q XDG_DATA_HOME    ||  set -gx XDG_DATA_HOME    "$HOME/.local/share"
set -q XDG_STATE_HOME   ||  set -gx XDG_STATE_HOME   "$HOME/.local/state"

set -gx THEOSHELL_TRASH_DIR "$XDG_DATA_HOME/theoshell/trash"
set -gx THEOSHELL_CDF_DIR "$XDG_DATA_HOME/theoshell/cd-fav.txt"

# Starship reads its config from the repo-managed directory (setup.sh links config/starship into ~/.config)
set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"

fish_add_path ~/.local/bin

# Interactive shell

if status is-interactive
    # Empty greeting
    set -g fish_greeting

    # fzf
    if type -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --hidden --strip-cwd-prefix --exclude ".git"'
    end
    set -gx FZF_DEFAULT_OPTS '--layout=reverse --cycle --height=50% --margin=5% --border=double'

    if type -q fzf
        fzf --fish | source
    end

    # Prompt
    if type -q starship
        starship init fish | source
    end
end

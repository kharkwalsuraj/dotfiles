# Commands to run in interactive sessions
if status is-interactive
    set fish_greeting
    set -gx EDITOR 'nvim'

    if test "$TERM" != "linux"
        starship init fish | source
        enable_transience
    end

    function f
        set -l fzf_args
        if test -f ~/.local/state/matugen/fzf-colors
            set -a fzf_args --color=(cat ~/.local/state/matugen/fzf-colors)
        end
        set -l path (command fzf $fzf_args --preview 'cat {} 2>/dev/null')
        test -n "$path"; or return
        printf '%s' "$path" | wl-copy
    end

    function fe
        set -l fzf_args
        if test -f ~/.local/state/matugen/fzf-colors
            set -a fzf_args --color=(cat ~/.local/state/matugen/fzf-colors)
        end
        set -l path (command fzf $fzf_args --preview 'cat {} 2>/dev/null')
        test -n "$path"; or return
        nvim "$path"
    end

    alias clear "printf '\\033[2J\\033[3J\\033[1;1H'"
end

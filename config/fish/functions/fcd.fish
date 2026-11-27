function fcd --description 'Pick a directory with fzf and cd into it'
    type -q fd; or return 1
    set -l dir (fd --type d --hidden --exclude .git $argv | fzf --prompt 'cd> ' --preview 'ls -A {}')
    test -n "$dir"; and cd $dir
end

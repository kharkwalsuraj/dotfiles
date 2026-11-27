function fe --description 'Pick a file with fzf, cd to its directory and open it in $EDITOR'
    type -q fd; or return 1
    set -l file (fd --type f --hidden --exclude .git $argv | fzf --prompt 'edit> ' --preview 'head -n 100 {}')
    test -n "$file"; or return
    cd (path dirname $file); and $EDITOR (path basename $file)
end

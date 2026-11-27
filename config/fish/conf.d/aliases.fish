# Safer and more useful defaults for common commands
status is-interactive; or return

# Behavior
alias mkdir 'mkdir -p'
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -Iv'
alias ln 'ln -iv'

# Output
alias grep 'grep --color=auto'
alias diff 'diff --color=auto'
alias ip 'ip -color=auto'
alias df 'df -h'
alias du 'du -h'
alias free 'free -h'

if type -q eza
    alias ls 'eza --group-directories-first --icons=auto'
    alias ll 'eza -lah --group-directories-first --icons=auto --git'
    alias tree 'eza --tree --icons=auto'
else
    alias ls 'ls --color=auto --group-directories-first'
    alias ll 'ls -lAh'
end

# Shortcuts
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a v nvim
abbr -a g git
abbr -a gs 'git status -sb'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gd 'git diff'
abbr -a gl 'git log --oneline --graph --decorate -20'
abbr -a gp 'git push'

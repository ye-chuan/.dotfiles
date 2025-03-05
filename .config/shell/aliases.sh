## General Aliases and Functions

# DotFiles Management
alias mydotfiles='git -C $HOME --git-dir=.dotfiles --work-tree=.'

# Colour Support
alias ls='ls --color=auto'          # Colors based on file type (e.g. directories etc)
alias grep='grep --color=auto'      # Colors pattern matches for grep
#alias fgrep='fgrep --color=auto'   # Use `grep -F` instead
#alias egrep='egrep --color=auto'   # Use `grep -E` instead

alias la='ls -a'
alias ll='ls -l'

# Safety
alias mv='mv -i'
alias cp='cp -i'

# Python Virtual Environment
# Virtual environements should be stored in ~/.venv/
pyvenv(){
    source "${HOME}/.venv/${1}/bin/activate"
}

# Local Aliases
source "${HOME}/.local-config/aliases.sh"

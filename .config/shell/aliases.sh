## General Aliases and Functions

# DotFiles Management
alias mydotfiles='git -C $HOME --git-dir=.dotfiles --work-tree=.'

# Mini Helpers
alias view='nvim -R'

# Colour Support
alias ls='ls --color=auto'          # Colors based on file type (e.g. directories etc)
alias grep='grep --color=auto'      # Colors pattern matches for grep
#alias fgrep='fgrep --color=auto'   # Use `grep -F` instead
#alias egrep='egrep --color=auto'   # Use `grep -E` instead
alias ip='ip --color=auto'

alias la='ls -a'
alias ll='ls -l'

# Safety
alias mv='mv -i'
alias cp='cp -i'

# Local Aliases
source "${HOME}/.local-config/aliases.sh"

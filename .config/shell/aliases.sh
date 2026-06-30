## General Aliases and Functions

# DotFiles Management
alias mydotfiles='git -C $HOME --git-dir=.dotfiles --work-tree=.'

# Git
alias cdgit='cd $(git rev-parse --show-toplevel)'

# Mini Helpers
alias view='nvim -R'

# Vim Private Mode
# Good for editing sensitive files without leaving traces in any other directories
# --clean includes: No viminfo (viminfofile=NONE), noundofile, no plugins
# Swap and backups will only ever be written to the same directory as the file (if not writable then it will not be written)
# "Backups" are by default only used temporarily when writing (writebackup), if directory not writable, we will be prompted to use :w!
alias vimcognito='vim --clean -c "set directory=. backupdir=."'

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


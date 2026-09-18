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

# Terminal Debug
## Terminal Escape Sequences
### xterm otherModifyKeys has 2 modes (and 1 disabled mode)
alias sendOtherModKeysMode0="printf '\e[>4;0m'"     # Off
alias sendOtherModKeysMode1="printf '\e[>4;1m'"
alias sendOtherModKeysMode2="printf '\e[>4;2m'"

### Kitty uses a flagging method, where a program pushes the current mode to Kitty with flags
### (e.g. Flag 1 means to Disambiguate Escape Code, 2 means to report event types (press/release), etc)
### The program is then expected to pop the mode so Kitty can return to its previous
alias sendKittyKeysPush1="printf '\e[>1u'"     # push: flag 1 to disambiguate escape codes (the common choice)
alias sendKittyKeysPushAll="printf '\e[>31u'"  # push: all flags (1+2+4+8+16)
alias sendKittyKeysPop="printf '\e[<u'"        # pop one mode entry
# Send a request to push flag 1, followed by a query to check enabled flags with the terminal
# (should print `1` almost immediately if Kitty Keyboard Protocol is working)
alias sendKittyCheck="printf '\e[>1u\e[?u'; read -rs -t1 -d u r; echo "'"${r#*\?}"'

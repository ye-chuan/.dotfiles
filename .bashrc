SHELL_CONFIG="$HOME/.config/shell"  # For files that are meant to be shared between shells (POSIX Compliant)

# Bash History
shopt -s histappend # Append to .bash_history instead of overriding
HISTSIZE=10000      # Size of internal memory history of commands during a session (blank means inf)
HISTFILESIZE=10000  # Max lines in .bash_history (truncated after saving history of a session) (blank means inf)

set -o vi   # Should've already been set in .inputrc, this is extra
export VISUAL=nvim  # Set default visual editor to be NeoVim

# Glob
shopt -s globstar   # Allow ** to mean recursive glob (>= bash 4.0)

# Source Other Stuff
source "$SHELL_CONFIG/aliases.sh"
## Dir Colors (for commands like `ls`)
[ -f "$SHELL_CONFIG/.dircolors" ] && eval "$(dircolors "$SHELL_CONFIG/.dircolors")"     # POSIX allows for new quotes to start within the context of a command sub $()
## Prompt
source "$SHELL_CONFIG/prompt.sh"

# External Programs (execute if they exist)
## nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"    # Auto-load / source nvm for use
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # Loads nvm completions for bash


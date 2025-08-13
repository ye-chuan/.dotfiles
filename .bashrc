# Keep in mind that this is sourced only in INTERACTIVE bash sessions
# e.g. bash -c {command} will not source this

SHELL_CONFIG="$HOME/.config/shell"

# Bash History
shopt -s histappend # Append to .bash_history instead of overriding
HISTSIZE=10000      # Size of internal memory history of commands during a session (blank means inf)
HISTFILESIZE=10000  # Max lines in .bash_history (truncated after saving history of a session) (blank means inf)
HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S  '    # 1. Instructs bash history to be written with timestamp info; 2. Specify format to print when using `history`

set -o vi   # Should've already been set in .inputrc, this is extra
export VISUAL=nvim  # Set default visual editor to be NeoVim
export SUDO_EDITOR=vim  # Set default editor for sudoedit (safer way to edit privileged files)

# Glob
shopt -s globstar   # Allow ** to mean recursive glob (>= bash 4.0)
shopt -s extglob    # Extended glob (nice for exclusions in glob patterns)

# Source Other Stuff
source "$SHELL_CONFIG/bash-aliases.sh"
## Dir Colors (for commands like `ls`)
[ -f "$SHELL_CONFIG/.dircolors" ] && eval "$(dircolors -b "$SHELL_CONFIG/.dircolors")"     # POSIX allows for new quotes to start within the context of a command sub $()
## Prompt
source "$SHELL_CONFIG/bash-prompt.sh"

# External Programs (execute setup)
## Run scripts that are included in the setup_dir (should contain names of scripts to run)
if [[ -f "$SHELL_CONFIG/.prgm_setup_list" ]]; then
    setup_dir=""
    while read -r line; do
        if [ "${line#?}" = "${line#\#}" ]; then   # If the line starts with a # (Parameter Expansion Pattern Matching)
            continue
        fi

        if [ -z "${setup_dir}" ]; then      # First valid line should be the path where setup scripts are stored
            setup_dir="${line}"
            continue
        fi

        source "${setup_dir}${line}"   # Run the setup script

    done < "$SHELL_CONFIG/.prgm_setup_list"
fi

# Keep in mind that this is sourced only in INTERACTIVE bash sessions
# e.g. bash -c {command} will not source this

# Tmux for Graphical Sessions
# (at the top as `exec` replaces bash and should ideally be done early)
if command -v tmux &> /dev/null &&
  [ -n "$PS1" ] &&
  [[ ! "$TERM" =~ screen ]] &&
  [[ ! "$TERM" =~ tmux ]] &&
  [ -z "$TMUX" ] &&
  { [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; }; then
    exec tmux
fi

SHELL_CONFIG="$HOME/.config/shell"

# Bash History
shopt -s histappend # Append to .bash_history instead of overriding
HISTSIZE=10000      # Size of internal memory history of commands during a session (blank means inf)
HISTFILESIZE=10000  # Max lines in .bash_history (truncated after saving history of a session) (blank means inf)
HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S  '    # 1. Instructs bash history to be written with timestamp info; 2. Specify format to print when using `history`

set -o vi   # Should've already been set in .inputrc, this is extra

# Glob
shopt -s globstar   # Allow ** to mean recursive glob (>= bash 4.0)
shopt -s extglob    # Extended glob (nice for exclusions in glob patterns)

## Dir Colors (for commands like `ls`)
[ -f "$SHELL_CONFIG/.dircolors" ] && eval "$(dircolors -b "$SHELL_CONFIG/.dircolors")"     # POSIX allows for new quotes to start within the context of a command sub $()

# Alias
source "$SHELL_CONFIG/aliases.bash"
## Prompt
source "$SHELL_CONFIG/prompt.bash"
## Local Drop-Ins
for f in "$SHELL_CONFIG"/local/*; do
    if [[ "$f" =~ \.bash$ ]]; then
        source "$f";
    fi
done; unset f


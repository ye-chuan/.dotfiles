# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# If running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

## PATH
# set PATH so it includes user's local bin
# (this is where user-specific apps will be symlinked into.
#  Installation should be done in ~/.local/opt/)
PATH="$HOME/.local/bin:$PATH"

## XDG Specification (using defaults but listing them explicitly for my reference)
export XDG_DATA_HOME="$HOME/.local/share"   # Persistent application data
export XDG_CONFIG_HOME="$HOME/.config"      # Application configuration
export XDG_STATE_HOME="$HOME/.local/state"  # For persistent data that is not as important/portable as those in XDG_DATA_HOME

## fastfetch (neofetch replacement)
! command -v fastfetch > /dev/null 2>&1 || fastfetch

###
export TERMINAL=wezterm


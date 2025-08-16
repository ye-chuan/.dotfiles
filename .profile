# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
#
# Hence this file should be used as a universal config for
# login shells, the individual shell's login config
# (e.g. .bash_profile) are expected to sources this

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.

# Append "$1" to $PATH if not already in
append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}


SHELL_CONFIG="$HOME/.config/shell"

## PATH
# set PATH so it includes user's local bin
# (this is where user-specific apps will be symlinked into.
#  Installation should be done in ~/.local/opt/)
append_path "$HOME/.local/bin"

## XDG Specification (using defaults but listing them explicitly for my reference)
export XDG_DATA_HOME="$HOME/.local/share"   # Persistent application data
export XDG_CONFIG_HOME="$HOME/.config"      # Application configuration
export XDG_STATE_HOME="$HOME/.local/state"  # For persistent data that is not as important/portable as those in XDG_DATA_HOME

# Newt Colors (for TUI apps that uses Newt)
. "$SHELL_CONFIG/newt-colors.sh"

## Drop-Ins in ~/.config/shell/profile.d/
if [ -d "$SHELL_CONFIG/profile.d/" ]; then
    for profile in "$SHELL_CONFIG"/profile.d/*.sh; do
        [ -r "$profile" ] && . "$profile"
    done; unset profile
fi
## Local Drop-Ins in ~/.config/shell/profile.d/local/
if [ -d "$SHELL_CONFIG/profile.d/local/" ]; then
    for profile in "$SHELL_CONFIG"/profile.d/local/*.sh; do
        [ -r "$profile" ] && . "$profile"
    done; unset profile
fi

### Graphical Session Environmental Variables
# Note: Sourcing here will of course only take effect if the
# graphical session (e.g. sway) is started from the login shell
# (i.e. not via a display manager) since this files is only
# sourced on login shells.
. "$HOME/.config/environment/graphical.sh"

## fastfetch (neofetch replacement)
! command -v fastfetch > /dev/null 2>&1 || fastfetch


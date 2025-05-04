#! /bin/bash

# Utilities for my installation scripts

# Root check
is_root=false
if [ "$EUID" -eq 0 ]; then
    is_root=true
fi

# User's Home Directory (even when sudo)
USERNAME="$(whoami)"
if [ "${is_root}" = true ]; then
    USERNAME="${SUDO_USER}"
fi
# Get user's home directory from querying passwd file
USER_HOME=$(getent passwd "${USERNAME}" | cut --delimiter=: --fields=6)

setup_list_file_add() {
    # Adds setup filename $1 into the .bashrc prgm setup list (should be at ~/.config/shell/.prgm_setup_list)
    setup_filename="$1"

    setup_list_file="${USER_HOME}/.config/shell/.prgm_setup_list"
    if [[ ! -f "${setup_list_file}" ]]; then    # Create the list of programs to setup in .bashrc
        echo "${USER_HOME}/.config/scripts/program_setups/" > "${setup_list_file}"  # First line of this list just denote where to find the setup scripts
    fi

    if grep "^${setup_filename}\$" "${setup_list_file}" > /dev/null; then
        echo ">>> ${setup_filename} already exists in ${setup_list_file}"
    else
        echo ">>> Adding ${setup_filename} to ${setup_list_file} for .bashrc to source"
        echo "${setup_filename}" >> "${setup_list_file}"
    fi
}


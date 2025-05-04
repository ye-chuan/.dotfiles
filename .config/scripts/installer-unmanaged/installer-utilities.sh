#! /bin/bash

# Utilities for my installation scripts

# Root check
is_root=false
if [ "$EUID" -eq 0 ]; then
    is_root=true
fi

SHELL_CONFIG="$HOME/.config/shell"  # For files that are meant to be shared between shells (POSIX Compliant)

setup_list_file_add() {
    # Adds setup filename $1 into the .bashrc prgm setup list (should be at ~/.config/shell/.prgm_setup_list)
    setup_filename="$1"

    setup_list_file="${SHELL_CONFIG}/.prgm_setup_list"
    if [[ ! -f "${setup_list_file}" ]]; then    # Create the list of programs to setup in .bashrc
        echo "$HOME/.config/scripts/program_setups/" > "${setup_list_file}"  # First line of this list just denote where to find the setup scripts
    fi

    if grep "^${setup_filename}\$" "${setup_list_file}" > /dev/null; then
        echo ">>> ${setup_filename} already exists in ${setup_list_file}"
    else
        echo ">>> Adding ${setup_filename} to ${setup_list_file} for .bashrc to source"
        echo "${setup_filename}" >> "${setup_list_file}"
    fi
}

setup_file_source() {
    setup_filename="$1"

    setup_list_file="${SHELL_CONFIG}/.prgm_setup_list"
    # External Programs (execute setup)
    ## Run scripts that are included in the setup_dir (should contain names of scripts to run)
    if [[ ! -f "$SHELL_CONFIG/.prgm_setup_list" ]]; then
        echo ".prgm_setup_list NOT FOUND!" >&2
        return 1
    fi

    setup_dir=""
    while read -r line; do
        if [ "${line#?}" = "${line#\#}" ]; then   # If the line starts with a # (Parameter Expansion Pattern Matching)
            continue
        fi

        if [ -z "${setup_dir}" ]; then      # First valid line should be the path where setup scripts are stored
            setup_dir="${line}"
            break
        fi
    done < "$SHELL_CONFIG/.prgm_setup_list"

    source "${setup_dir}${setup_filename}"   # Run the setup script
}


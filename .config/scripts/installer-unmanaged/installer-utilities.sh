#! /bin/bash

# Utilities for my installation scripts

# Root check
is_root=false
if [ "$EUID" -eq 0 ]; then
    is_root=true
fi

SHELL_CONFIG="$HOME/.config/shell"  # For files that are meant to be shared between shells (POSIX Compliant)
SETUP_DIR="$HOME/.config/scripts/program_setups"    # Directory where program setup scripts are stored


setup_file_source() {
    setup_filename="$1"
    setup_filepath="${SETUP_DIR}/${setup_filename}"

    if ! [ -r "${setup_filepath}" ]; then
        echo ">>> ERROR: ${setup_filepath} DOES NOT EXISTS"
        return 1
    fi

    source "${setup_filepath}"   # Run the setup script
}

setup_source_and_add_to_login() {
    # Make sure the corresponding program setup in "$HOME/.config/scripts/program_setups/"
    # is sourced at every login (i.e. sourced by .profile)
    setup_filename="$1"
    setup_filepath="${SETUP_DIR}/${setup_filename}"

    # Sourcing also checked for existence of the setup file
    if ! setup_file_source "${setup_filename}"; then
        return 1
    fi

    ln -sf "${setup_filepath}" "${SHELL_CONFIG}/profile.d/local/${setup_filename}"
    echo ">>> Link added: ${SHELL_CONFIG}/profile.d/local/${setup_filename} -> ${setup_filepath}"
}

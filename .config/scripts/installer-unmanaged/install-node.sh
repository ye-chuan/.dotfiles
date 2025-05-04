#!/bin/bash

print_usage() {
    cat << EOF
Usage: $(basename "${BASH_SOURCE}") [OPTIONS]

Description:
  Installs Node.JS (via nvm)

Options:
  -u, --user    To install on the user level (default)
  -s, --system  To install on a system level (requires root)
                  Note: Currently Unimplemented
  --root-ok     Ok to install user-level for root

Examples:
  $(basename "${BASH_SOURCE}") --system
  $(basename "${BASH_SOURCE}") --user
  $(basename "${BASH_SOURCE}") --user --root-ok
EOF
}

set -e  # Exits if any command fails

script_dir=$(dirname -- "$(readlink --canonicalize -- "${BASH_SOURCE[0]}")")

source "${script_dir}/installer-utilities.sh"
source "${script_dir}/check-x86_64.sh"

#######################################
# Install Node.JS
# Arguments:
#   --user / --system   : Type of install (--user default)
#   --root-ok           : Ok to install as --user for root user
# Returns:
#   0 if installed, non-zero on error.
#######################################
install_node() {
    is_system_install=false
    is_root_ok=false
    while [ $# -gt 0 ]; do
        case "$1" in
            -s|--system)
                is_system_install=true
                ;;
            -u|--user)
                is_system_install=false
                ;;
            --root-ok)
                is_root_ok=true
                ;;
            -h|--help)
                print_usage
                return 0
                ;;
            *)
                echo ">>> Invalid argument: $1" >&2
                print_usage
                return 1
                ;;
        esac
        shift
    done

    if [ "${is_system_install}" = true ]; then
        echo ">>> ERROR: SYSTEM installation of node not yet supported" >&2
        return 1
    fi

    # USER Installation
    if [ "${is_root}" = true ] && [ "${is_root_ok}" = false ]; then
        echo ">>> ERROR: Do not run as root to install for user (add --root-ok flag to allow install for root user)" >&2
        return 1
    fi
    echo ">>> Proceeding with USER installation of node for: ${USER}"

    echo ">>> Installing latest NodeJS will be done through nvm"
    if ! command -v nvm > /dev/null 2>&1; then
        read -r -p ">>> nvm not installed, press to proceed with installation..."
        if ! "${script_dir}/install-nvm.sh" --user; then  # Return if nvm installation fails
            echo ">>> nvm installation failed? Aborting NodeJS installation."
            return 1
        fi
    fi
    echo ">>> Sourcing nvm setup script"
    setup_file_source "nvm_setup.sh"

    echo ">>> Installing latest release of NodeJS via nvm"
    nvm install node

    echo ">>> NodeJS installed"
    echo ""
}

install_node "$@"

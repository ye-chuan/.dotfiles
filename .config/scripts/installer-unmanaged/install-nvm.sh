#!/bin/bash

print_usage() {
    cat << EOF
Usage: $(basename "${BASH_SOURCE}") [OPTIONS]

Description:
  Installs NVM (Node.js Version Manager)

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
# Install NVM (Node Version Manager)
# Arguments:
#   --user / --system   : Type of install (--user default)
#   --root-ok           : Ok to install as --user for root user
# Returns:
#   0 if installed, non-zero on error.
#######################################
install_nvm() {
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
        echo ">>> ERROR: SYSTEM installation of nvm not yet supported" >&2
        return 1
    fi

    # USER Installation
    if [ "${is_root}" = true ] && [ "${is_root_ok}" = false ]; then
        echo ">>> ERROR: Do not run as root to install for user (add --root-ok flag to allow install for root user)" >&2
        return 1
    fi
    install_path="${HOME}/.local/opt/ghcup"
    echo ">>> Proceeding with USER installation of nvm for: ${USER}"

    NVM_DIR="${HOME}/.nvm"
    if [[ -d "${NVM_DIR}" ]]; then
        read -r -p ">>> ${NVM_DIR} already exists, press to proceed with updating..."
        echo ">>> Fetching new updates from GitHub"
        git -C "${NVM_DIR}" fetch
    else
        echo ">>> Cloning from https://github.com/nvm-sh/nvm.git to ${NVM_DIR}"
        # Important to sudo if not root will own the local .nvm directory
        git clone https://github.com/nvm-sh/nvm.git "${NVM_DIR}"
    fi

    latest_ver_commit=$(git -C "${NVM_DIR}" rev-list --tags --max-count=1)   # Commit hash of the latest tag
    latest_tag=$(git -C "${NVM_DIR}" describe "${latest_ver_commit}")
    echo ">>> Latest Git Tag: ${latest_tag}"
    read -r -p ">>> Please confirm that the tag holds the latest version (press to proceed...)"
    echo ">>> Checkout out tag ${latest_tag}"
    git -C "${NVM_DIR}" checkout "${latest_tag}"

    source "${NVM_DIR}/nvm.sh"

    setup_list_file_add "nvm_setup.sh"

    echo ">>> nvm installed"
    echo ""
}

install_nvm "$@"

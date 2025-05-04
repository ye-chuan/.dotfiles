#!/bin/bash

print_usage() {
    cat << EOF
Usage: $(basename "${BASH_SOURCE}") [OPTIONS]

Description:
  Interactive Installer for packages not managed by the
  system's package manager (e.g. apt)

  These scripts should take the flags --user, --system to specify
  if the installation is done system-wide or per-user.

Options:
  -u, --user    To install the packages on the user level (default)
  -s, --system  To install the packages on a system level (requires root)
                  Note: some installation scripts do not support this
  --root-ok     Ok to install user-level for root

Examples:
  $(basename "${BASH_SOURCE}") --system
  $(basename "${BASH_SOURCE}") --user
  $(basename "${BASH_SOURCE}") --user --root-ok
EOF
}

script_dir=$(dirname -- "$(readlink --canonicalize -- "${BASH_SOURCE[0]}")")

# List of Program: Installation Command Mappings
declare -A install_script_for
install_script_for["Neovim (be sure to also install npm for plugin dependencies)"]="${script_dir}/install-neovim.sh"
install_script_for["NodeJS (using nvm; also installs npm)"]="${script_dir}/install-node.sh"
install_script_for["GHC (Haskell Compiler; installed using GHCup)"]="${script_dir}/install-ghc.sh"

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
            exit 0
            ;;
        *)
            echo ">>> Invalid argument: $1" >&2
            print_usage
            exit 1
            ;;
    esac
    shift
done

echo "[[NON-PACKAGE-MANAGED INSTALLATIONS]]"
if [ "${is_system_install}" = true ]; then
    if [ "${is_root}" = false ]; then
        echo ">>> ERROR: Need to be root to install system-wide" >&2
        return 1
    fi
    echo ">>> Proceeding with SYSTEM installation of the following programs."
else
    if [ "${is_root}" = true ] && [ "${is_root_ok}" = false ]; then
        echo ">>> ERROR: Do not run as root to install for user (add --root-ok flag to allow install for root user)" >&2
        return 1
    fi
    echo ">>> Proceeding with USER installation of the following programs for: ${USER}."
fi

for program in "${!install_script_for[@]}"; do
    read -r -p "Install ${program} [y/N]? " choice
    if [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        if [ "${is_system_install}" = true ]; then
            "${install_script_for["${program}"]}" --system
        else
            "${install_script_for["${program}"]}" --user
        fi
    fi
done


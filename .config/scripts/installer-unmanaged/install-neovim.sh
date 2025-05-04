#!/bin/bash

print_usage() {
    cat << EOF
Usage: $(basename "${BASH_SOURCE}") [OPTIONS]

Description:
  Installs latest NeoVim

Options:
  -u, --user    To install on the user level (default)
  -s, --system  To install on a system level (requires root)
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
# Install NeoVim
# Arguments:
#   --user / --system   : Type of install (--user default)
#   --root-ok           : Ok to install as --user for root user
# Returns:
#   0 if installed, non-zero on error.
#######################################
install_neovim() {
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
        if [ "${is_root}" = false ]; then
            echo ">>> ERROR: Need to be root to install system-wide" >&2
            return 1
        fi
        install_path="/opt/nvim"
        echo ">>> Proceeding with SYSTEM installation of nvim"
    else
        if [ "${is_root}" = true ] && [ "${is_root_ok}" = false ]; then
            echo ">>> ERROR: Do not run as root to install for user (add --root-ok flag to allow install for root user)" >&2
            return 1
        fi
        install_path="${HOME}/.local/opt/nvim"
        echo ">>> Proceeding with USER installation of nvim for: ${USER}"
    fi

    tempdir=$(mktemp -d -t "install-neovim.XXXXXX")
    trap 'rm -rf "${tempdir}"' EXIT

    mkdir -p "$(dirname "${install_path}")"

    if [ -d "${install_path}" ]; then
        read -r -p "$("${install_path}/bin/nvim" --version | head -n 1) already installed at ${install_path}/! Override [y/N]? " choice
        if ! [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo ">>> Terminating..."
            return 0
        fi
    fi

    echo ">>> Installing Latest Stable Neovim from GitHub"
    echo ">>> Getting .tar from https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    curl -L -o "${tempdir}/nvim-linux-x86_64.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

    # Checksum Verification
    echo ">>> Getting SHA256 checksum from https://github.com/neovim/neovim/releases/latest/download/shasum.txt"
    curl -L -o "${tempdir}/shasum.txt" "https://github.com/neovim/neovim/releases/latest/download/shasum.txt"
    if ! (cd "${tempdir}" && grep "nvim-linux-x86_64.tar.gz" shasum.txt | sha256sum --check); then     # cd-ed in a subshell to get same output format for sha256sum
        echo ">>> WARNING: Checksum verification failed!" >&2
        echo ">>> Terminating..."
        return 1
    fi
    echo -n ">>> SHA256 Checksum Verified: "
    sha256sum "${tempdir}/nvim-linux-x86_64.tar.gz"

    echo ">>> Removing old version at ${install_path} (if exists)"
    rm -rf "${install_path}"
    echo ">>> Extracting..."
    tar --directory="${tempdir}" -xzf "${tempdir}/nvim-linux-x86_64.tar.gz"
    echo ">>> Moving to ${install_path}"
    mv "${tempdir}/nvim-linux-x86_64" "${install_path}"

    # Adding binaries to PATH (via symlink)
    if [ "${is_system_install}" = true ]; then
        echo ">>> Adding symlink from /opt/bin/"
        mkdir -p "/opt/bin/"
        ln -s "${install_path}/bin/nvim" "/opt/bin/nvim"
    else
        echo ">>> Adding symlink from ${HOME}/.local/bin/"
        mkdir -p "${HOME}/.local/bin/"
        ln -s "${install_path}/bin/nvim" "${HOME}/.local/bin/nvim"
    fi
    echo ">>> NeoVim installed"
    echo ""
}

install_neovim "$@"

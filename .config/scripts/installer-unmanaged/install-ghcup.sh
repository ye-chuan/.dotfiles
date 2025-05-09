#!/bin/bash

print_usage() {
    cat << EOF
Usage: $(basename "${BASH_SOURCE}") [OPTIONS]

Description:
  Installs GHCup (installs and manages GHC versions)

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
# Install GHCup
# Arguments:
#   --user / --system   : Type of install (--user default)
#   --root-ok           : Ok to install as --user for root user
# Returns:
#   0 if installed, non-zero on error.
#######################################
install_ghcup() {
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
        echo ">>> ERROR: SYSTEM installation of GHCup not yet supported" >&2
        return 1
    fi

    # USER Installation
    if [ "${is_root}" = true ] && [ "${is_root_ok}" = false ]; then
        echo ">>> ERROR: Do not run as root to install for user (add --root-ok flag to allow install for root user)" >&2
        return 1
    fi
    install_path="${HOME}/.local/opt/ghcup"
    echo ">>> Proceeding with USER installation of GHCup for: ${USER}"

    tempdir=$(mktemp -d -t "install-ghcup.XXXXXX")
    trap 'rm -rf "${tempdir}"' EXIT

    if [ -d "${install_path}" ]; then
        read -r -p ">>> $("${install_path}/bin/ghcup" --version) already installed at ${install_path}. Override [y/N]? " choice
        if ! [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo "Terminating..."
            return 0
        fi
    fi
    echo ">>> Installing latest GHCup"
    echo ""
    echo ">>> The following PGP Keys will be fetched from keyserver.ubuntu.com"
    echo ">>> 7D1E8AFD1D4A16D71FADA2F2CCC85C0E40C06A8C"
    echo ">>> FE5AB6C91FEA597C3B31180B73EDE9E8CFBAEF01"
    echo ">>> 88B57FCF7DB53B4DB3BFA4B1588764FBE22D19C4"
    echo ">>> EAF2A9A722C0C96F2B431CA511AAD8CEDEE0CAEF"
    read -r -p ">>> Are these 4 keys correct? (consider referring to https://www.haskell.org/ghcup/install/#manual-installation) [y/N]? " choice
    if [[ ! "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo ">>> ERROR: Revise PGP Keys Manually. Aborting..." >&2
        return 1
    fi

    gpg --no-default-keyring --keyring "${tempdir}/ghcup-keyring.pgp" --keyserver keyserver.ubuntu.com --recv-keys 7D1E8AFD1D4A16D71FADA2F2CCC85C0E40C06A8C
    gpg --no-default-keyring --keyring "${tempdir}/ghcup-keyring.pgp" --keyserver keyserver.ubuntu.com --recv-keys FE5AB6C91FEA597C3B31180B73EDE9E8CFBAEF01
    gpg --no-default-keyring --keyring "${tempdir}/ghcup-keyring.pgp" --keyserver keyserver.ubuntu.com --recv-keys 88B57FCF7DB53B4DB3BFA4B1588764FBE22D19C4
    gpg --no-default-keyring --keyring "${tempdir}/ghcup-keyring.pgp" --keyserver keyserver.ubuntu.com --recv-keys EAF2A9A722C0C96F2B431CA511AAD8CEDEE0CAEF

    # Fetching of the latest will be done by the latest stable binary that is given at the root index of /ghcup/
    echo ">>> Fetching latest x86_64-linux-ghcup from https://downloads.haskell.org/~ghcup/"
    curl -o "${tempdir}/x86_64-linux-ghcup" "https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup"

    # Fetching of checksum will be done by inferring the latest version from the download server and curling from within that directory
    # This will also check if our inference of the latest version corresponse with the actual latest version given at the root
    echo ">>> Inferring Latest Stable Version through curl & perl"
    version_list="$(curl -s https://downloads.haskell.org/~ghcup/ | perl -n -e 'if (/href="((?:[0-9]+\.)+[0-9]+)\/"/){print "$1\n"}')"
    latest_ver="$(echo "${version_list}" | sort --version-sort | tail -n 1)"
    read -r -p ">>> Latest Stable Version Inferred to be ${latest_ver} (check and press to continue...)"

    echo ">>> Fetching Checksum for version ${latest_ver}"
    curl -o "${tempdir}/ghcup-${latest_ver}-sha256sums" "https://downloads.haskell.org/~ghcup/${latest_ver}/SHA256SUMS"
    curl -o "${tempdir}/ghcup-${latest_ver}-sha256sums.sig" "https://downloads.haskell.org/~ghcup/${latest_ver}/SHA256SUMS.sig"

    echo ">>> Verifying Authenticity and Integrity of Checksums via GPG"
    if ! gpg --no-default-keyring --keyring "${tempdir}/ghcup-keyring.pgp" --verify "${tempdir}/ghcup-${latest_ver}-sha256sums.sig" "${tempdir}/ghcup-${latest_ver}-sha256sums"; then
        echo ">>> ERROR: CHECKSUM FILE NOT VERIFIED WITH THE PROPER SIGNATURES! Aborting..." >&2
        return 1
    fi
    echo ">>> Verifying Integrity of the ghcup binary"
    mv "${tempdir}/x86_64-linux-ghcup" "${tempdir}/x86_64-linux-ghcup-${latest_ver}"    # Temporarily rename to get the same output format on sha256sum
    if ! (cd "${tempdir}" && grep -e "./x86_64-linux-ghcup-${latest_ver}" "${tempdir}/ghcup-${latest_ver}-sha256sums" | sha256sum --check); then
        mv "${tempdir}/x86_64-linux-ghcup-${latest_ver}" "${tempdir}/x86_64-linux-ghcup"    # Revert name
        echo ">>> ERROR: BINARY INTEGRITY COMPROMISED! (Check if the version is correct) Aborting..." >&2
        return 1
    fi
    mv "${tempdir}/x86_64-linux-ghcup-${latest_ver}" "${tempdir}/x86_64-linux-ghcup"    # Revert name
    echo ">>> Binary Integrity and Authenticity Verified!"

    echo ">>> Removing old version at ${install_path}/ (if exists)"
    rm -rf "${install_path}"
    mkdir -p "${install_path}/bin/"
    echo ">>> Moving binary to ${install_path}/bin/ghcup"
    mv "${tempdir}/x86_64-linux-ghcup" "${install_path}/bin/ghcup"
    echo ">>> Setting executable permissions to the binary"
    chmod +x "${install_path}/bin/ghcup"

    # Add to path
    mkdir -p "${HOME}/.local/bin/"
    ln -s "${install_path}/bin/ghcup" "${HOME}/.local/bin/ghcup"
    setup_list_file_add "ghcup_setup.sh"
}

install_ghcup "$@"

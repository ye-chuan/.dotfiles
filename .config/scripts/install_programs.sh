#!/bin/bash
# Script to ease installation of packages in new systems (this script might not be portable to non-bash shells)

(( is_root = EUID == 0 ))   # Bash allows for c-style assignments in its (( ))
if (( !is_root )); then
    read -r -p "Not running as root, installation will be done locally (press to continue)"
fi

# TODO: Add support for other architecture / OS in the future?
if ! [[ "$(uname --kernel-name)" = "Linux" && "$(uname --processor)" = "x86_64" ]]; then
    echo ">>> ERROR: This installer is only written for x86_64 Linux"
    exit 1
fi


USERNAME="$(whoami)"
if (( is_root )); then
    USERNAME="${SUDO_USER}"
fi
# Get user's home directory from querying passwd file
USER_HOME=$(getent passwd "${USERNAME}" | cut --delimiter=: --fields=6)

if (( is_root )); then
    echo ">>> apt update & upgrade"
    apt-get update
    apt-get upgrade
    echo ""
fi

interactive_apt_install_frm_arr() {
    if (( !is_root )); then
        echo ">>> installation via apt requires root"
        return 1
    fi
    # $@ - array of packages
    package_list=("$@")

    while true; do
        echo "This package list contains the following"

        for id in "${!package_list[@]}"; do    # The ! in ${!package_list[@]} lets us iterate through the keys instead of values (note that all arrays in Bash are associative arrays)
            package="${package_list[${id}]}"
            echo "  [${id}] ${package}"
        done

        read -r -p "Install / Remove [y/N/0-9+]? " choice
        if [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then     # Non-POSIX compliant
            for package in "${package_list[@]}"; do
                echo ">>> Installing ${package}"
                apt-get -y install "${package}"
                echo ""
            done
            break
        elif [[ "${choice}" =~ ^([0-9]+)$ ]]; then
            unset "package_list[${choice}]"    # We simply unset this element (it becomes null and is ignored when iterating)
        elif [[ "${choice}" = "" ]] || [[ "${choice}" =~ ^([nN][oO]|[nN])$ ]]; then
            echo ""
            break
        fi
        echo ""
    done
}

# Compilers / Interpreteres
compilers_packages=("gcc" "g++" "python3" "make")
echo "[COMPILERS / INTERPRETERS]"
interactive_apt_install_frm_arr "${compilers_packages[@]}"

development_packages=("vim" "git")
echo "[DEVELOPMENT TOOLS]"
interactive_apt_install_frm_arr "${development_packages[@]}"

# Common Utilities
utilities_packages=("unzip" "pv" "ffmpeg")
echo "[COMMON UTILITIES]"
interactive_apt_install_frm_arr "${utilities_packages[@]}"

# Stupid Stuff
stupid_packages=("neofetch" "lolcat" "cowsay" "fortune" "espeak" "jp2a" "cbonsai" "hollywood" "cmatrix")
echo "[STUPID PACKAGES]"
interactive_apt_install_frm_arr "${stupid_packages[@]}"

# Non-Apt Installations
mkdir -p "${USER_HOME}/opt" # For local installation of standalone applications
tempdir="${USER_HOME}/.temp-installation"
rm -rf "${tempdir}"
mkdir --mode=700 "${tempdir}"  # To be deleted at the end of the script

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

# Support local installation
install_neovim() {
    if (( is_root )); then
        install_path="/opt/nvim"
        echo ">>> Proceeding with global installation of nvim"
    else
        install_path="${USER_HOME}/opt/nvim"
        echo ">>> Proceeding with local installation of nvim"
    fi

    if [ -d "${install_path}" ]; then
        read -r -p "$("${install_path}/bin/nvim" --version | head -n 1) already installed at ${install_path}/! Override [y/N]? " choice
        if ! [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo "Terminating..."
            return 0
        fi
    fi

    echo ">>> Installing Latest Stable Neovim from GitHub"
    echo ">>> Getting .tar from https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    curl -L -o "${tempdir}/nvim-linux-x86_64.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

    # Checksum Verification
    echo ">>> Getting SHA256 checksum from https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz.sha256sum"
    curl -L -o "${tempdir}/nvim-linux-x86_64.tar.gz.sha256sum" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz.sha256sum"
    if ! (cd "${tempdir}" && sha256sum --check "nvim-linux-x86_64.tar.gz.sha256sum"); then     # cd-ed in a subshell to get same output format for sha256sum
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

    if (( is_root )); then
        setup_list_file_add "neovim_setup.sh"
    else
        setup_list_file_add "neovim_setup_local.sh"
    fi
    echo ">>> NeoVim installed"
    echo ""
}

install_nvm() {
    if (( is_root )); then
        read -r -p ">>> Note: script currently only does local installation (press to continue)"
    fi
    NVM_DIR="${USER_HOME}/.nvm"
    if [[ -d "${NVM_DIR}" ]]; then
        read -r -p ">>> ${USER_HOME}/.nvm already exists, press to proceed with updating..."
        echo ">>> Fetching new updates from GitHub"
        sudo -u "${SUDO_USER}" git -C "${NVM_DIR}" fetch
    else
        echo ">>> Cloning from https://github.com/nvm-sh/nvm.git to ${NVM_DIR}"
        # Important to sudo if not root will own the local .nvm directory
        sudo -u "${SUDO_USER}" git clone https://github.com/nvm-sh/nvm.git "${NVM_DIR}"
    fi

    latest_ver_commit=$(git -C "${NVM_DIR}" rev-list --tags --max-count=1)   # Commit hash of the latest tag
    latest_tag=$(git -C "${NVM_DIR}" describe "${latest_ver_commit}")
    echo ">>> Latest Git Tag: ${latest_tag}"
    read -r -p ">>> Please confirm that the tag holds the latest version (press to proceed...)"
    echo ">>> Checkout out tag ${latest_tag}"
    sudo -u "${SUDO_USER}" git -C "${NVM_DIR}" checkout "${latest_tag}"

    source "${NVM_DIR}/nvm.sh"

    setup_list_file_add "nvm_setup.sh"
    echo ">>> nvm installed"
    echo ""
}

install_node() {
    echo ">>> Installing latest NodeJS will be done through NVM"
    if (( is_root )); then
        read -r -p ">>> Note: script currently only does local installation (press to continue)"
    fi
    if ! sudo -u "${SUDO_USER}" -i command -v nvm > /dev/null 2>&1; then
        read -r -p ">>> nvm not installed, press to proceed with installation..."
        if ! install_nvm; then  # Return if nvm installation fails
            echo ">>> NVM installation failed? Aborting NodeJS installation."
            return 1
        fi
    fi

    echo ">>> The current way of installing is to simply login to your shell to use your local nvm"
    echo ">>> Any artifacts from running a login shell will also be present (e.g. neofetch)"
    echo ">>> Installing latest release of NodeJS via nvm"
    sudo -u "${SUDO_USER}" -i nvm install node

    echo ">>> NodeJS installed"
    echo ""
}

install_ghcup() {
    if (( !is_root )); then
        read -r -p ">>> Note: Local installation of ghcup not supported yet (press to continue)"
        return 1
    fi

    install_path="/opt/ghcup"
    if [ -d "/opt/ghcup" ]; then
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
    fi

    gpg --homedir "${USER_HOME}" --no-default-keyring --keyring "${tempdir}/keyring.pgp" --keyserver keyserver.ubuntu.com --recv-keys 7D1E8AFD1D4A16D71FADA2F2CCC85C0E40C06A8C
    gpg --homedir "${USER_HOME}" --no-default-keyring --keyring "${tempdir}/keyring.pgp" --keyserver keyserver.ubuntu.com --recv-keys FE5AB6C91FEA597C3B31180B73EDE9E8CFBAEF01
    gpg --homedir "${USER_HOME}" --no-default-keyring --keyring "${tempdir}/keyring.pgp" --keyserver keyserver.ubuntu.com --recv-keys 88B57FCF7DB53B4DB3BFA4B1588764FBE22D19C4
    gpg --homedir "${USER_HOME}" --no-default-keyring --keyring "${tempdir}/keyring.pgp" --keyserver keyserver.ubuntu.com --recv-keys EAF2A9A722C0C96F2B431CA511AAD8CEDEE0CAEF

    # Fetching of the latest will be done by the latest stable binary that is given at the root index of /ghcup/
    echo ">>> Fetching latest x86_64-linux-ghcup from https://downloads.haskell.org/~ghcup/"
    curl -o "${tempdir}/x86_64-linux-ghcup" "https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup"

    # Fetching of checksum will be done by inferring the latest version from the download server and curling from within that directory
    # This will also check if our inference of the latest version corresponse with the actual latest version given at the root
    echo ">>> Inferring latest stable version through curl & awk"
    version_list="$(curl -s https://downloads.haskell.org/~ghcup/ | awk 'match($0, /href="(([0-9]+\.)+[0-9])\/"/, groups){print groups[1]}')"
    latest_ver="$(echo "${version_list}" | sort --version-sort | tail -n 1)"
    read -r -p ">>> Latest Stable Version Inferred to be ${latest_ver} (check and press to continue...)"

    echo ">>> Fetching Checksum for version ${latest_ver}"
    curl -o "${tempdir}/ghcup-${latest_ver}-sha256sums" "https://downloads.haskell.org/~ghcup/${latest_ver}/SHA256SUMS"
    curl -o "${tempdir}/ghcup-${latest_ver}-sha256sums.sig" "https://downloads.haskell.org/~ghcup/${latest_ver}/SHA256SUMS.sig"

    echo ">>> Verifying Authenticity and Integrity of Checksums via GPG"
    if ! gpg --no-default-keyring --keyring "${tempdir}/keyring.pgp" --verify "${tempdir}/ghcup-${latest_ver}-sha256sums.sig" "${tempdir}/ghcup-${latest_ver}-sha256sums"; then
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
    mkdir --parents "${install_path}/bin/"
    echo ">>> Moving binary to ${install_path}/bin/ghcup"
    mv "${tempdir}/x86_64-linux-ghcup" "${install_path}/bin/ghcup"
    echo ">>> Setting executable permissions to the binary"
    chmod +x "${install_path}/bin/ghcup"

    setup_list_file_add "ghcup_setup.sh"
}

install_ghc() {
    echo ">>> Installation of GHC will be done through GHCup"
    echo ">>> Some dependencies include: make"
    if (( is_root )); then
        read -r -p ">>> Installation is done on a local level (press to continue)"
    fi

    ghcup="/opt/ghcup/bin/ghcup"
    if ! command -v "${ghcup}" > /dev/null 2>&1; then
        read -r -p ">>> GHCup doesn't exist! (press to proceed with installing...)"
        if ! install_ghcup; then    # Return if GHCup installation fail
            echo ">>> GHCup installation failed? Aborting ghc installation."
            return 1
        fi
    fi

    source ~/.bashrc

    echo ">>> Installing recommended GHC via GHCup (installing for user [${USERNAME}] only)"
    sudo --user="${USERNAME}" "${ghcup}" install ghc --set
}

# List of Program: Installation Function Mappings
declare -A non_apt
non_apt["Neovim (be sure to also install npm for plugin dependencies)"]="install_neovim"
non_apt["NodeJS (using nvm; comes with npm)"]="install_node"
non_apt["GHC (Haskell Compiler; installed using GHCup)"]="install_ghc"

echo "[[NON APT-GET INSTALLATIONS]]"
for program in "${!non_apt[@]}"; do
    read -r -p "Install ${program} [y/N]? " choice
    if [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        "${non_apt["${program}"]}"
    fi
done


# Manual Installation
echo "Installation Process Ended!"
echo ""
echo "You might also want to manually install the following"
echo "  openjdk-{VERSION}-jdk-headless (Latest ver. number needs to be manually specified in package name)"

echo ""
echo "Remember to source .bashrc again to run any necessary setup scripts!"

rm -rf "${tempdir}"

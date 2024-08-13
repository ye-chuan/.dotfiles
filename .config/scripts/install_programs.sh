#!/bin/bash
# Script to ease installation of packages in new systems (this script might not be portable to non-bash shells)

if [ $EUID -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

USER_HOME="/home/${SUDO_USER}"

echo ">>> apt update & upgrade"
apt-get update
apt-get upgrade
echo ""

interactive_apt_install_frm_arr() {
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
compilers_packages=("gcc" "python3")
echo "[COMPILERS / INTERPRETERS]"
interactive_apt_install_frm_arr "${compilers_packages[@]}"

# Common Utilities
utilities_packages=("unzip" "pv" "ffmpeg")
echo "[COMMON UTILITIES]"
interactive_apt_install_frm_arr "${utilities_packages[@]}"

# Stupid Stuff
stupid_packages=("neofetch" "lolcat" "cowsay" "fortune" "espeak" "jp2a" "cbonsai" "hollywood" "cmatrix")
echo "[STUPID PACKAGES]"
interactive_apt_install_frm_arr "${stupid_packages[@]}"

# Non-Apt Installations
tempdir="${USER_HOME}/.temp-installation"
rm -rf "${tempdir}"
mkdir "${tempdir}"  # To be deleted at the end of the script

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

install_neovim() {
    if [ -d "/opt/nvim-linux64" ]; then
        read -r -p "$(/opt/nvim-linux64/bin/nvim --version | head -n 1) already installed at /opt/nvim-linux64! Override [y/N]? " choice
        if ! [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo "Terminating..."
            return 0
        fi
    fi

    echo ">>> Installing Latest Stable Neovim from GitHub"
    echo ">>> Getting .tar from https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
    curl -L -o "${tempdir}/nvim-linux64.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"

    # Checksum Verification
    echo ">>> Getting SHA256 checksum from https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz.sha256sum"
    curl -L -o "${tempdir}/nvim-linux64.tar.gz.sha256sum" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz.sha256sum"
    if ! (cd "${tempdir}" && sha256sum "nvim-linux64.tar.gz") | diff "${tempdir}/nvim-linux64.tar.gz.sha256sum" -; then     # cd-ed in a subshell to get same output format for sha256sum
        echo ">>> WARNING: Checksum verification failed!" >&2
        echo ">>> Terminating..."
        return 0
    fi
    echo -n ">>> SHA256 Checksum Verified: "
    sha256sum "${tempdir}/nvim-linux64.tar.gz"

    echo ">>> Removing old version at /opt/nvim-linux64 (if exists)"
    rm -rf /opt/nvim-linux64
    echo ">>> Extracting into /opt/nvim-linux64"
    tar -C /opt -xzf "${tempdir}"/nvim-linux64.tar.gz

    setup_list_file_add "neovim_setup.sh"
    echo ">>> NeoVim installed"
    echo ""
}

install_nvm() {
    NVM_DIR="${USER_HOME}/.nvm"
    if [[ -d "${NVM_DIR}" ]]; then
        read -r -p ">>> ${USER_HOME}/.nvm already exists, press to proceed with updating..."
        echo ">>> Fetching new updates from GitHub"
        git -C "${NVM_DIR}" fetch
    else
        echo ">>> Cloning from https://github.com/nvm-sh/nvm.git to ${NVM_DIR}"
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

install_node() {
    echo ">>> Installing latest NodeJS will be done through NVM"
    if ! command -v nvm > /dev/null 2>&1; then
        read -r -p ">>> nvm not installed, press to proceed with installation..."
        install_nvm
    fi

    echo ">>> Installing latest release of NodeJS via nvm"
    nvm install node

    echo ">>> NodeJS installed"
    echo ""
}

# List of Program: Installation Function Mappings
declare -A non_apt
non_apt["Neovim (be sure to also install npm for plugin dependencies)"]="install_neovim"
non_apt["NodeJS (using nvm; comes with npm)"]="install_node"

echo "[[NON APT-GET INSTALLATIONS]]"
for program in "${!non_apt[@]}"; do
    read -r -p "Install ${program}[y/N]? " choice
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

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
setup_list_file="${USER_HOME}/.config/shell/.prgm_setup_list"
if [[ ! -f "${setup_list_file}" ]]; then    # Create the list of programs to setup in .bashrc
    echo "${USER_HOME}/.config/scripts/program_setups/" > "${setup_list_file}"  # First line of this list just denote where to find the setup scripts
fi

tempdir="${USER_HOME}/.temp-installation"
rm -rf "${tempdir}"
mkdir "${tempdir}"  # To be deleted at the end of the script

install_neovim() {
    if [ -d "/opt/nvim-linux64" ]; then
        read -r -p "NeoVim already installed at /opt/nvim-linux64! Override [y/N]? " choice
        if ! [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo "Terminating..."
            return 0
        fi
    fi

    echo ">>> Installing Latest Stable Neovim from GitHub"
    echo ">>> Getting .tar from https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
    curl -L -o "${tempdir}"/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    echo ">>> Removing old version at /opt/nvim-linux64 (if exists)"
    rm -rf /opt/nvim-linux64
    echo ">>> Extracting into /opt/nvim-linux64"
    tar -C /opt -xzf "${tempdir}"/nvim-linux64.tar.gz

    # Append setup to run in .bashrc
    if grep "^neovim_setup.sh$" "${setup_list_file}" > /dev/null; then
        echo ">>> neovim_setup.sh already exists in ${setup_list_file}"
    else
        echo ">>> Adding neovim_setup.sh to ${setup_list_file} for .bashrc to source"
        echo "neovim_setup.sh" >> "${setup_list_file}"
    fi
}

# List of Program: Installation Function Mappings
declare -A non_apt
non_apt["Neovim"]="install_neovim"

echo "[[NON APT-GET INSTALLATIONS]]"
for program in "${!non_apt[@]}"; do
    read -r -p "Install ${program}[y/N]? " choice
    if [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then     # Non-POSIX compliant
        "${non_apt["${program}"]}"
    fi
done


# Manual Installation
echo ""
echo "You might also want to manually install the following"
echo "  nvm (Install from GitHub; For installing NodeJS)"
echo "  node (Latest ver. not in Ubuntu's repo; Install via nvm; For NeoVim LSP Support)"
echo "  openjdk-{VERSION}-jdk-headless (Latest ver. number needs to be manually specified in package name)"

rm -rf "${tempdir}"

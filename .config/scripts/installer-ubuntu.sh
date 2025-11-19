#!/bin/bash
# Script to ease installation of packages in new systems (this script might not be portable to non-bash shells)

script_dir=$(dirname -- "$(readlink --canonicalize -- "${BASH_SOURCE[0]}")")
installer_unmanaged_dir="${script_dir}/installer-unmanaged"

source "${installer_unmanaged_dir}/check-x86_64.sh"

is_root=false
if [ "$EUID" -eq 0 ]; then
    is_root=true
fi

if [ "${is_root}" = false ]; then
    echo ">>> ERROR: This script needs to be ran as root"
    exit 1
fi

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

# Compilers / Interpreters
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


# Manual Installation
read -r -p ">>> Skip SYSTEM Installations of non-system-managed packages [Y/n]? " choice
if ! [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    "${installer_unmanaged_dir}/installer-unmanaged" --system
fi

if [ -z ${SUDO_UID} ]; then
    echo ">>> Skipping USER Installations of non-system-managed packages:"
    echo ">>>   No sudo user found, non-system-managed packages for will not be installed for root user."
else
    read -r -p ">>> Skip USER Installations for non-system-managed packages for user: ${SUDO_USER} [Y/n]? " choice
    if ! [[ "${choice}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo ""
        sudo --login --user="${SUDO_USER}" -- "${installer_unmanaged_dir}/installer-unmanaged" --user
    fi
fi

echo "Installation Process Ended!"
echo ""
echo "You might also want to manually install the following"
echo "  openjdk-{VERSION}-jdk-headless (Latest ver. number needs to be manually specified in package name)"

echo ""
echo "Remember to source .bashrc again to run any necessary setup scripts!"

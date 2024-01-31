#!/bin/bash
# Script to ease installation of packages in new systems (this script might not be portable to non-bash shells)

apt-get update
apt-get upgrade
echo ""

interactive_install_frm_arr() {
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
            for package in ${package_list[@]}; do
                echo "[[Installing ${package}]]"
                apt-get -y install "${package}"
                echo ""
            done
            break
        elif [[ "${choice}" =~ ^([0-9]+)$ ]]; then
            unset package_list["${choice}"]    # We simply unset this element (it becomes null and is ignored when iterating)
        elif [[ "${choice}" = "" ]] || [[ "${choice}" =~ ^([nN][oO]|[nN])$ ]]; then
            break
        fi
        echo ""
    done
}

# Compilers / Interpreteres
compilers_packages=("gcc" "python3")
echo "[COMPILERS / INTERPRETERS]"
interactive_install_frm_arr "${compilers_packages[@]}"

# Common Utilities
utilities_packages=("unzip" "pv" "ffmpeg")
echo "[COMMON UTILITIES]"
interactive_install_frm_arr "${utilities_packages[@]}"

# Stupid Stuff
stupid_packages=("neofetch" "lolcat" "cowsay" "fortune" "espeak" "jp2a" "cbonsai" "hollywood" "cmatrix")
echo "[STUPID PACKAGES]"
interactive_install_frm_arr "${stupid_packages[@]}"


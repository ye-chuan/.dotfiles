#!/bin/bash
# This script can be sourced to quickly check if the machine is Linux
# and x86_64, otherwise it halts the installation.
#
# This is supposed to be a temporary check until the installation
# script supports other architectures / OS.

if ! [[ "$(uname --kernel-name)" = "Linux" && "$(uname --machine)" = "x86_64" ]]; then
    echo ">>> ERROR: This installer is only written for x86_64 Linux"
    exit 1
fi



#!/bin/bash

# TODO: Add support for other architecture / OS in the future?
if ! [[ "$(uname --kernel-name)" = "Linux" && "$(uname --processor)" = "x86_64" ]]; then
    echo ">>> ERROR: This installer is only written for x86_64 Linux"
    exit 1
fi



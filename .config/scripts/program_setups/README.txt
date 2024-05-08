The files here are meant to be sourced by .bashrc for initialising external programs that are "manually installed" (without a package manager like apt)

Scripts here usually includes simple things like adding the program to PATH, or adding Bash autocompletion.

Not all scripts will be sourced by .bashrc, ideally only programs that are installed.
The list of scripts that will be sourced should live in $HOME/.config/shell/.prgm_setup_list

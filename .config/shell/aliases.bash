SHELL_CONFIG="$HOME/.config/shell"
source "$SHELL_CONFIG/aliases.sh"     # General POSIX aliases

# Python Virtual Environment
# Virtual Environements should be stored in ~/.venv/
_pyvenv_dir="${HOME}/.venv"
pyvenv(){
    source "${_pyvenv_dir}/${1}/bin/activate"
}
_comp_pyvenv() {
    cur_word="$2"
    # Listing directories & filtering valid completions
    # for the current word can be done via `compgen`
    readarray -t arr < <(compgen -d "${_pyvenv_dir}/${cur_word}")

    # To list just the base name of the 
    # directories instead of full path
    for i in "${!arr[@]}"; do
        arr[i]="$(basename "${arr[i]}")"
    done

    COMPREPLY=( "${arr[@]}" )

}
complete -o filenames -F _comp_pyvenv pyvenv


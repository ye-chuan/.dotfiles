SHELL_CONFIG="$HOME/.config/shell"
source "$SHELL_CONFIG/aliases.sh"     # General POSIX aliases

# Python Virtual Environment
_pyvenv_dir="${HOME}/.venv"
pyvenv(){
    if [ -n "${1}" ]; then      # Named venv
        # Named venvs should be stored globally in ~/.venv/
        source "${_pyvenv_dir}/${1}/bin/activate"
        return $?
    fi

    # Unnamed venv would be activating by going up the directory tree until
    # the first .venv directory exists (expect ~/.venv which is a special
    # directory with a bunch of named venvs)
    # These unnamed .venv are local per-project venvs (as created by uv)
    local cur_dir
    cur_dir="$(pwd)"
    # Traverse up till home (exclusive)
    while [ "${cur_dir}" != "$HOME" ] && [ ! -d "${cur_dir}/.venv" ]; do
        cur_dir=$(dirname "${cur_dir}")
    done
    if [ "${cur_dir}" != "$HOME" ]; then
        source "${cur_dir}/.venv/bin/activate"
        return 0
    fi
    # No .venv in ancestors
    echo "Error: Python virtual environment not found." >&2
    return 1
}
_comp_pyvenv() {
    local cur_word="$2"
    # Listing directories & filtering valid completions
    # for the current word can be done via `compgen`
    local arr
    readarray -t arr < <(compgen -d "${_pyvenv_dir}/${cur_word}")

    # To list just the base name of the 
    # directories instead of full path
    for i in "${!arr[@]}"; do
        arr[i]="$(basename "${arr[i]}")"
    done

    COMPREPLY=( "${arr[@]}" )

}
complete -o filenames -F _comp_pyvenv pyvenv


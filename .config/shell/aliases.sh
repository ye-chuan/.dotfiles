## General Aliases and Functions

# DotFiles Management
alias mydotfiles='git -C $HOME --git-dir=.dotfiles --work-tree=.'

# Mini Helpers
alias view='nvim -R'

# Colour Support
alias ls='ls --color=auto'          # Colors based on file type (e.g. directories etc)
alias grep='grep --color=auto'      # Colors pattern matches for grep
#alias fgrep='fgrep --color=auto'   # Use `grep -F` instead
#alias egrep='egrep --color=auto'   # Use `grep -E` instead
alias ip='ip --color=auto'

alias la='ls -a'
alias ll='ls -l'

# Safety
alias mv='mv -i'
alias cp='cp -i'

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

# Local Aliases
source "${HOME}/.local-config/aliases.sh"

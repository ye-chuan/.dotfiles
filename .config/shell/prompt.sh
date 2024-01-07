# Covered in `man bash` under "PROMPTING" section
## Generate Escape Sequences with `tput` (see `man infoterm`)
# Standard Colours
RED="\[$(tput setaf 1)\]"       # Note that "" string allows for parameter expansion, '' strings are raw (initialised without expansion)
GREEN="\[$(tput setaf 2)\]"
YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
MAGENTA="\[$(tput setaf 5)\]"
CYAN="\[$(tput setaf 6)\]"
WHITE="\[$(tput setaf 7)\]"
# Others
RESET="\[$(tput sgr0)\]"
BOLD="\[$(tput bold)\]"
ITALICS="\[$(tput sitm)\]"
UNITALICS="\[$(tput ritm)\]"

has_git_cmd="$(command -v git > /dev/null 2>&1 && echo true || echo false)"     # Sets to either "true"/"false" which can be used directly later to invoke i.e. /usr/bin/true for a 0 exit code

# ret status 0 - In Git Repo Worktree (echos current branch)
is_in_git_tree () {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1
    return $?
}

### START OF GIT FUNCTIONS (Functions here assumes we are in Git Repo)
_get_git_branch () {
    git branch 2>/dev/null | sed -e '/^*/!d' -e 's/* \(.*\)/\1/'
}
# Returns a "path/in/repo/" without the repo's root
_git_rel_path_wo_root () {
    git rev-parse --show-prefix 2> /dev/null
}
_git_local_repo_name () {
    basename "$(git rev-parse --show-toplevel)" 2> /dev/null
}
# ret status 0 - Merging
# ret status !0 - Not Mergin
_is_git_merging () {
    # Simply check if the MERGE_HEAD reference exists
    git rev-parse -q --verify MERGE_HEAD > /dev/null 2>&1   # Though -q shouldn't output any errors but we will redirect &2 just in case
    return $?
}
# echo - number of unmerged paths
_git_num_unmerged () {
    unmerged="$(git status --porcelain=2 2> /dev/null | grep -c '^u')"
    echo "${unmerged:-0}"
}
# echo - number of stashes
_git_num_stash () {
    # Extracts "# stash {number of stashes}" from `git status --show-stash --porcelain=2`
    stashes=$(git status --show-stash --porcelain=2 2> /dev/null | sed -e '/# stash/!d' -e 's/# stash \([0-9]\+\)/\1/')
    echo "${stashes:-0}"
}
### END OF GIT FUNCTIONS

# Picks which prompt to use (do not echo in here, all prompt echos should go into PS1 so that Bash knows how to position the cursor)
_prompt_mux () {
    local prompt=''
    ## Emit OSC 7 (to advice terminals like WezTerm on changes to the cwd if any)
    prompt+='\e]7;file://localhost/${PWD}\e\\'  # Uses $PWD instead of PS1's \w because \w abbreviates $HOME to ~ which is not re-expanded by e.g. WezTerm

    ## Git Prompt
    if $has_git_cmd && is_in_git_tree; then
        prompt+="${BLUE}\u"  # Username
        prompt+="${RESET}@${BLUE}\H:"  # Hostname

        # Git relative path (bold repo's root)
        local path_wo_repo="$(_git_rel_path_wo_root)"
        local local_repo_name="$(_git_local_repo_name)"
        if [ -n "$path_wo_repo" ]; then     # Remove trailing slash and add the slash between
            path_wo_repo="${path_wo_repo:0:-1}"
            local_repo_name="${local_repo_name}/"
        fi
        prompt+="${RESET}${BOLD}${local_repo_name}${RESET}${RESET}${path_wo_repo}"

        # Git Branch
        local branchname="$(_get_git_branch)"
        branchname="${branchname:-${ITALICS}[no branch]}${NOITALICS}"   # If branch doesn't exist yet (no commits)
        prompt+="${MAGENTA}  $branchname"

        # Merge Status
        if _is_git_merging; then
            prompt+="${RED} 󰽜 $(_git_num_unmerged)"  # Git Branch
        fi

        # Stashes
        local num_stashes="$(_git_num_stash)"
        if [ "${num_stashes}" -gt 0 ]; then
            prompt+="${RED}  $(_git_num_stash)"
        fi
        prompt+="\n${GREEN} "   # Command start at the next line
        prompt+="${RESET}"
    else
        # Standard Prompt
        prompt+="${BLUE}\u"  # Username
        prompt+="${RESET}@${BLUE}\H:"  # Hostname
        prompt+="${RESET}\w"  # Full Path
        prompt+="\n${GREEN} "   # Command start at the next line
        prompt+="${RESET}"
    fi

    PS1="$prompt"
}

# Note that dynamic function calls in PS1 needs to be '$(func)' so that it is saved literally into PS1 and expanded everytime
# the prompt is displayed (Using "$(func)" will cause the function to be expanded only once during the initialisation of the string)
PROMPT_COMMAND="_prompt_mux"

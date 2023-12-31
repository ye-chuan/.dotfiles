# My DotFiles

The dotfiles here are being version-controlled and synced with with a bare git repository named `.dotfiles`

Basically, the working tree will be our home directory (`$HOME`) for convenience, and the Git-Directory would be the `.dotfiles` bare repo.

My dotfiles will try to be as **XDG compliant** as possible, so unless a program does not support XDG Base Directories, all user config files will be stored in `$XDG_CONFIG_HOME` which I will take as the default `$HOME/.config`

## Initialisation
Honestly, the fact that the repo was initialised as bare doesn't matter as much as how we clone and interact with it.

An example of initially setting up this bare repo is as follows
```sh
git init --bare $HOME/.dotfiles
```

## Cloning
Git doesn't allow cloning into a non-empty directory (which $HOME usually is), we will need to clone into a temporary directory first
```sh
git clone --recursive --separate-git-dir=$HOME/.dotfiles git@github.com:ye-chuan/.dotfiles.git .dotfiles.temp
```
`--recursive` will also clone all the submodules

`--separate-git-dir` means Git will put all the files originally in `.git` into `.dotfiles`, then have a **file** (not directory) named `.git` within the worktree (`.dotfiles.temp` in this case) which contains a link to the separate Git-Directory.

So we now move the temporary worktree over to our home directory, excluding the `.git` file (we do not need it since we will be running git with the alias mentioned above)

```sh
rsync --recursive --verbose --exclude .git $HOME/.dotfiles.temp $HOME
```
The `mv` command might echo an warning if either of the globs fail (say if we have no hidden files, then `$HOME/.dotfiles.temp/.[^.]*` which matches all hidden files apart from `..` and `.` will fail)
This doesn't stop the command from still moving all non-hidden files over but if it is annoying we can turn the warning off with `shopt -s nullglob`

Remember to delete the temporary worktree,
```sh
rmdir $HOME/.dotfiles.temp
```

## Configuration
After cloning, these are some QOL local configurations

### Alias
Interactive with this bare repo can be simplified with an alias
```sh
alias mydotfiles="git -C $HOME --git-dit=.dotfiles --work-tree=."
```
So typing `mydotfiles` should give the same action as typing `git` in a normal repository

> The presense of submodules is why -C is required: if we are not `cd` into a worktree, submodule commands will fail

### Hide Untracked Files
We can stop Git from informing us on all the untracked files in the home direcotry by default with
```sh
mydotfiles config status.showUntrackedFiles no
```

To temporarily see the untracked files we can use the `-unormal` flag as in
```sh
mydotfiles status -unormal
```
or for the more detailed view,
```sh
mydotfiles status -uall
```

## New Machine Notes
### Programs to Install
- WezTerm
    - For a nice terminal of course
- NeoVim
    - Duh!
    - Latest version required (check plugins for supported versions)
    - Stable distros might not have the latest, AppPackage is the simplest way to install the latest
- NodeJS
    - For `npm` and the **latest** NodeJS so that the LSP's used in NeoVim can work
    - Stable distros might not have the latest, installing and using `nvm` to install and manage NodeJS version is recommended

# My DotFiles

The dotfiles here are being version-controlled and synced with a bare git repository named `.dotfiles`

Basically, the working tree will be our home directory (`$HOME`) for convenience, and the Git-Directory will be the `.dotfiles` bare repo.

My dotfiles will try to be as **XDG compliant** as possible, so unless a program does not support XDG Base Directories, all user config files will be stored in `$XDG_CONFIG_HOME` which I will take as the default `$HOME/.config`

## Initialisation
Honestly, the fact that the repo was initialised as bare doesn't matter as much as how we clone and interact with it.

An example of initially setting up this bare repo is as follows
```sh
git init --bare $HOME/.dotfiles
```

Interaction with this bare repo can be simplified with an alias
```sh
alias mydotfiles="git -C $HOME --git-dir=.dotfiles --work-tree=."
```
So typing `mydotfiles` should give the same action as typing `git` in a normal repository

> The presence of submodules is why -C is required: if we are not `cd`-ed into a work-tree, submodule commands will fail

## Cloning
Git doesn't allow cloning into a non-empty directory (which $HOME usually is), we will need to clone into a temporary directory first
```sh
git clone --separate-git-dir=$HOME/.dotfiles git@github.com:ye-chuan/.dotfiles.git .dotfiles.temp
```

`--separate-git-dir` means Git will put all the files originally in `.git` into `.dotfiles`, then have a **file** (not directory) named `.git` within the work-tree (`.dotfiles.temp` in this case) which contains a link to the separate Git-Directory.

> Though `--recursive` will clone all the submodules, we won't do this now since this is just a temporary directory.

So we now move the temporary work-tree over to our home directory, excluding the `.git` file (we do not need it since we will be running git with the alias mentioned above)

```sh
rsync --archive --verbose --exclude '.git' $HOME/.dotfiles.temp/ $HOME/
```
The trailing `/` after `.dotfiles.temp` is important, otherwise the directory `.dotfiles.temp` will be copied as a whole directory instead of its contents.

> We could also use `mv`, but it might echo a warning if either of the globs fails (say if we have no hidden files, then `$HOME/.dotfiles.temp/.[^.]*` which matches all hidden files apart from `..` and `.` will fail)
> This doesn't stop the command from moving all non-hidden files over but if it is annoying we can turn the warning off with `shopt -s nullglob`

Source `.bashrc` to get the `mydotfiles` alias, then run the following to get the submodules in
```sh
mydotfiles submodule init
```
and
```sh
mydotfiles submodule update
```

Remember to delete the temporary work-tree,
```sh
rm -rf $HOME/.dotfiles.temp
```

## Optional Configuration
After cloning, these are some QOL local configurations

### Hide Untracked Files
We can stop Git from informing us on all the untracked files in the home directory by default with
```sh
mydotfiles config status.showUntrackedFiles no
```

To temporarily see the untracked files we can use the `-unormal` flag as in
```sh
mydotfiles status -unormal
```
or for a more detailed view,
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

### Environmental Variables
This is especially for Windows to share locations (e.g. config locations) with Linux.
- `XDG_CONFIG_HOME` = `%userprofile%\.config` (For Windows, Linux already follows the convention of storing configs in `~/.config`)

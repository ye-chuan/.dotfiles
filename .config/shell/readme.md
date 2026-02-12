The file extensions here states the shell that the file is configuration for.
The .sh extension are for config that can be sourced by any POSIX-compliant shell.

For multiple scripts with the same name (different extension), my system is for only the one with the more specific extension to run.
Feel free to source the other script with a more generic extension in the more specific script.

e.g. With `config.bash` and `config.sh`. My implementation is for Bash to **only** source `config.bash`, which *might* in turn source `config.sh`

For reference:
- `.bashrc` is meant for **interactive** Bash Shells
- `.bash_profile` is meant for Bash **Login** Shells
    - In my setup, this will also source from the generic `.profile`
    - It is also common to source `.bashrc` from here since most login shells are used interactively
    (Source: [Arch Wiki](https://wiki.archlinux.org/title/Bash) on `~/.bash_profile`: The skeleton file /etc/skel/.bash_profile also sources ~/.bashrc.)

- `.profile` is means for **Login Shells** (generic)
    - **Environment variables** are conventionally placed in here instead so all shells that sources `.profile` can use it
    - My current set up involves starting my desktop environment from the login tty, hence `.profile` will be indirectly sourced by my GUI desktop environment


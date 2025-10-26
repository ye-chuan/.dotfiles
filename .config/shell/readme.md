The file extensions here states the shell that the file is configuration for.
The .sh extension are for config that can be sourced by any POSIX-compliant shell.

e.g. Bash might source `config.bash`, which in turn might also source `config.sh`

For reference:
- `.bashrc` is meant for **interactive** Bash Shells
- `.bash_profile` is meant for Bash **Login** Shells
    - In my setup, this will also source from the generic `.profile`
    - It is also common to source `.bashrc` from here since most login shells are used interactively
    (Source: [Arch Wiki](https://wiki.archlinux.org/title/Bash) on `~/.bash_profile`: The skeleton file /etc/skel/.bash_profile also sources ~/.bashrc.)

- `.profile` is means for **Login Shells** (generic)
    - **Environment variables** are conventionally placed in here instead so all shells that sources `.profile` can use it
    - My current set up involves starting my desktop environment from the login tty, hence `.profile` will be indirectly sourced by my GUI desktop environment


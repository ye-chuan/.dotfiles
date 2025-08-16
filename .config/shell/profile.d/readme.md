This will be the user's .profile drop in directory (much like /etc/profile.d/ for /etc/profile).

Because .profile is sourced by all shells, all scripts here that is to be sourced should be POSIX compatible and suffixed with `.sh`

~/.profile should source all `*.sh` files in this directory.

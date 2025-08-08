FROM ubuntu:latest

ENV TZ=Asia/Singapore

RUN yes | unminimize

RUN apt-get update && \
    apt-get install -y \
    sudo \
    man-db \
    manpages \
    locales \
    ntp \
    less \
    iproute2 \
    iputils-ping \
    wget \
    curl \
    zip \
    unzip \
    file \
    git \
    rsync \
    build-essential \
    python3 \
    software-properties-common \
    vim \
    htop \
    bash-completion \
    tmux

# deadsnakes PPA for other Python versions
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get update

# Locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

## User
# Ubuntu image has a default non-root `ubuntu` user which we will "rename"
RUN userdel --remove ubuntu && \
    useradd --shell /bin/bash --groups sudo --create-home dev && \
    echo "dev:pw" | chpasswd

USER dev
WORKDIR /home/dev

# My dotfiles (with vim/nvim plugins)!
RUN git clone --separate-git-dir=$HOME/.dotfiles https://github.com/ye-chuan/.dotfiles.git .dotfiles.temp && \
    rsync --archive --verbose --exclude '.git' "$HOME/.dotfiles.temp/" "$HOME/" && \
    mydotfiles(){ git -C "$HOME" --git-dir=.dotfiles --work-tree=. "$@"; } && \
    mydotfiles submodule init && \
    mydotfiles submodule update && \
    rm -rf "$HOME/.dotfiles.temp"

RUN touch .sudo_as_admin_successful     # Supresses sudo instructions

## Installing USER packages via scripts in .mydotfiles
RUN mkdir -m 700 "$HOME/.gnupg" && \
    yes | "${HOME}/.config/scripts/installer-unmanaged/install-node.sh" --user && \
    yes | "${HOME}/.config/scripts/installer-unmanaged/install-ghc.sh" --user
# mkdir .gnupg for gpg (dirmngr complains if directory doesn't exists and it only creates it when running dirmngr in the foreground for the first time)


## Installing SYSTEM packages via scripts in .mydotfiles
USER root
RUN yes | "/home/dev/.config/scripts/installer-unmanaged/install-neovim.sh" --system

## To go through the login process (`su` works like the
# `login` command to set $USER, $LOGNAME, etc)
ENTRYPOINT ["su", "-", "dev"]

#!/usr/bin/env bash

set -ue

# Colors
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

success() {
  echo -e "\n${COLOR_GREEN}$1${COLOR_NONE}"
}

info() {
  echo -e "\n${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

headline() {
  echo -e "\n${COLOR_GRAY}==============================${COLOR_NONE}"
  echo -e "${COLOR_PURPLE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

warning() {
  echo -e "\n${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

error() {
  echo -e "\n${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

has() {
  type "$1" > /dev/null 2>&1
}

DOT_BASE=$HOME/dotfiles
DOT_TARBALL=https://github.com/ryu-461/dotfiles/tarball/main
DOT_REMOTE=https://github.com/ryu-461/dotfiles.git

headline "Welcome dotfiles installation!!"
read -p "This script will install and deploy the various packages. Are you sure you want to continue? [y/N] " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  info "The installation has been canceled. There is nothing to do. "
  exit 1
fi
info "Start Installation."
cd $HOME
if [[ -d $HOME/dotfiles ]]; then
  read -p "The dotfiles already exists. Do you want to update them? [y/N] " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    info "Updating the dotfiles..."
    cd $DOT_BASE
    git pull origin main
  else
    info "There is nothing to do."
  fi
  exit 1
fi

if [[ $(uname) == 'Darwin' ]]; then
  echo "Your environment is a Mac, Start deployment for macOS."
    # Clone dotfile repository locally
  if [[ ! -d $HOME/dotfiles ]]; then
    echo "Cloning the dotfiles repository..."
    git clone $DOT_REMOTE
  fi
  # Run install script
  source $DOT_BASE/install-scripts/install-mac.sh
elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  echo "Your environment is a Windows Subsystem for Linux, Start deployment for WSL."
  # Clone dotfile repository locally
  if [[ ! -d $HOME/dotfiles ]]; then
    if has "git"; then
      info "Cloning the dotfiles repository..."
      git clone $DOT_REMOTE
    else
      curl -fsSLo $HOME/dotfiles.tar.gz $DOT_TARBALL
      tar -zxf $HOME/dotfiles.tar.gz --strip-components 1 -C $HOME/dotfiles
      rm -f $HOME/dotfiles.tar.gz
    fi
  fi
  cd $DOT_BASE
  # Run install script
  source $DOT_BASE/install-scripts/install-wsl.sh
elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
  echo "Your environment is a Linux, Start deployment for Linux."
  # Clone dotfile repository locally
  if [[ ! -d $HOME/dotfiles ]]; then
    if has "git"; then
      info "Cloning the dotfiles repository..."
      git clone $DOT_REMOTE
    else
      curl -fsSLo $HOME/dotfiles.tar.gz $DOT_TARBALL
      tar -zxf $HOME/dotfiles.tar.gz --strip-components 1 -C $HOME/dotfiles
      rm -f $HOME/dotfiles.tar.gz
    fi
  fi
  cd $DOT_BASE
  # Run install script
  if [[ $(uname -o) == 'Android' ]]; then
    source $DOT_BASE/install-scripts/install-termux.sh
  else
    source $DOT_BASE/install-scripts/install-linux.sh
  fi
else
  exit 1
fi
success "Installation complete."

success "Done. Happy Hacking!!"
#!/usr/bin/env bash

set -ue

# Colors
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}\n"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

headline() {
  echo -e "\n${COLOR_GRAY}==============================${COLOR_NONE}"
  echo -e "${COLOR_BLUE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}"
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

has() {
  type "$1" > /dev/null 2>&1
}

DOT_BASE=$HOME/dotfiles
DOT_TARBALL=https://github.com/ryu-461/dotfiles/tarball/main
DOT_REMOTE=https://github.com/ryu-461/dotfiles.git

headline "Welcome dotfiles installation!"
read -p "This script will install and deploy the various packages. Are you sure you want to continue? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  info "The installation has been canceled. There is nothing to do. "
  exit 1
fi
info "Start Installation."
cd $HOME
if [[ -d $HOME/dotfiles ]]; then
  read -p "The dotfiles already exists. Do you want to update them? [y/N] " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    info "Updating the dotfiles..."
    cd $DOT_BASE
    git pull origin main
  else
    info "There is nothing to do."
  fi
  exit 1
fi

# Clone dotfile repository locally
if [[ ! -d $HOME/dotfiles ]]; then
  headline "Clone dotfiles"
  if has "git"; then
    info "Cloning the dotfiles repository..."
    git clone $DOT_REMOTE
  else
    curl -fsSLo $HOME/dotfiles.tar.gz $DOT_TARBALL
    tar -zxf $HOME/dotfiles.tar.gz --strip-components 1 -C $HOME/dotfiles
    rm -f $HOME/dotfiles.tar.gz
  fi
fi

# Create symlinks
headline "Symlinks"
source $HOME/dotfiles/deploy.sh

if [[ $(uname) == 'Darwin' ]]; then
  headline "Installation for macOS"
  # Run install script
  source $DOT_BASE/install-scripts/install-mac.sh
elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  headline "Installation for Windows Subsystem for Linux."
  # Run install script
  source $DOT_BASE/install-scripts/install-wsl.sh
elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
  if [[ $(uname -o) == 'Android' ]]; then
    headline "Installation for Termux."
    # Run install script
    source $DOT_BASE/install-scripts/install-termux.sh
  else
    headline "Installation for Linux."
    # Run install script
    source $DOT_BASE/install-scripts/install-linux.sh
  fi
else
  exit 1
fi
success "Installation complete."

success "Done. Happy Hacking!!"
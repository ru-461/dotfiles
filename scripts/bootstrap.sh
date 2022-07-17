#!/usr/bin/env bash

set -ue

COLOR_NONE="\033[0m"
COLOR_RED="\033[1;31m"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_YELLOW="\033[1;33m"
COLOR_GREEN="\033[1;32m"

_headline() {
  echo -e "\n${COLOR_GRAY}==============================${COLOR_NONE}"
  echo -e "${COLOR_BLUE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}"
}
alias headline=_headline

_run() {
  echo -e "\n${COLOR_BLUE}▶ $1${COLOR_NONE}"
}
alias run=_run

_info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}
alias info=_info

_warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1\n"
}
alias warning=_warning

_error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}
alias error=_error

_success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}\n"
}
alias success=_success

DOT_BASE=$HOME/dotfiles
DOT_TARBALL=https://github.com/ryu-461/dotfiles/tarball/main
DOT_REMOTE=https://github.com/ryu-461/dotfiles.git

headline "Welcome dotfiles bootstrap!!"
read -p "This script will install and deploy the various packages. Are you sure you want to continue? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  info "The process has been canceled. There is nothing to do. "
  exit 1
fi
info "Setup start."
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
    tar -xvf $HOME/dotfiles.tar.gz --strip-components 1 -C $HOME/dotfiles
    rm -f $HOME/dotfiles.tar.gz
  fi
fi

# Create symlinks
headline "Symlinks"
cd $DOT_BASE
source $HOME/dotfiles/deploy.sh

if [[ $(uname) == "Darwin" ]]; then
  headline "macOS Setup"
  # Run setup script
  source $DOT_BASE/setup/mac.sh
elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  headline "Windows Subsystem for Linux Setup"
  # Run setup script
  source $DOT_BASE/setup/wsl.sh
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  if [[ $(uname -o) == "Android" ]]; then
    headline "Termux Setup"
    # Run setup script
    source $DOT_BASE/setup/termux.sh
  else
    headline "Linux Setup"
    # Run setup script
    source $DOT_BASE/setup/linux.sh
  fi
else
  exit 1
fi
success "Setup complete."

success "Happy Hacking!!"
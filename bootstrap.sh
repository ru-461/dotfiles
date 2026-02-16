#!/usr/bin/env bash

set -ue

# colors
COLOR_NONE="\033[0m"
COLOR_RED="\033[1;31m"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_YELLOW="\033[1;33m"
COLOR_GREEN="\033[1;32m"

# consts
DOT_BASE=${HOME}/dotfiles
DOT_TARBALL=https://github.com/ru-461/dotfiles/tarball/main
DOT_REMOTE=https://github.com/ru-461/dotfiles.git

# Bootstrap helpers must work before dotfiles are cloned.
headline() {
  echo -e "\n${COLOR_GRAY}==============================${COLOR_NONE}"
  echo -e "${COLOR_BLUE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}\n"
}

has() {
  command -v "$1" > /dev/null 2>&1
}

headline "Welcome to dotfiles !"
read -p "This script will install and deploy the various packages. Are you sure you want to continue? [y/N] " -n 1 -r
echo ""
if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
  info "The process has been canceled. There is nothing to do. "
  exit 1
fi
info "Setup start."
cd ${HOME}
if [[ -d ${HOME}/dotfiles ]]; then
  read -p "The dotfiles already exists. Do you want to update them? [y/N] " -n 1 -r
  echo ""
  if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    info "Updating the dotfiles..."
    cd ${DOT_BASE}
    git pull origin main
  else
    info "There is nothing to do."
  fi
  exit 0
fi

# Clone dotfile repository locally
if [[ ! -d ${HOME}/dotfiles ]]; then
  headline "Clone dotfiles"
  if has "git"; then
    info "Cloning the dotfiles repository..."
    git clone "${DOT_REMOTE}" "${DOT_BASE}"
  else
    curl -fsSLo "${HOME}/dotfiles.tar.gz" "${DOT_TARBALL}"
    mkdir -p "${DOT_BASE}"
    tar -xvf "${HOME}/dotfiles.tar.gz" --strip-components 1 -C "${DOT_BASE}"
    rm -f "${HOME}/dotfiles.tar.gz"
  fi
fi

# Create symlinks
headline "Symlinks"
cd ${DOT_BASE}
source "${HOME}/dotfiles/deploy.sh"

# Load functions
for FUNCTION in "${HOME}/dotfiles/functions/"*.sh; do
  if [[ "${FUNCTION}" != "${HOME}/dotfiles/functions/_init.sh" ]]; then
    source "${FUNCTION}"
  fi
done

# Run setup script
if [[ $(uname) == "Darwin" ]]; then
  headline "macOS Setup"
  source ${DOT_BASE}/install/mac.sh
elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  headline "Windows Subsystem for Linux Setup"
  source ${DOT_BASE}/install/wsl.sh
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  if [[ $(uname -o) == "Android" ]]; then
    headline "Termux Setup"
    source ${DOT_BASE}/install/termux.sh
  else
    headline "Linux Setup"
    source ${DOT_BASE}/install/linux.sh
  fi
else
  exit 1
fi
success "Setup complete."

success "Happy Hacking!!"

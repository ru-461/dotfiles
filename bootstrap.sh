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
    echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

info() {
    echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

headline() {
    echo -e "\n${COLOR_GRAY}==============================${COLOR_NONE}"
    echo -e "${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

warning() {
    echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

error() {
    echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
    exit 1
}

DOT_BASE=$HOME/dotfiles
DOT_REMOTE=https://github.com/ryu-461/dotfiles.git

read -p "Welcome dotfiles installation!! This script will install and deploy the various packages. Are you ready? [y/N] ')" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo ""
  info 'The installation has been canceled. There is nothing to do.'
  exit 1
fi
echo ""

function installation() {
  echo "Called install script"
  info "Your platform is ${ENV}"
  echo "Start ${DOT_BASE}/install-scripts/install-${ENV}.sh"
  if [[ -f ${DOT_BASE}/install-scripts/install-${ENV}.sh ]]; then
    sh ${DOT_BASE}/install-scripts/install-${ENV}.sh
  else
    error "Cannot find an installation script for this platform."
    exit 1
  fi
}

if [[ $(uname) == 'Darwin' ]]; then
  info "Your environment is a Mac, Start deployment for macOS."
  ENV="mac"
  installation
elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  info "Your environment is a Windows Subsystem for Linux, Start deployment for WSL."
  ENV="wsl"
  installation
elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
  info "Your environment is a Linux, Start deployment for Linux."
  ENV="linux"
  installation
else
  echo "This platform is not supported in this Dotfiles."
  exit 1
fi

# Start deploy.
cd $DOT_BASE

# source $DOT_BASE/deploy.sh
echo "Happy Hacking!!"
#!/usr/bin/env bash

set -ue

DOT_BASE=$HOME/dotfiles
DOT_REMOTE=https://github.com/ryu-461/dotfiles.git

read -p "Welcome dotfiles installation!! This script will install and deploy the various packages. Are you ready? [y/N] ')" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo ""
  echo 'The installation has been canceled. There is nothing to do.'
  exit 1
fi
echo ""


function installation() {
  echo $ENV
  echo "define"
  if [[ -f ${DOT_BASE}/install-scripts/install-${ENV}.sh ]]; then
    sh $DOT_BASE/install-scripts/install-$ENV.sh
  else
    echo "Cannot find an installation script for this platform."
    exit 1
  fi
}

if [[ $(uname) == 'Darwin' ]]; then
  echo "Your environment is a Mac, Start deployment for macOS."
  ENV="mac"
  installation
elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  echo "Your environment is a Windows Subsystem for Linux, Start deployment for WSL."
  ENV="wsl"
  installation
elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
  echo "Your environment is a Linux, Start deployment for Linux."
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
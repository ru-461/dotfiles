#!/usr/bin/env bash

set -ue

DOT_BASE=$HOME/dotfiles
DOT_REMOTE=https://github.com/ryu-461/dotfiles.git

read -p "Welcome dotfiles installation!! This script will install and deploy the various packages. Are you ready? [y/N] ')" -n 1 -r
if [ ! $REPLY =~ ^[Yy]$ ]; then
  echo ""
  echo 'The installation has been canceled. There is nothing to do.'
  exit 1
fi
echo ""
echo "Start Installation."
# Environmental determination Mac or WSL or Linux
if [ $(uname) == 'Darwin' ]; then
  echo "Your environment is a Mac, Start deployment for macOS."
    # Clone dotfile repository locally
  if [ ! -d $HOME/dotfiles ]; then
    echo "Cloning the dotfiles repository ..."
    cd $HOME
    git clone $DOT_REMOTE
  fi
  # Run install script
  # source $DOT_BASE/install-scripts/install-mac.sh
elif [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  echo "Your environment is a Windows Subsystem for Linux, Start deployment for WSL."
  cd $HOME
  # Update packages
  echo "Updating the package to the latest ..."
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install git -y
  # Clone dotfile repository locally
  if [ ! -d $HOME/dotfiles ]; then
    echo "Cloning the dotfiles repository ..."
    cd $HOME
    git clone $DOT_REMOTE
  fi
  # Run install script
  source $DOT_BASE/install-scripts/install-wsl.sh
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  echo "Your environment is a Linux, Start deployment for Linux."
  # Update packages
  echo "Updating the package to the latest ..."
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install git -y
  # Clone dotfile repository locally
  if [ ! -d $HOME/dotfiles ]; then
    echo "Cloning the dotfiles repository ..."
    cd $HOME
    git clone $DOT_REMOTE
  else
    read -p "The dotfiles already exists. Do you want to update them? [y/N] ')" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "Updating the dotfiles ..."
      cd $DOT_BASE
      git pull origin main
    fi
    echo 'There is nothing to do.'
  fi
  # Run install script
  source $DOT_BASE/install-scripts/install-linux.sh
else
  exit 1
fi
echo "Installation complete."
# Start deploy.
cd $DOT_BASE
# source $DOT_BASE/deploy.sh
echo "Happy Hacking!!"
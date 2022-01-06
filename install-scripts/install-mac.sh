#!/usr/bin/env bash

set -ue

UNAME=`uname -m`

echo "Start Installation for WSL."

# Architecture determination
if [[ $UNAME == arm64 ]]; then
  # Install command line tools
  if !(type "git" > /dev/null 2>&1); then
    echo "Installing Command line tools ..."
    xcode-select --install
    # Install Rosetta2 for M1 Mac
    echo "Installing Rosetta2."
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
  else
    echo "Skip the command line tools as they are already installed."
  fi
else
  echo "This script is not compatible with this architecture."
  exit 1
fi

# Install Homebrew
if !(type "brew" > /dev/null 2>&1); then
  echo "Installing Homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Upgrading formula ..."
  echo "brew upgrade."
  brew upgrade
  echo "brew cleanup."
  brew cleanup
  echo "brew doctor."
  brew doctor
  echo "done."
  echo "Installing a package from Brewfile ..."
  brew bundle --file '../Brewfile'
else
  echo "Skip the Homebrew as they are already installed."
fi
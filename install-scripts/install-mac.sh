#!/usr/bin/env bash

set -ue

UNAME=`uname -m`

echo "Start Installation for Mac."

# Architecture determination
if [[ $UNAME == arm64 ]]; then
  # Install command line tools
  if ! has "git"; then
    echo "Installing Command line tools..."
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
if ! has "brew"; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Upgrading formula..."
  echo "brew upgrade."
  brew upgrade
  echo "brew cleanup."
  brew cleanup
  echo "brew doctor."
  brew doctor
  echo "done."
  echo "Installing a package from Brewfile..."
  brew bundle --file '~/dotfiles/Brewfile'
else
  echo "Homebrew is already installed."
fi

# Install Volta
if ! has "volta"; then
  curl https://get.volta.sh | bash -s -- --skip-setup
else
  echo "Volta is already installed."
fi
#!/usr/bin/env bash

set -ue

UNAME=`uname -m`

echo "Start Installation for Mac."
echo ""

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
echo ""

# Install Homebrew
if ! has "brew"; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Done."
else
  echo "Homebrew is already installed."
fi
echo ""

# Brewfile
if [ -f $HOME/dotfiles/Brewfile ]; then
  echo "Installing the formulas from Brewfile..."
  brew tap "homebrew/bundle"
  brew bundle --file '~/dotfiles/Brewfile'
  echo "Done."
fi
echo ""

# Install anyenv
if ! has "anyenv"; then
    echo "Installing anyenv..."
    git clone https://github.com/anyenv/anyenv ~/.anyenv
    ~/.anyenv/bin/anyenv init
    anyenv install --init
    echo "Setting anyenv plugin..."
    mkdir -p $(anyenv root)/plugins
    git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
else
  echo "anyenv is already installed."
fi
echo ""

# Install Volta
if ! has "volta"; then
  echo "Installing Volta..."
  curl https://get.volta.sh | bash -s -- --skip-setup
else
  echo "Volta is already installed."
fi
echo ""
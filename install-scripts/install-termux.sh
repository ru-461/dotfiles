#!/usr/bin/env bash

set -ue

# Create symlinks
source $HOME/dotfiles/deploy.sh

# In order to have access to shared storage
if [[ ! -d $HOME/dotfiles ]]; then
  echo "Access to shared storage."
  termux-setup-storage
  echo "Done."
fi
echo ""

echo "Updating the packages to the latest..."
echo "Use Pkg."
  pkg update
  pkg install wget git curl proot vim -y
echo "Done."
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
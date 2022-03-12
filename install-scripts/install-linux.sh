#!/usr/bin/env bash

set -ue

# Create symlinks
source $HOME/dotfiles/deploy.sh

# Update packages
info "Updating the packages to the latest..."
# Use apt
if has "apt"; then
  echo "Use apt."
  sudo apt update
fi

# Use yum
if has "yum"; then
  echo "Use yum."
  sudo yum update
fi
echo "Done."
echo ""

# Install Zsh
if ! has "zsh"; then
  echo "Installing Zsh..."
  if has "apt"; then
    sudo apt install zsh -y
  fi

  if has "yum"; then
    sudo yum install zsh -y
  fi
  echo "Setting default..."
  if [[ "$SHELL" != $(which zsh) ]]; then
      chsh -s $(which zsh)
      echo "Default shell changed to Zsh."
  fi
  echo "Zsh will be enabled after the re-login."
  echo "Done."
else
  echo "Zsh is already installed."
fi
echo ""

# Setting System
if has "timedatectl"; then
  echo "Setting the time zone..."
  sudo timedatectl set-timezone Asia/Tokyo
  echo "Done."
else
  echo "timedatectl is required to set the time zone."
fi
echo ""

# Install Linuxbrew
if ! has "brew"; then
  echo "Installing Linuxbrew..."
  sudo apt install build-essential curl file git -y
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Setting Linuxbrew..."
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
  source ~/.profile
  echo "Done."
else
  echo "Linuxbrew is already installed."
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
    ~/.anyenv/bin/anyenv install --init
    echo "Setting anyenv plugin..."
    mkdir -p ~/.anyenv/plugins
    git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update
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
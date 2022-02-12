#!/usr/bin/env bash

set -ue

echo "Start Installation for Linux."

# Update packages
echo "Updating the packages to the latest..."
# Use apt
if has "apt"; then
  echo "Use apt."
  sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean -y
fi

# Use yum
if has "yum"; then
  echo "Use yum."
  sudo yum update && sudo yum upgrade -y
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

# Create symlinks
source $HOME/dotfiles/deploy.sh
echo ""

# Setting System
echo "Setting the time zone..."
sudo timedatectl set-timezone Asia/Tokyo
echo "Done."

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
  echo "Installing additional packages..."
  # brew install git wget vim
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
    echo "Setting anyenv..."
    anyenv install --init
    mkdir -p $(anyenv root)/plugins
    git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
else
  echo "anyenv is already installed."
fi
echo ""

# Install Volta
if ! has "volta"; then
  echo "Setting Volta..."
  curl https://get.volta.sh | bash -s -- --skip-setup
else
  echo "Volta is already installed."
fi
echo ""
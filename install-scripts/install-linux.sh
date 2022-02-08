#!/usr/bin/env bash

set -ue

echo "Start Installation for Linux."

# Update packages
echo "Updating the packages to the latest ..."
# Use apt
if has "apt"; then
  sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean -y
  sudo apt install git zsh -y
fi

# Use yum
if has "yum"; then
  sudo yum update && sudo yum upgrade -y
  sudo yum install git zsh -y
fi
echo "done."

# Create symlinks
echo "Linking files ..."
source $HOME/dotfiles/deploy.sh
echo "done."

# Setting System
sudo timedatectl set-timezone Asia/Tokyo

# Install Linuxbrew
if has "brew"; then
  echo "Installing Linuxbrew ..."
  sudo apt install build-essential curl file git -y
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "done."
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
  source ~/.profile
  echo "done."
else
  echo "Brew is already installed."
fi

# Install Zsh
if has "zsh"; then
  echo "Installing Zsh ..."
  brew install zsh
  echo "Setting default..."
  echo `which zsh` | sudo tee -a /etc/shells
  chsh -s `which zsh`
  echo "done."
else
  echo "Zsh is already installed."
fi

# Brewfile
if [ ! -f $HOME/dotfiles/Brewfile ]; then
  echo "Installing the formulas from Brewfile ..."
  brew tap "homebrew/bundle"
  brew bundle --file '~/dotfiles/Brewfile'
  echo "done."
fi

# Install Volta
if has "volta"; then
  curl https://get.volta.sh | bash -s -- --skip-setup
else
  echo "Volta is already installed."
fi

echo "Installation complete."
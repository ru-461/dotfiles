#!/usr/bin/env bash

set -ue

cd $DOT_BASE

echo "Start Installation for Linux."

# Update packages
echo "Updating the package to the latest ..."
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean -y
sudo apt install git -y

if [ ! -d $HOME/dotfiles ]; then
  echo "Cloning the dotfiles repository ..."
  cd $HOME
  git clone $DOT_REMOTE
else
  echo "dotfiles already exists."
fi

# Create symlinks
echo "Linking files ..."
source $HOME/dotfiles/deploy.sh
echo "done."

# Setting System
sudo timedatectl set-timezone Asia/Tokyo

# Install Linuxbrew
if !(type "brew" > /dev/null 2>&1); then
  echo "Installing Linuxbrew ..."
  sudo apt install build-essential curl file git -y
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "done."
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r $~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.bash_profile
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/g.profile
  source ~/.profile
  echo "done."
else
  echo "Brew is already installed."
fi

# Install Zsh
if !(type "zsh" > /dev/null 2>&1); then
  echo "Installing Zsh ..."
  brew install zsh
  echo "Setting default..."
  # sudo sh -c 'echo $(brew --prefix)/bin/zsh >> /etc/shells'
  # chsh -s $(brew --prefix)/bin/zsh
  echo "which zsh" | sudo tee -a /etc/shells
  sudo chsh -s `which zsh`
  echo "Loading Settings from .zshrc"
  source ~/.zshrc
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
if !(type "volta" > /dev/null 2>&1); then
  curl https://get.volta.sh | bash -s -- --skip-setup
else
  echo "Volta is already installed."
fi

echo "Installation complete."
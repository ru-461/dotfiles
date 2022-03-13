#!/usr/bin/env bash

set -ue

# Update packages
headline "Packages"
info "Updating the packages to the latest..."
# Use apt
if has "apt"; then
  sudo apt update
fi
# Use yum
if has "yum"; then
  sudo yum update
fi

# Install Zsh
headline "Zsh"
if ! has "zsh"; then
  info "Installing Zsh..."
  if has "apt"; then
    sudo apt install zsh -y
  fi

  if has "yum"; then
    sudo yum install zsh -y
  fi
  info "Setting default..."
  if [[ "$SHELL" != $(which zsh) ]]; then
      chsh -s $(which zsh)
      info "Default shell changed to Zsh."
  fi
  warning "Zsh will be enabled after the re-login."
else
  success "Zsh is already installed."
fi

# Setting System
headline "Config"
info "Start configuration for Japanese."
info "Setting time zone and locale..."
sudo apt install language-pack-ja manpages-ja manpages-ja-dev -y
sudo update-locale LANG=ja_JP.UTF8
sudo dpkg-reconfigure tzdata
warning "The settings will take effect after you log in again."

# Install Homebrew
headline "Homebrew"
if ! has "brew"; then
  info "Installing Homebrew..."
  sudo apt install build-essential curl file git -y
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  info "Setting Homebrew..."
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
  source ~/.profile
else
  success "Linuxbrew is already installed."
fi

# Brewfile
headline "Brew bundle"
if [ -f $HOME/dotfiles/Brewfile ]; then
  info "Installing the formulas from Brewfile..."
  brew tap "homebrew/bundle"
  brew bundle --file "~/dotfiles/Brewfile"
fi

# Install anyenv
headline "anyenv"
if ! has "anyenv"; then
  info "Installing anyenv..."
    if [[ ! -d $HOME/.anyenv ]]; then
    git clone https://github.com/anyenv/anyenv ~/.anyenv
  fi
  ~/.anyenv/bin/anyenv install --init
  info "Setting anyenv plugin..."
  mkdir -p ~/.anyenv/plugins
  git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update
else
  success "anyenv is already installed."
fi

# Install Volta
headline "Volta"
if ! has "volta"; then
  info "Installing Volta..."
  curl https://get.volta.sh | bash -s -- --skip-setup
else
  success "Volta is already installed."
fi
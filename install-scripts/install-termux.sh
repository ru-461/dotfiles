#!/usr/bin/env bash

set -ue

# In order to have access to shared storage
if [[ ! -d $HOME/dotfiles ]]; then
  info "Access to shared storage."
  termux-setup-storage
  success "Setup done."
fi

# Update packages
headline "Packages"
info "Updating the packages to the latest..."
pkg update
pkg install wget git curl proot vim -y

# Install Zsh
headline "Zsh"
if ! has "zsh"; then
  info "Installing Zsh..."
  pkg install zsh -y
  info "Setting default..."
  if [[ "$SHELL" != $(which zsh) ]]; then
      chsh -s $(which zsh)
      info "Default shell changed to Zsh."
  fi
  warning "Zsh will be enabled after the re-login."
else
  success "Zsh is already installed."
fi

# Install anyenv
headline "anyenv"
if ! has "anyenv"; then
  info "Installing anyenv..."
  git clone https://github.com/anyenv/anyenv ~/.anyenv
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
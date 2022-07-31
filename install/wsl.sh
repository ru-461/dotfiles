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
_zsh

# Install Linuxbrew
_brew

# Brewfile
_bundle_brew

# Install anyenv
_anyenv

# Install Volta
_volta

# Setting System
headline "Config"
info "Start configuration for Japanese."
info "Setting time zone and locale..."
sudo apt install language-pack-ja manpages-ja manpages-ja-dev -y
sudo update-locale LANG=ja_JP.UTF8
sudo dpkg-reconfigure tzdata
warning "The settings will take effect after you log in again."

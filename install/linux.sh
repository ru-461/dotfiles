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

# Bundle Brewfile
_bundle_brew

# Install anyenv
_anyenv

# Install Volta
_volta

# Setting System
headline "Config"
if has "timedatectl"; then
  info "Setting the time zone..."
  sudo timedatectl set-timezone Asia/Tokyo
  success "The time zone has been set correctly."
else
  warning "timedatectl is required to set the time zone."
fi

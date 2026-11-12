#!/usr/bin/env bash

set -ue

# Update package indexes (upgrading is left to `au`)
headline "Packages"
info "Updating the package index..."
if has "apt-get"; then
  sudo apt-get update
elif has "yum"; then
  sudo yum makecache -y
else
  warning "Skip updating the package index because neither apt-get nor yum was found."
fi

# Install Zsh
_zsh

# Install Linuxbrew
_brew

# Bundle Brewfile
_bundle_brew

# Setting System
headline "Config"
DOTFILES_TIMEZONE="${DOTFILES_TIMEZONE:-Asia/Tokyo}"
info "Setting the time zone to ${DOTFILES_TIMEZONE}..."
if has "timedatectl" && timedatectl > /dev/null 2>&1; then
  sudo timedatectl set-timezone "${DOTFILES_TIMEZONE}"
  success "The time zone has been set correctly."
elif [[ -f "/usr/share/zoneinfo/${DOTFILES_TIMEZONE}" ]]; then
  sudo ln -sf "/usr/share/zoneinfo/${DOTFILES_TIMEZONE}" /etc/localtime
  echo "${DOTFILES_TIMEZONE}" | sudo tee /etc/timezone > /dev/null
  success "The time zone has been set correctly."
else
  warning "Skip setting the time zone because timedatectl is unavailable and /usr/share/zoneinfo/${DOTFILES_TIMEZONE} was not found."
fi

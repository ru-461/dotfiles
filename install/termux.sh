#!/usr/bin/env bash

set -ue

# In order to have access to shared storage
if [[ ! -d ${HOME}/storage ]]; then
  info "Access to shared storage."
  termux-setup-storage
  success "Setup done."
fi

# Update packages
headline "Packages"
info "Updating the packages to the latest..."
pkg update -y
pkg install -y bat curl eza fd git jq proot procs screenfetch starship tree vim wget

# Install Zsh
_zsh

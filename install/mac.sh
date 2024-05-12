#!/usr/bin/env bash

set -ue

# Architecture determination
if [[ $(uname -m) == "arm64" ]]; then
  # Install command line tools
  if ! has "git"; then
    headline "Command line tools"
    info "Installing Command line tools..."
    xcode-select --install
    # Install Rosetta2 for Apple Silicon.
    headline "Rosetta2"
    info "Installing Rosetta2."
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
  else
    success "Skip the command line tools as they are already installed."
  fi
else
  error "This script is not compatible with this architecture."
  exit 1
fi

# Install Homebrew
_brew

# Brewfile
_bundle_brew

# iTerm2
_item2

#################################  DEFAULTS  #################################

headline "Config"
info "Start Setting defaults..."

#  Apprerance
info "Setting Apprerance..."
defaults delete .GlobalPreferences AppleInterfaceStyleSwitchesAutomatically > /dev/null 2>&1
# Theme
defaults write .GlobalPreferences AppleInterfaceStyle -string "Dark"
# Dock
defaults delete com.apple.dock orientation

info "Setting File System..."
# DS_Store
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Show Hidden Files
defaults write com.apple.finder AppleShowAllFiles true

info "Setting AppStore..."
# Enable Auto Update Check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Enable Auto Update
defaults write com.apple.commerce AutoUpdate -bool false

info "Setting Screenshot..."
# Location
defaults write com.apple.screencapture location -string "${HOME}/Downloads"
# Format - png
defaults write com.apple.screencapture type -string "png"
# Disable Shadow
defaults write com.apple.screencapture disable-shadow -bool true

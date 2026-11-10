#!/usr/bin/env bash

set -ue

if [[ "$(uname -m)" != "arm64" ]]; then
  die "This script supports Apple Silicon (arm64) only."
fi

headline "Command line tools"
if xcode-select -p > /dev/null 2>&1; then
  success "Command line tools are already installed."
else
  info "Installing Command line tools (complete the dialog to continue)..."
  xcode-select --install > /dev/null 2>&1 || true
  until xcode-select -p > /dev/null 2>&1; do
    sleep 5
  done
  success "Command line tools have been installed."
fi

headline "Rosetta 2"
if arch -x86_64 /usr/bin/true > /dev/null 2>&1; then
  success "Rosetta 2 is already installed."
else
  info "Installing Rosetta 2..."
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

# Install Homebrew
_brew

# Brewfile
_bundle_brew

#################################  DEFAULTS  #################################

headline "Config"
info "Start Setting defaults..."

#  Appearance
info "Setting Appearance..."
defaults delete .GlobalPreferences AppleInterfaceStyleSwitchesAutomatically > /dev/null 2>&1 || true
# Theme
defaults write .GlobalPreferences AppleInterfaceStyle -string "Dark"
# Dock
defaults delete com.apple.dock orientation > /dev/null 2>&1 || true

info "Setting File System..."
# DS_Store
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Show Hidden Files
defaults write com.apple.finder AppleShowAllFiles -bool true

info "Setting AppStore..."
# Enable Auto Update Check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Enable Auto Update
defaults write com.apple.commerce AutoUpdate -bool true

info "Setting Screenshot..."
# Location
defaults write com.apple.screencapture location -string "${HOME}/Downloads"
# Format - png
defaults write com.apple.screencapture type -string "png"
# Disable Shadow
defaults write com.apple.screencapture disable-shadow -bool true

info "Restarting affected apps..."
killall Dock Finder SystemUIServer > /dev/null 2>&1 || true

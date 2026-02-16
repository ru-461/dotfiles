_bundle_brew() {
  headline "Brew bundle"
  if ! has "brew"; then
    warning "Skip Brew bundle because brew is not available."
    return 0
  fi

  if [ -f "${HOME}/dotfiles/Brewfile" ]; then
    info "Installing the formulas from Brewfile..."
    brew tap "homebrew/bundle"
    brew bundle --file "${HOME}/dotfiles/Brewfile"
  fi
}

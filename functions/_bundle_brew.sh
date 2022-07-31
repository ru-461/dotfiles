_bundle_brew() {
  headline "Brew bundle"
  if [ -f ${HOME}/dotfiles/Brewfile ]; then
    info "Installing the formulas from Brewfile..."
    brew tap "homebrew/bundle"
    brew bundle --file "~/dotfiles/Brewfile"
  fi
}

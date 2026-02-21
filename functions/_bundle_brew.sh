_bundle_brew() {
  local dotfiles_dir brewfile_path

  headline "Brew bundle"
  if ! has "brew"; then
    warning "Skip Brew bundle because brew is not available."
    return 0
  fi

  dotfiles_dir="${DOTFILES_DIR:-${HOME}/dotfiles}"
  if [[ ! -f "${dotfiles_dir}/Brewfile" && -f "${HOME}/.local/share/chezmoi/Brewfile" ]]; then
    dotfiles_dir="${HOME}/.local/share/chezmoi"
  fi
  brewfile_path="${dotfiles_dir}/Brewfile"

  if [ -f "${brewfile_path}" ]; then
    info "Installing the formulas from Brewfile..."
    brew tap "homebrew/bundle"
    brew bundle --file "${brewfile_path}"
  else
    warning "Skip Brew bundle because Brewfile was not found."
  fi
}

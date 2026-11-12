# shellcheck shell=bash
_bundle_brew() {
  local dotfiles_dir brewfile_path

  headline "Brew bundle"
  if ! has "brew"; then
    warning "Skip Brew bundle because brew is not available."
    return 0
  fi

  dotfiles_dir="${DOTFILES_DIR:-}"
  if [[ -z "${dotfiles_dir}" ]] && has "chezmoi"; then
    dotfiles_dir="$(chezmoi source-path 2> /dev/null || true)"
  fi
  brewfile_path="${dotfiles_dir}/Brewfile"

  if [[ -n "${dotfiles_dir}" && -f "${brewfile_path}" ]]; then
    info "Installing the formulas from Brewfile..."
    brew bundle --file "${brewfile_path}"
  else
    warning "Skip Brew bundle because Brewfile was not found."
  fi
}

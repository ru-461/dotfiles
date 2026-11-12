# shellcheck shell=bash
_zsh() {
  local zsh_path

  headline "Zsh"
  if has "zsh"; then
    success "Zsh is already installed."
  else
    info "Installing Zsh..."
    if has "pkg"; then
      pkg install -y zsh
    elif has "apt-get"; then
      sudo apt-get install -y zsh
    elif has "yum"; then
      sudo yum install -y zsh
    else
      die "No supported package manager found to install Zsh."
    fi
  fi

  if [[ "$(basename "${SHELL:-}")" == "zsh" ]]; then
    success "Zsh is already the default shell."
    return 0
  fi

  zsh_path="$(command -v zsh)" || die "zsh was not found after installation."
  info "Setting Zsh as the default shell..."
  if [[ -n "${TERMUX_VERSION:-}" ]]; then
    chsh -s zsh
  elif ! grep -qxF "${zsh_path}" /etc/shells 2> /dev/null; then
    warning "${zsh_path} is not listed in /etc/shells. Add it, then run: chsh -s ${zsh_path}"
    return 0
  elif sudo -n true 2> /dev/null; then
    sudo chsh -s "${zsh_path}" "$(id -un)"
  else
    chsh -s "${zsh_path}"
  fi
  warning "Zsh will be enabled after the re-login."
}

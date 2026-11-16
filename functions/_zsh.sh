# shellcheck shell=bash
_zsh() {
  local zsh_path
  local login_shell
  local candidate
  local verify_login_shell=no
  local username

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

  username="$(id -un)"
  login_shell="${SHELL:-}"
  if [[ -z "${TERMUX_VERSION:-}" && "$(uname -s)" == "Linux" ]]; then
    verify_login_shell=yes
    login_shell="$(getent passwd "${username}" | cut -d: -f7)" || die "Could not read the registered login shell."
    [[ -n "${login_shell}" ]] || die "The registered login shell is empty."
  fi

  if [[ "$(basename "${login_shell}")" == "zsh" ]] &&
    { [[ "${verify_login_shell}" != "yes" ]] || [[ -f "${login_shell}" && -x "${login_shell}" ]]; }; then
    success "Zsh is already the default shell."
    return 0
  fi

  zsh_path="$(command -v zsh)" || die "zsh was not found after installation."
  info "Setting Zsh as the default shell..."
  if [[ -n "${TERMUX_VERSION:-}" ]]; then
    chsh -s zsh
  else
    if ! grep -qxF "${zsh_path}" /etc/shells 2> /dev/null || [[ ! -f "${zsh_path}" || ! -x "${zsh_path}" ]]; then
      zsh_path=""
      while IFS= read -r candidate || [[ -n "${candidate}" ]]; do
        if [[ "${candidate}" == /*/zsh && -f "${candidate}" && -x "${candidate}" ]]; then
          zsh_path="${candidate}"
          break
        fi
      done < /etc/shells
      [[ -n "${zsh_path}" ]] || die "No executable zsh was found in /etc/shells. Add one, then rerun this installer."
    fi
    if sudo -n true 2> /dev/null; then
      sudo chsh -s "${zsh_path}" "${username}"
    else
      chsh -s "${zsh_path}"
    fi
  fi
  if [[ "${verify_login_shell}" == "yes" ]]; then
    login_shell="$(getent passwd "${username}" | cut -d: -f7)" || die "Could not verify the registered login shell."
    [[ "${login_shell}" == "${zsh_path}" ]] || die "Login shell was not changed to ${zsh_path} (registered: ${login_shell})."
    success "Registered login shell: ${login_shell}"
  fi
  warning "Zsh will be enabled after the re-login."
}

_zsh() {
  headline "Zsh"
  if ! has "zsh"; then
    info "Installing Zsh..."
    if has "pkg"; then
      pkg install zsh -y
    elif has "apt"; then
      sudo apt install zsh -y
    elif has "yum"; then
      sudo yum install zsh -y
    fi
    info "Setting default..."
    if [[ "${SHELL}" != $(which zsh) ]]; then
        chsh -s $(which zsh)
        info "Default shell changed to Zsh."
    fi
    warning "Zsh will be enabled after the re-login."
  else
    success "Zsh is already installed."
  fi
}

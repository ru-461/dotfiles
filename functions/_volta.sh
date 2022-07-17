_volta() {
  headline "Volta"
  if ! has "volta"; then
    info "Installing Volta..."
    curl https://get.volta.sh | bash -s -- --skip-setup
  else
    success "Volta is already installed."
  fi
}
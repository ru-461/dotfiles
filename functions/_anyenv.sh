_anyenv() {
  headline "anyenv"
  if ! has "anyenv"; then
    info "Installing anyenv..."
    if [[ ! -d ${HOME}/.anyenv ]]; then
      git clone https://github.com/anyenv/anyenv ${HOME}/.anyenv
    fi
    ${HOME}/.anyenv/bin/anyenv install --init
    info "Setting anyenv plugin..."
    mkdir -p ${HOME}/.anyenv/plugins
    git clone https://github.com/znz/anyenv-update.git ${HOME}/.anyenv/plugins/anyenv-update
  else
    success "anyenv is already installed."
  fi
}
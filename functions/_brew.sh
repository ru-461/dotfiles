_brew() {
  headline "brew"
  if ! has "brew"; then
      info "Installing brew..."
    if [[ $(uname) == "Darwin" ]]; then
      sudo apt install build-essential curl file git -y
    fi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    info "Setting brew..."
    if [[ $(uname) != "Darwin" ]]; then
      test -d ${HOME}/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
      test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
      test -r ${HOME}/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ${HOME}/.bash_profile
      echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ${HOME}/.profile
      source ${HOME}/.profile
    fi
  else
    success "brew is already installed."
  fi
}

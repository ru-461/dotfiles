_linuxbrew() {
  headline "Linuxbrew"
  if ! has "brew"; then
    info "Installing Linuxbrew..."
    sudo apt install build-essential curl file git -y
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    info "Setting Linuxbrew..."
    test -d $HOME/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r $HOME/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> $HOME/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> $HOME/.profile
    source $HOME/.profile
  else
    success "Linuxbrew is already installed."
  fi
}
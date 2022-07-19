_auto_upgrade() {
  info "Auto package upgrading..."
  if [[ ! ${OS} = "linux-android" ]]; then
    if [[ ${OS} = "linux" ]]; then
      headline "apt"
      info "Upgrading packages..."
      run "apt update"
      sudo apt update
      run "apt upgrade"
      sudo apt upgrade -y
      run "apt autoremove"
      sudo apt autoremove -y
      run "apt clean"
      sudo apt clean -y
      info "Upgrading Done."
    fi
    headline "Homebrew"
    info "Upgrading brew formulas..."
    run "brew update"
    brew update
    run "brew upgrade"
    brew upgrade
    run "brew cleanup"
    brew cleanup
    run "brew doctor"
    brew doctor
    info "Upgrading Done."
    if [[ ${OS} = "darwin" ]]; then
      headline "mas"
      info "Upgrading apps..."
      run "mas outdated"
      mas outdated
      run "mas upgrade"
      mas upgrade
      info "Upgrading Done."
    fi
  else
    headline "pkg"
    info "Upgrading packages..."
    run "pkg update"
    pkg update
    run "pkg upgrade"
    pkg upgrade -y
    run "pkg autoclean"
    pkg autoclean
    run "pkg clean"
    pkg clean
    info "Upgrading Done."
  fi
}
alias au=_auto_upgrade
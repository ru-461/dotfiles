_auto_upgrade() {
  local _au_errors=0
  local _au_start=$SECONDS

  _au_run() {
    run "$*"
    if eval "$@" 2>&1; then
      success "  Done"
    else
      warning "  Failed: $*"
      ((_au_errors++)) || true
    fi
  }

  headline "Auto Upgrade"
  info "Starting package upgrade..."
  echo ""

  if [[ ! ${OS} = "linux-android" ]]; then
    if [[ ${OS} = "linux" ]]; then
      headline "apt"
      _au_run sudo apt update
      _au_run sudo apt upgrade -y
      _au_run sudo apt autoremove -y
      _au_run sudo apt clean
    fi
    if command -v brew &>/dev/null; then
      headline "Homebrew"
      _au_run brew update
      _au_run brew upgrade
      _au_run brew cleanup
      _au_run "brew doctor || true"
    fi
    if [[ ${OS} = "darwin" ]] && command -v mas &>/dev/null; then
      headline "Mac App Store"
      _au_run mas outdated
      _au_run mas upgrade
    fi
  else
    headline "pkg (Termux)"
    _au_run pkg update -y
    _au_run pkg upgrade -y
    _au_run pkg autoclean
    _au_run pkg clean
  fi

  local _au_elapsed=$(( SECONDS - _au_start ))
  echo ""
  headline "Result"
  if [[ $_au_errors -eq 0 ]]; then
    success "All upgrades completed successfully (${_au_elapsed}s)"
  else
    warning "$_au_errors command(s) failed (${_au_elapsed}s)"
  fi

  unset -f _au_run
}
alias au=_auto_upgrade

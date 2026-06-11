_au_run() {
  run "$*"
  if "$@"; then
    success "  Done"
  else
    warning "  Failed: $*"
    ((_au_errors++)) || true
  fi
}

_auto_upgrade() {
  local _au_errors=0
  local _au_start=$SECONDS

  headline "Auto Upgrade"
  info "Starting package upgrade..."
  echo ""

  if [[ ! ${OS} = "linux-android" ]]; then
    if [[ ${OS} = "linux" ]]; then
      headline "apt"
      # Cache sudo credentials up front so prompts don't interrupt mid-flow.
      sudo -v
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
      # Informational only: doctor warnings shouldn't count as failures.
      run "brew doctor"
      brew doctor || true
    fi
    if [[ ${OS} = "darwin" ]] && command -v mas &>/dev/null; then
      headline "Mac App Store"
      # Informational only: just lists pending updates.
      run "mas outdated"
      mas outdated || true
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
}
alias au=_auto_upgrade

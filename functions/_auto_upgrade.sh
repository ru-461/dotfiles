# shellcheck shell=bash
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
    if [[ ${OS} = "linux" ]] && command -v apt-get &>/dev/null; then
      headline "apt"
      # Cache sudo credentials up front so prompts don't interrupt mid-flow.
      if sudo -v; then
        _au_run sudo apt-get update
        _au_run sudo apt-get upgrade -y
        _au_run sudo apt-get autoremove -y
        _au_run sudo apt-get clean
      else
        warning "  Skipped apt: sudo authentication failed."
        ((_au_errors++)) || true
      fi
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
      # mas upgrade needs root; mas reuses cached sudo credentials, so authenticate up front.
      if sudo -v; then
        _au_run mas upgrade
      else
        warning "  Skipped mas upgrade: sudo authentication failed."
        ((_au_errors++)) || true
      fi
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

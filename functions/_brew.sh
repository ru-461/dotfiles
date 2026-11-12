# shellcheck shell=bash
_brew_shellenv() {
  local candidate
  for candidate in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew "${HOME}/.linuxbrew/bin/brew"; do
    if [[ -x "${candidate}" ]]; then
      eval "$("${candidate}" shellenv)"
      return 0
    fi
  done
  return 1
}

_brew() {
  headline "brew"
  if has "brew"; then
    success "brew is already installed."
    return 0
  fi

  info "Installing brew..."
  if [[ "$(uname)" != "Darwin" ]]; then
    if has "apt-get"; then
      sudo apt-get install -y build-essential curl file git
    elif has "yum"; then
      sudo yum groupinstall -y "Development Tools"
      sudo yum install -y curl file git
    fi
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  _brew_shellenv || die "brew was installed but the binary was not found."
  success "brew is ready: $(command -v brew)"
}

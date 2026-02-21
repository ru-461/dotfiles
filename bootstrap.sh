#!/usr/bin/env bash

set -eu

REPO="ru-461"
CHEZMOI_INSTALL_URL="https://get.chezmoi.io"

info() {
  printf '%s\n' "[INFO] $1"
}

warn() {
  printf '%s\n' "[WARN] $1"
}

fail() {
  printf '%s\n' "[ERROR] $1" >&2
  exit 1
}

ensure_chezmoi() {
  if command -v chezmoi > /dev/null 2>&1; then
    return 0
  fi

  local bin_dir
  bin_dir="${HOME}/.local/bin"
  mkdir -p "${bin_dir}"

  info "chezmoi was not found. Installing from ${CHEZMOI_INSTALL_URL}."
  sh -c "$(curl -fsLS ${CHEZMOI_INSTALL_URL})" -- -b "${bin_dir}"
  export PATH="${bin_dir}:${PATH}"

  command -v chezmoi > /dev/null 2>&1 || fail "Failed to install chezmoi."
}

warn "Legacy bootstrap entrypoint. Prefer: sh -c \"\$(curl -fsLS get.chezmoi.io)\" -- init --apply ${REPO}"
ensure_chezmoi

info "Running: chezmoi init --apply ${REPO}"
exec chezmoi init --apply "${REPO}"

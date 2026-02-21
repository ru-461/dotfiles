#!/usr/bin/env bash

set -eu

info() {
  printf '%s\n' "[INFO] $1"
}

fail() {
  printf '%s\n' "[ERROR] $1" >&2
  exit 1
}

if ! command -v chezmoi > /dev/null 2>&1; then
  fail "chezmoi is not installed. Run: sh -c \"\$(curl -fsLS get.chezmoi.io)\" -- init --apply ru-461"
fi

info "Legacy deploy entrypoint. Running chezmoi apply."
exec chezmoi apply

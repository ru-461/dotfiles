#!/usr/bin/env bash

# Shared helpers for both shell startup and installer scripts.
_common_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_default_dotfiles_dir="$(cd "${_common_script_dir}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${_default_dotfiles_dir}}"
FUNCTIONS_DIR="${FUNCTIONS_DIR:-${DOTFILES_DIR}/functions}"

source "${FUNCTIONS_DIR}/_decorate_output.sh"
source "${FUNCTIONS_DIR}/_has.sh"

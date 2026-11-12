_delete_stores() {
  local target="${1:-}"
  if [[ -z "${target}" || ! -d "${target}" ]]; then
    echo "Usage: dss <directory>" >&2
    return 1
  fi

  # Remove with rm instead of -delete so only files actually removed are printed:
  # BSD find's -delete always evaluates to true, even when unlink fails.
  local -a find_args=(-type f \( -name ".DS_Store" -o -name "._*" -o -name "Thumbs.db" -o -name "Desktop.ini" \) -exec rm -f -- {} \; -print)
  local errors rc
  # Try as the current user first, capturing stderr while stdout still reaches the terminal.
  { errors="$(find "${target}" "${find_args[@]}" 2>&1 1>&3 3>&-)"; rc=$?; } 3>&1
  [[ ${rc} -eq 0 && -z "${errors}" ]] && return 0

  # Something could not be read or removed (e.g. subdirectories owned by another user).
  echo "Some entries need elevated permissions. Retrying with sudo..." >&2
  sudo find "${target}" "${find_args[@]}"
}
alias dss=_delete_stores

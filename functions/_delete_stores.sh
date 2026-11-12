_delete_stores() {
  local target="${1:-}"
  if [[ -z "${target}" || ! -d "${target}" ]]; then
    echo "Usage: dss <directory>" >&2
    return 1
  fi

  # Use sudo only when the directory is not writable by the current user.
  local -a runner=()
  [[ -w "${target}" ]] || runner=(sudo)
  "${runner[@]}" find "${target}" -type f \( -name ".DS_Store" -o -name "._*" -o -name "Thumbs.db" -o -name "Desktop.ini" \) -print -delete
}
alias dss=_delete_stores

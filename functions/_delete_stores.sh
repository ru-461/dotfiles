_delete_stores () {
  sudo find "$1" \( -name ".DS_Store" -or -name "._*" -or -name "Thumbs.db" -or -name "Desktop.ini" \) -delete -print;
}
alias dss=_delete_stores

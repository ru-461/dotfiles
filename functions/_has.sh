_has() {
  type "$1" > /dev/null 2>&1
}
alias has=_has

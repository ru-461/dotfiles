COLOR_NONE="\033[0m"
COLOR_RED="\033[1;31m"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_YELLOW="\033[1;33m"
COLOR_GREEN="\033[1;32m"

_headline() {
  echo -e "\n${COLOR_GRAY}==============================${COLOR_NONE}"
  echo -e "${COLOR_BLUE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}"
}
alias headline=_headline

_run() {
  echo -e "\n${COLOR_BLUE}▶ $1${COLOR_NONE}"
}
alias run=_run

_info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}
alias info=_info

_warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1\n"
}
alias warning=_warning

_error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}
alias error=_error

_success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}\n"
}
alias success=_success

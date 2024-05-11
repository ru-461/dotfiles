headline() {
  echo -e "\n${COLOR_GRAY}==============================${COLOR_NONE}"
  echo -e "${COLOR_BLUE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}"
}

run() {
  echo -e "\n${COLOR_BLUE}▶ $1${COLOR_NONE}"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}\n"
}

has() {
  type "$1" > /dev/null 2>&1
}

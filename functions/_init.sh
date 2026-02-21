_init () {
  # Load common functions from the active dotfiles source.
  local dotfiles_dir functions_dir

  dotfiles_dir="${DOTFILES_DIR:-${HOME}/dotfiles}"
  if [[ ! -d "${dotfiles_dir}" && -d "${HOME}/.local/share/chezmoi" ]]; then
    dotfiles_dir="${HOME}/.local/share/chezmoi"
  fi

  functions_dir="${FUNCTIONS_DIR:-${dotfiles_dir}/functions}"
  source "${functions_dir}/_decorate_output.sh"
  source "${functions_dir}/_has.sh"
}
_init

headline "Welcome to Zsh!"

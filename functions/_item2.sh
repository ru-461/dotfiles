_item2() {
  headline "iTerm2 Shell Integration"¡
  if [ ! -f ~/.iterm2_shell_integration.zsh ]; then
    curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
    if [ -f ~/.iterm2_shell_integration.zsh ]; then
      success "iTerm2 Shell Integration successfully installed."
    fi
  else
    success "iTerm2 Shell Integration is already installed."
  fi
}

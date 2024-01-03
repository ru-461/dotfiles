#################################  COMMON  #################################

# Load common functions
source ${HOME}/dotfiles/functions/_init.sh

FUNCTIONS_DIR="${HOME}/dotfiles/functions"
# Load functions
for FUNCTION in "${FUNCTIONS_DIR}"/*.sh; do
  if [ "${FUNCTION}" != "${FUNCTIONS_DIR}/_init.sh" ]; then
    source "${FUNCTION}"
  fi
done

# OS
case $OSTYPE in
  linux-android*)
    OS=linux-android
    ;;
  darwin*)
    OS=darwin
    ;;
  linux*)
    OS=linux
    ;;
  *)
    OS=unknown
    ;;
esac


#################################  ZSH INIT  #################################

# Completions
zstyle ":completion:*" verbose yes
zstyle ":completion:*:commands" rehash 1
zstyle ":completion:*" completer _extensions _complete _approximate
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"
zstyle ":completion:*" menu select
zstyle ":completion:*" group-name ""
zstyle ":completion:*:*:*:*:descriptions" format "%F{green}-- %d --%f"

# Cd
setopt auto_cd
setopt correct

# Lang
export LANG=ja_JP.UTF-8
setopt print_eight_bit

# Zsh history
HISTFILE=${HOME}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS

# Setting beep
setopt no_beep
setopt nolistbeep

# Configure path
typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /opt/homebrew/opt/php@8.0/bin(N-/)
  /opt/homebrew/opt/php@8.0/sbin(N-/)
  /home/linuxbrew/.linuxbrew/opt/php@8.0/bin(N-/)
  /home/linuxbrew/.linuxbrew/opt/php@8.0/sbin(N-/)
  /data/data/com.termux/files/usr/bin(N-/)
  /usr/bin(N-/)
  /usr/sbin(N-/)
  /bin(N-/)
  /sbin(N-/)
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin(N-/)
  $HOME/fvm/default/bin(N-/)
  ${path}
)


#################################  TOOL INIT  #################################

# Android
if [[ ${OS} = "darwin" ]]; then
  export ANDROID_HOME=~/Library/Android/sdk
  
  if [[ -d ${ANDROID_HOME} ]]; then
    export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/tools
  fi 
fi

# iTerm2
if [[ ! ${OS} = "darwin" ]]; then
  test -e "${HOME}/.iterm2_shell_integration.zsh"
  source "${HOME}/.iterm2_shell_integration.zsh"
fi

# Brew
if [[ ! ${OS} = "darwin" && ! ${OS} = "linux-android" ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# Enable completion & Autosuggestions
if has "brew"; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  FPATH=$(brew --prefix)/share/zsh-completions:${FPATH}
  autoload -Uz compinit && compinit
fi

# asdf
[[ -f $(brew --prefix asdf)/libexec/asdf.sh ]] && source $(brew --prefix asdf)/libexec/asdf.sh

# Volta
if has "volta"; then
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
  export VOLTA_FEATURE_PNP=1
fi

# pyenv
if has "pyenv"; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# GitHub CLI
if has "gh"; then
  eval "$(gh completion -s zsh)"
fi

# Rust
[[ -f "$HOME/.cargo/env" ]] && source $HOME/.cargo/env

# PHP
if [[ ${OS} = "linux" ]]; then
  export LDFLAGS="-L/opt/homebrew/opt/php@8.0/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/php@8.0/include"
else
  export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/php@8.0/lib"
  export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/php@8.0/include"
fi

# tabtab source for packages
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh


#################################  ALIASES  #################################

# Replace grep with rg
if has "rg"; then
  alias ag"$1"="alias | rg $1"
else
  alias ag"$1"="alias | grep $1"
fi

# dotfiles
alias dot="code ${HOME}/dotfiles"
alias cdot="cd ${HOME}/dotfiles"
alias clodot="git clone git@github.com:ru-461/dotfiles.git ${HOME}/dotfiles"

# System
alias re="exec ${SHELL} -l"
alias c="clear"
alias cls="clear"
alias q="exit"
alias a="alias"
alias h="history"
alias ps="procs"
[[ ${OS} = "darwin" ]] && alias o="open ."

# cd
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# eza
if has "eza"; then
  alias ei="eza --icons --git"
  alias ea="eza -a --icons --git"
  alias ee="eza -aahl --icons --git"
  alias et="eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons"
  alias eta="eza -T -a -I 'node_modules|.git|.cache' --color=always --icons | less -r"
  alias ls=ei
  alias la=ea
  alias ll=ee
  alias lt=et
  alias lta=eta
  alias l="clear && ls"
else
  alias l="clear && ls"
fi

# Git
alias g="git"

# .zshrc
alias czsh="code ${HOME}/.zshrc"
alias szsh="source ${HOME}/.zshrc"

# ZennCLI
alias zenna="cd ${HOME}/Documents/zenn-articles"
alias zennb="cd ${HOME}/Documents/zenn-books"
alias zennop="zenna && code ${HOME}/Documents/my-zenn-contents && npx zenn preview --open"
alias zennna="zenna && npx zenn new:article"
alias zennnas="zenna && npx zenn new:article --slug"
alias zennnb="zenna && npx zenn new:book"
alias zennnbs="zenna && npx zenn new:book --slug "
alias zennpr="zenna && npx zenn preview --open"
alias zennv="zenna && npx zenn --version"

# Bun
alias bxsort="bunx sort-package-json"
alias bxserve="bunx serve"
alias bxfast="bunx fast-cli"
alias bxcheck="bunx npm-check-updates"

# Yarn
alias y="yarn"
alias ygl="yarn global list --depth=0"
alias yal="yarn list --depth=0"
alias yga="yarn global add"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yrm="yarn remove"
alias yupg="yarn upgrade"
alias yout="yarn outdated"
alias yrun="yarn run"
alias ysrun="yarn -s run"
alias ydev="yarn dev"

# fvm
alias f="fvm flutter"
alias d="fvm dart"
alias fv=".fvm/flutter_sdk/bin/flutter"

# pnpm
alias pn="pnpm"

# pip
alias p="pip"

# venv
alias va="source .venv/bin/activate"

# Multipass
alias mp="multipass"
alias mpl="multipass list"
alias mpre="multipass restart"

# scrcpy
alias sc="scrcpy"
alias sctop="scrcpy -S --always-on-top --window-x 2200 --window-y 50 -m 1080"
alias scfull="scrcpy -S --fullscreen"

# Docker
if has "docker"; then
  alias d="docker"
  alias dp="docker container ls"
  alias dpla="docker container ls --all --latest"
  alias dr="docker container run"
  alias ds="docker container stop"
  alias dx="docker exec --interactive --tty"
  alias dcrm="docker container rm --force $(docker ps --all --quiet)"
  alias di="docker image"
  alias dila="docker image ls --all"
  alias dirm="docker rmi -f $(docker images --quiet)"
  alias dn="docker network"
  alias dnls="docker network ls --all --latest"
  alias dc="docker compose"
  alias dcx="docker compose exec --interactive --tty"
  alias dcb="docker compose build --force-rm"
  alias dcup="docker compose up --detach"
  alias dcupb="docker compose up --detach --build"
  alias dcd="docker compose down"
  alias dcre="docker compose restart"
  alias dnls="docker network ls --all --latest"
  alias drm="docker system prune"
fi

# Laravel Sail
alias sail="[ -f sail ] && sh sail || sh vendor/bin/sail"

# Starship
alias ship="code ${HOME}/.config/starship.toml"

# Homebrew
alias brewL="brew leaves"
alias brewc="brew cleanup"
alias brewd="brew doctor"
alias brewi="brew install"
alias brewl="brew list"
alias brewo="brew outdated"
alias brews="brew search"
alias brewu="brew upgrade"
alias brewx="brew uninstall"
# Brew Bundle
if has "brew bundle"; then
  alias brewbnd="brew bundle --file '~/dotfiles/Brewfile'"
fi

# mas-cli
if [[ ${OS} = "darwin" ]]; then
  alias masi="mas install"
  alias masl="mas list"
  alias maso="mas outdated"
  alias mass="mas search"
  alias masu="mas upgrade"
  alias masx="mas uninstall"
fi

# Starship init
eval "$(starship init zsh)"

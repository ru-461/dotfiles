#################################  COMMON  #################################

# Colors
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

# OS judgment
case ${OSTYPE} in
  darwin*)
    OS=darwin
  ;;
  linux*)
    OS=linux
  ;;
  linux-android*)
  OS=linux-android
;;
esac

#################################  FUNCTIONS  #################################

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

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}\n"
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

has() {
  type "$1" > /dev/null 2>&1
}

_delstores () {
  sudo find $1 \( -name '.DS_Store' -or -name '._*' -or -name 'Thumbs.db' -or -name 'Desktop.ini' \) -delete -print;
}

# apt upgrade
_aptautoupgrade() {
  headline "apt"
  info "Upgrading packages..."
  run "apt update"
  sudo apt update
  run "apt upgrade"
  sudo apt upgrade -y
  run "apt autoremove"
  sudo apt autoremove -y
  run "apt clean"
  sudo apt clean -y
  info "Upgrading Done."
}

# brew upgrade
_brewautoupgrade() {
  headline "Homebrew"
  info "Upgrading brew formulas..."
  run "brew update"
  brew update
  run "brew upgrade"
  brew upgrade
  run "brew cleanup"
  brew cleanup
  run "brew doctor"
  brew doctor
  info "Upgrading Done."
}

# mas upgrade
_masautoupgrade() {
  headline "mas"
  info "Upgrading apps..."
  run "mas outdated"
  mas outdated
  run "mas upgrade"
  mas upgrade
  info "Upgrading Done."
}

_pkgautoupgrade() {
  headline "pkg"
  info "Upgrading packages..."
  run "pkg update"
  pkg update
  run "pkg upgrade"
  pkg upgrade -y
  run "pkg autoremove"
  pkg autoremove -y
  run "pkg clean"
  apt clean -y
  info "Upgrading Done."
}
# Auto upgrade
_autoupgrade() {
  info "Auto package upgrading..."
  if [[ ! $OS = "linux-android" ]]; then
    if [[ ! $OS = "darwin" ]]; then
      _aptautoupgrade
    fi
    _brewautoupgrade
    if [[ $OS = "darwin" ]]; then
      _masautoupgrade
    fi
  else
    _pkgautoupgrade
  fi
}

#################################  ZSH INIT  #################################

# Completion
zstyle ":completion:*:commands" rehash 1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''

# Cd
setopt auto_cd

# Lang
export LANG=ja_JP.UTF-8
setopt print_eight_bit

# Zsh history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Beep
setopt no_beep
setopt nolistbeep

# Configure path
typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  ~/.anyenv/bin(N-/)
  ~/.anyenv/envs/pyenv/bin(N-/)
  ~/.volta/bin(N-/)
  /Users/$USER/dev/flutter/bin(N-/)
  /usr/bin(N-/)
  /usr/sbin(N-/)
  /bin(N-/)
  /sbin(N-/)
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin(N-/)
)

#################################  TOOL INIT  #################################

# Brew
if [[ $OS = "linux" ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
else
  alias brew="PATH=/opt/homebrew/bin:/opt/homebrew/sbin brew"
fi

# Enable completion & Autosuggestions
if has "brew"; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  if [[ $OS = "darwin" ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  else
    source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  fi
  autoload -Uz compinit && compinit
fi

# anyenv
if has "anyenv"; then
  eval "$(anyenv init - no--rehash)"
fi

# pyenv
if has "pyenv"; then
  eval "$(pyenv init --path)"
fi

# GitHub CLI
if has "gh"; then
  eval "$(gh completion -s zsh)"
fi

# Replace grep with rg
if has "rg"; then
  alias ag"$1"='alias | rg $1'
else
  alias ag"$1"='alias | grep $1'
fi

#################################  ALIASES  #################################

# dotfiles
alias dot='code ~/dotfiles'
# System
alias re='source ~/.zshrc'
alias c='clear'
alias cls='clear'
alias q='exit'
alias a='alias'
alias h='history'
alias ps='procs'
alias f='open .'

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls - exa
if has "exa"; then
  alias e='exa --icons --git'
  alias l=e
  alias ls=e
  alias ea='exa -a --icons --git'
  alias la=ea
  alias ee='exa -aahl --icons --git'
  alias ll=ee
  alias et='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
  alias lt=et
  alias eta='exa -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
  alias lta=eta
  alias l='clear && ls'
else
  alias l='clear && ls'
fi

# Git
alias g='git'

# .zshrc
alias czsh='code ~/.zshrc'
alias szsh='source ~/.zshrc'

# ZennCLI
alias zenna='cd ~/Documents/zenn-articles'
alias zennb='cd ~/Documents/zenn-books'
alias zennop='zenna && code ~/Documents/my-zenn-contents && yarn zenn preview --open'
alias zennna='zenna && yarn zenn new:article'
alias zennnas='zenna && yarn zenn new:article --slug'
alias zennnb='zenna && yarn zenn new:book'
alias zennnbs='zenna && yarn zenn new:book --slug '
alias zennpr='zenna && yarn zenn preview --open'
alias zennv='zenna && yarn zenn --version'
alias zennup='zenna && yarn upgrade zenn-cli'

# anyenv
alias aganyenv='alias | rg anyenv'
alias ae='anyenv'
alias aeu='anyenv update'

# Yarn
alias y='yarn'
alias ygl='yarn global list --depth=0'
alias yal='yarn list --depth=0'
alias yga='yarn global add'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yrm='yarn remove'
alias yupg='yarn upgrade'
alias yout='yarn outdated'
alias yrun='yarn run'
alias ysrun='yarn -s run'
alias ydev='yarn dev'

# Multipass
alias mp='multipass'
alias mpl='multipass list'
alias mpre='multipass restart'

# Docker
alias d='docker'
alias dp='docker ps'
alias dpls='docker ps --latest'
alias dx='docker exec -it'
alias dcn='docker container'
alias dcls='docker container ls --all --latest'
alias dcrm='docker rm --force $(docker ps -a -q)'
alias di='docker image'
alias dils='docker image ls --all'
alias dirm='docker rmi -f $(docker images -q)'
alias dn='docker network'
alias dnls='docker network ls --all --latest'
alias dc='docker-compose'
alias dcup='docker-compose up -d'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dnls='docker network ls --all --latest'
alias drm='docker system prune'

# Starship
alias ship='code ~/.config/starship.toml'

# Homebrew
alias brewa='_brewautoupgrade'
alias brewL='brew leaves'
alias brewc='brew cleanup'
alias brewd='brew doctor'
alias brewi='brew install'
alias brewl='brew list'
alias brewo='brew outdated'
alias brews='brew search'
alias brewu='brew upgrade'
alias brewx='brew uninstall'
# Brew Bundle
if has "brew bundle"; then
  alias brewbnd='brew bundle --file '~/dotfiles/Brewfile''
fi

# mas-cli
if [[ $OS = "darwin" ]]; then
  alias masa='_masautoupgrade'
  alias masi='mas install'
  alias masl='mas list'
  alias maso='mas outdated'
  alias mass='mas search'
  alias masu='mas upgrade'
  alias masx='mas uninstall'
fi

# function
alias dsstore='find . -name '.DS_Store' -type f -ls -delete'
alias delds='find . -name ".DS_Store" -type f -ls -delete'
alias delstores=_delstores
alias au='_autoupgrade'

# Starship init
eval "$(starship init zsh)"

headline "Welcome Zsh!"
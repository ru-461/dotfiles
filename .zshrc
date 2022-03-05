# Colors
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

# Welcome message
echo -e "${COLOR_BLUE}Welcom!!${COLOR_NONE}"

# OS judgment
case ${OSTYPE} in
  darwin*)
    OS=darwin
  ;;
  linux*)
    OS=linux
  ;;
esac

# Command check
has() {
  type "$1" > /dev/null 2>&1
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

# Brew
if [[ $OS = "linux" ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
else
  alias brew="PATH=/opt/homebrew/bin:/opt/homebrew/sbin brew"
fi

# Enable completion & autosuggestions
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

# Pyenv
if has "pyenv"; then
  eval "$(pyenv init --path)"
fi

# GitHub CLI
if has "gh"; then
  eval "$(gh completion -s zsh)"
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
if has "rg"; then
  alias agcd='alias | rg cd'
else
  alias aggit='alias | grep cd'
fi
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls - exa
if has "rg"; then
  alias aglist='alias | rg ls'
else
  alias aglist='alias | grep ls'
fi

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
if has "rg"; then
  alias aggit='alias | rg git'
else
  alias aggit='alias | grep git'
fi
alias g='git'

# .zshrc
if has "rg"; then
  alias agzsh='alias | rg zsh'
else
  alias aggit='alias | grep zsh'
fi
alias czsh='code ~/.zshrc'
alias szsh='source ~/.zshrc'

# ZennCLI
if has "rg"; then
  alias agzenn='alias | rg zenn'
else
  alias agzenn='alias | grep zenn'
fi
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
if has "rg"; then
  alias agyarn='alias | rg anyenv'
else
  alias agyarn='alias | grep anyenv'
fi
alias aganyenv='alias | rg anyenv'
alias ae='anyenv'
alias aeu='anyenv update'

# Yarn
if has "rg"; then
  alias agyarn='alias | rg yarn'
else
  alias agyarn='alias | grep yarn'
fi
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
if has "rg"; then
  alias agmultipass='alias | rg multipass'
else
  alias agmultipass='alias | grep multipass'
fi
alias mp='multipass'
alias mpl='multipass list'
alias mpre='multipass restart'

# Docker
if has "rg"; then
  alias agdocker='alias | rg docker'
else
  alias agdocker='alias | grep docker'
fi
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
if has "rg"; then
  alias agship='alias | rg ship'
else
  alias agship='alias | grep ship'
fi
alias ship='code ~/.config/starship.toml'

# Homebrew
if has "rg"; then
  alias agbrew='alias | rg brew'
else
  alias agbrew='alias | grep brew'
fi
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
  if has "rg"; then
    alias agmas='alias | rg mas'
  else
    alias agmas='alias | grep mas'
  fi
  alias masa='_masautoupgrade'
  alias masi='mas install'
  alias masl='mas list'
  alias maso='mas outdated'
  alias mass='mas search'
  alias masu='mas upgrade'
  alias masx='mas uninstall'
fi

#################################  FUNCTIONS  #################################

_headline() {
  echo -e "\n${COLOR_GRAY}==============================${COLOR_NONE}"
  echo -e "${COLOR_PURPLE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

# Delete mac stores
alias dsstore='find . -name '.DS_Store' -type f -ls -delete'
alias delds='find . -name ".DS_Store" -type f -ls -delete'

function _delstores () {
  sudo find $1 \( -name '.DS_Store' -or -name '._*' -or -name 'Thumbs.db' -or -name 'Desktop.ini' \) -delete -print;
}
alias delstores=_delstores

# brew upgrade
_brewautoupgrade() {
  _headline "Upgrading brew"
  echo "Upgrading brew formulas..."
  echo -e "${COLOR_YELLOW}brew update${COLOR_NONE}"
  brew update
  echo -e "${COLOR_YELLOW}brew upgrade${COLOR_NONE}"
  brew upgrade
  echo -e "${COLOR_YELLOW}brew cleanup${COLOR_NONE}"
  brew cleanup
  echo -e "${COLOR_YELLOW}brew doctor${COLOR_NONE}"
  brew doctor
  echo "Done."
}

# apt upgrade
_aptautoupgrade() {
  _headline "Upgrading apt"
  echo "Upgrading packages..."
  echo -e "${COLOR_YELLOW}apt update${COLOR_NONE}"
  sudo apt update
  echo -e "${COLOR_YELLOW}apt upgrade${COLOR_NONE}"
  sudo apt upgrade -y
  echo -e "${COLOR_YELLOW}apt autoremove${COLOR_NONE}"
  sudo apt autoremove -y
  echo -e "${COLOR_YELLOW}apt clean${COLOR_NONE}"
  sudo apt clean -y
  echo "Done."
}

# mas upgrade
_masautoupgrade() {
  _headline "Upgrading mas"
  echo "Upgrading apps..."
  echo -e "${COLOR_BLUE}mas outdated${COLOR_NONE}"
  mas outdated
  echo -e "${COLOR_BLUE}mas upgrade${COLOR_NONE}"
  mas upgrade
  echo "Done."
}

# Auto upgrade
_autoupgrade() {
  if [[ ! $OS = "darwin" ]]; then
    _aptautoupgrade
  fi
  _brewautoupgrade
  if [[ $OS = "darwin" ]]; then
    _masautoupgrade
  fi
}
alias au='_autoupgrade'

# Starship init
eval "$(starship init zsh)"
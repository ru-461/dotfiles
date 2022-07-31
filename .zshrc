#################################  COMMON  #################################

# Load common functions
source ${HOME}/dotfiles/functions/_init.sh

# Load functions
for FUNCTION in ${HOME}/dotfiles/functions/*.sh; do
  if [[ ${FUNCTION} != "${HOME}/dotfiles/functions/_init.sh" ]]; then
    source ${FUNCTION}
  fi
done

# OS
case ${OSTYPE} in
  linux-android*)
    OS=linux-android
  ;;
  darwin*)
    OS=darwin
  ;;
  linux*)
    OS=linux
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
setopt HIST_IGNORE_DUPS
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=${HOME}/.zsh_history

# Beep
setopt no_beep
setopt nolistbeep

# Configure path
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  ${HOME}/.anyenv/bin(N-/)
  ${HOME}/.anyenv/envs/pyenv/bin(N-/)
  ${HOME}/.volta/bin(N-/)
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
  ${path}
)

#################################  TOOL INIT  #################################

# Brew
if [[ ! ${OS} = "darwin" && ! ${OS} = "linux-android" ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# Enable completion & Autosuggestions
if has "brew"; then
    FPATH=$(brew --prefix)/share/zsh-completions:${FPATH}
  if [[ ${OS} = "darwin" ]]; then
    alias brew="env PATH=${PATH/\/Users\/${USER}\/\.anyenv\/envs\/pyenv\/shims:/} brew"
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

# pipenv
export PIPENV_VENV_IN_PROJECT=true

# php
if [[ ${OS} = "linux" ]]; then
  export LDFLAGS="-L/opt/homebrew/opt/php@8.0/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/php@8.0/include"
else
  export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/php@8.0/lib"
  export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/php@8.0/include"
fi

# GitHub CLI
if has "gh"; then
  eval "$(gh completion -s zsh)"
fi

# Replace grep with rg
if has "rg"; then
  alias ag"$1"="alias | rg $1"
else
  alias ag"$1"="alias | grep $1"
fi

#################################  ALIASES  #################################

# dotfiles
alias dot="code ${HOME}/dotfiles"
alias cdot="cd ${HOME}/dotfiles"
alias clodot="git clone git@github.com:ryu-461/dotfiles.git ${HOME}/dotfiles"

# System
alias re="exec ${SHELL} -l"
alias c="clear"
alias cls="clear"
alias q="exit"
alias a="alias"
alias h="history"
alias ps="procs"
if [[ ${OS} = "darwin" ]]; then
  alias f="open ."
fi

# cd
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ls - exa
if has "exa"; then
  alias e="exa --icons --git"
  alias l=e
  alias ls=e
  alias ea="exa -a --icons --git"
  alias la=ea
  alias ee="exa -aahl --icons --git"
  alias ll=ee
  alias et="exa -T -L 3 -a -I 'node_modules|.git|.cache' --icons"
  alias lt=et
  alias eta="exa -T -a -I 'node_modules|.git|.cache' --color=always --icons | less -r"
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
alias zennop="zenna && code ${HOME}/Documents/my-zenn-contents && yarn zenn preview --open"
alias zennna="zenna && yarn zenn new:article"
alias zennnas="zenna && yarn zenn new:article --slug"
alias zennnb="zenna && yarn zenn new:book"
alias zennnbs="zenna && yarn zenn new:book --slug "
alias zennpr="zenna && yarn zenn preview --open"
alias zennv="zenna && yarn zenn --version"
alias zennup="zenna && yarn upgrade zenn-cli"

# anyenv
alias ae="anyenv"
alias aeu="anyenv update"

# Volta
alias voltaup="curl https://get.volta.sh | bash -s -- --skip-setup"

# npx
alias npsort="npx sort-package-json"
alias npserve="npx serve"
alias npfast="npx fast-cli"
alias npcheck="npx npm-check-updates"

# yarn
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

# pip
alias p="pip"

# pipenv
alias pe="pipenv"

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
  alias dc="docker-compose"
  alias dcb="docker-compose build --force-rm"
  alias dcup="docker-compose up --detach"
  alias dcupb="docker-compose up --detach --build"
  alias dcd="docker-compose down"
  alias dcre="docker-compose restart"
  alias dnls="docker network ls --all --latest"
  alias drm="docker system prune"
fi

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

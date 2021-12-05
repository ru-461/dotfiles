# Welcome message
echo -e "\e[1;3;36mWelcom!!\e[m"

#################################  ZSH INIT  #################################

# zsh history
setopt histignorealldups
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# compinit
autoload -Uz compinit
compinit

# Lang
export LANG=ja_JP.UTF-8

# beep
setopt no_beep
setopt nolistbeep

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

case ${OSTYPE} in
    darwin*)
    # brew
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/sbin:$PATH"
    alias brew="PATH=/opt/homebrew/bin:/opt/homebrew/sbin  brew "
    # Flutter
    export PATH="$PATH:/Users/$USER/dev/flutter/bin"
    ;;
    linux*)
    # brew
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    ;;
esac

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# anyenv
eval "$(anyenv init - no--rehash)"

# pyenv
if [[ $(command -v pyenv) ]]; then
	export PYENV_ROOT="$HOME/.anyenv/envs/pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init --path)"
	if command -v pyenv 1>/dev/null 2>&1; then
		eval "$(pyenv init -)"
	fi
fi

# GitHub CLI
if [[ $(command -v pyenv) ]]; then
  eval "$(gh completion -s zsh)"
fi

#################################  ALIASES  #################################

# dotfiles
alias dot='code ~/dotfiles'
# System
alias re='$SHELL -l'
alias c='clear'
alias q='exit'
alias a='alias'
alias h='history'
alias ps='procs'
alias f='open .'

# cd
if [[ $(command -v rg) ]]; then
  alias agcd='alias | rg cd'
else
  alias aggit='alias | grep cd'
fi
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls - exa
if [[ $(command -v rg) ]]; then
  alias aglist='alias | rg ls'
else
  alias aglist='alias | grep ls'
fi

if [[ $(command -v exa) ]]; then
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
if [[ $(command -v rg) ]]; then
  alias aggit='alias | rg git'
else
  alias aggit='alias | grep git'
fi
alias g='git'

# for macOS
alias dsstore='find . -name '.DS_Store' -type f -ls -delete'
alias delds='find . -name ".DS_Store" -type f -ls -delete'

# .zshrc
if [[ $(command -v rg) ]]; then
  alias agzsh='alias | rg zsh'
else
  alias aggit='alias | grep zsh'
fi
alias zsh='code ~/.zshrc'
alias szsh='source ~/.zshrc'

# ZennCLI
if [[ $(command -v rg) ]]; then
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

# Yarn
if [[ $(command -v rg) ]]; then
  alias agyarn='alias | rg yarn'
else
  alias agyarn='alias | rg yarn'
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

# Homebrew
if [[ $(command -v rg) ]]; then
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

# anyenv
alias aganyenv='alias | rg anyenv'
alias ae='anyenv'
alias aeu='anyenv update'

# mas
if [[ $(command -v rg) ]]; then
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

# Docker
if [[ $(command -v rg) ]]; then
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
alias di='docker image'
alias dils='docker image ls --all'
alias dn='docker network'
alias dnls='docker network ls --all --latest'
alias dc='docker-compose'
alias dcup='docker-compose up -d'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dnls='docker network ls --all --latest'
alias drm='docker system prune'

# Starship
if [[ $(command -v rg) ]]; then
  alias agship='alias | rg ship'
else
  alias agship='alias | grep ship'
fi
alias eship='code ~/.config/starship.toml'

#################################  FUNCTIONS  #################################

function _delstores () {
    sudo find $1 \( -name '.DS_Store' -or -name '._*' -or -name 'Thumbs.db' -or -name 'Desktop.ini' \) -delete -print;
}
alias delstores=_delstores

# brew upgrade
_brewautoupgrade() {
  echo "Upgrading formula..."
  echo -e "\e[1;3;33mbrew upgrade\e[m"
  brew upgrade
  echo -e "\e[1;3;33mbrew cleanup\e[m"
  brew cleanup
  echo -e "\e[1;3;33mbrew doctor\e[m"
  brew doctor
  echo "done. "
}

# apt upgrade
_aptautoupgrade() {
  echo "upgrading packages..."
  echo -e "\e[1;3;32mapt update & apt upgrade\e[m"
  aptu -y
  echo -e "\e[1;3;32mapt autoremove\e[m"
  aptar
  echo "done."
}

# mas upgrade
_masautoupgrade() {
  echo "Upgrading apps..."
  echo -e "\e[1;3;32mmas outdated\e[m"
  mas outdated
  echo -e "\e[1;3;32mmas upgrade\e[m"
  mas upgrade
  echo "done."
}

# Autoupgrade
alias au='_autoupgrade'
_autoupgrade() {
  _brewautoupgrade
  echo ------------------------------------------------------------------------------
  _masautoupgrade
}

# Starship
eval "$(starship init zsh)"
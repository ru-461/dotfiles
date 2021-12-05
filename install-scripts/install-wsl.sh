# #!/usr/bin/env zsh
# set -eux

# install Linuxbrew
if [[ $(command -v brew) ]]; then
    echo "Linuxbrew is missing, install a new one."
    sudo apt install build-essential curl file git
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Setting up."
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
    exec $SHELL -l
else
    echo "Skip to Linuxbrew."
    brew update
fi
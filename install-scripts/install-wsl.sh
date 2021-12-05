# #!/usr/bin/env zsh
# set -eux

# Install Linuxbrew
if !(type "brew" > /dev/null 2>&1); then
    echo "Linuxbrew is missing, install a new one."
    sudo apt install build-essential curl file git
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "done."
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
    source ~/.profile
else
    echo "Linuxbrew is already installed, skip to install."
fi

# Install Zsh
if !(type "zsh" > /dev/null 2>&1); then
    echo "Zsh is missing, install a new one."
    brew install zsh
    echo "Setting default..."
    sudo sh -c 'echo $(brew --prefix)/bin/zsh >> /etc/shells'
    chsh -s $(brew --prefix)/bin/zsh
    echo "Loading .zshrc"
    source ../.zshrc
else
    echo "Zsh is already installed, skip to install."
fi
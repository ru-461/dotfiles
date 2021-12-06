# #!/usr/bin/env zsh
# set -eux

# install Homebrew
which -s brew
if [[ $? != 0 ]] ; then
  echo "Homebrew is missing, install a new one."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Upgrading formula..."
  echo "brew upgrade"
  brew upgrade
  echo "brew cleanup"
  brew cleanup
  echo "brew doctor"
  brew doctor
  echo "done. "
  echo "Install the package from Brewfile."
  brew bundle --file '../Brewfile'
else
  echo "Skip to Homebrew."
  brew update
fi
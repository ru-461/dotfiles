#!/usr/bin/env bash

set -ue

DOT_BASE=$HOME/dotfiles
DOT_REMOTE=https://github.com/ryu-461/dotfiles.git

echo "=============================================================================="
echo "Start Installation."

# Environmental determination Mac or WSL or Linux
if [ $(uname) == 'Darwin' ]; then
  echo "Your environment is a Mac, Start deployment for macOS."
  # Run install script
  sh $DOT_BASE/install-scripts/install-mac.sh
elif [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  echo "Your environment is a Windows Subsystem for Linux, Start deployment for WSL."
  cd $HOME
  # Update packages
  echo "Updating the package to the latest ..."
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install git -y
  # Clone dotfile repository locally
  echo "Cloning the dotfiles repository ..."
  git clone $DOT_REMOTE
  # Run install script
  sh $DOT_BASE/install-scripts/install-wsl.sh
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  cd $HOME
  echo "Your environment is a Linux, Start deployment for Linux."
  # Update packages
  echo "Updating the package to the latest ..."
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install git -y
  # Clone dotfile repository locally
  echo "Cloning the dotfiles repository ..."
  git clone $DOT_REMOTE
  # Run install script
  sh $DOT_BASE/setup-scripts/install-linux.sh
else
  exit 1
fi
echo "Installation complete."
echo "=============================================================================="

echo "Expanding symbolic links ..."
dotfiles=(.zshrc)
for file in "${dotfiles[@]}"; do
  [[ "$file" == ".git" ]] && continue
  [[ "$file" == ".gitignore" ]] && continue
  [[ "$file" == ".DS_Store" ]] && continue
  ln -svf ~/dotfiles/${file} ~/${file}
done
echo "Symbolic link expansion is complete."
echo "Happy Hacking!!"
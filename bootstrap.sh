#!/usr/bin/env bash

set -ue

DOT_BASE=$HOME/dotfiles

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
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install git -y
  # Clone dotfile repository locally
  git clone https://github.com/ryu-461/dotfiles.git
  # Run install script
  sh $DOT_BASE/install-scripts/install-wsl.sh
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  cd $HOME
  echo "Your environment is a Linux, Start deployment for Linux."
  # Update packages
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install git -y
  # Clone dotfile repository locally
  git clone https://github.com/ryu-461/dotfiles.git
  # Run install script
  sh $DOT_BASE/setup-scripts/install-linux.sh
else
  exit 1
fi
echo "Installation complete."
echo "=============================================================================="
echo "Start Deployment."

# Create simlink
dotfiles=(.zshrc)
for file in "${dotfiles[@]}"; do
  [[ "$file" == ".git" ]] && continue
  [[ "$file" == ".gitignore" ]] && continue
  [[ "$file" == ".DS_Store" ]] && continue
  ln -svf ~/dotfiles/${file} ~/${file}
done

echo "Deployment complete."
echo "Happy Hacking!!"
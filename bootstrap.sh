#!/usr/bin/env zsh

set -e

DOTBASE=$HOME/dotfiles
ENV=$(uname)

echo "=============================================================================="
echo "Start Installation."
# Environmental determination Mac or WSL or Linux
if [ $ENV == 'Darwin' ]; then
  echo "Your environment is a Mac. Start deployment for macOS."
  # Run install script
  sh ./setup-scripts/install-mac.sh
elif [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  echo "Your environment is a Windows Subsystem for Linux. Start deployment for WSL."
  cd $HOME
  # Update packages
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install git -y
  # Clone dotfile repository locally
  git clone https://github.com/ryu-461/dotfiles.git
  cd dotfiles
  # Run install script
  sh ./setup-scripts/install-wsl.sh
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  cd $HOME
  echo "Your environment is a Start deployment for Linux."
  # Update packages
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install git -y
  # Clone dotfile repository locally
  git clone https://github.com/ryu-461/dotfiles.git
  # Run install script
  sh ./setup-scripts/install-linux.sh
else
  exit 1
fi
echo "Installation complete."
echo "=============================================================================="
echo "Start Deployment."

# Create simlink
dotfiles=(.zshrc)
for file in "${dotfiles[@]}"; do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".gitignore" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  ln -svf ~/dotfiles/${file} ~/${file}
done

echo "Deployment complete."
echo "Happy Hacking!!"
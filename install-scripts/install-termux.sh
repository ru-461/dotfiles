#!/usr/bin/env bash

set -ue

echo "Start Installation for Termux."

# In order to have access to shared storage
if [[ ! -d $HOME/dotfiles ]]; then
  echo "Access to shared storage."
  termux-setup-storage
  echo "done."
fi
echo ""

echo "Updating the packages to the latest ..."
echo "Use Pkg."
  pkg update && pkg upgrade -y
  pkg install wget git curl proot vim -y
echo "done."
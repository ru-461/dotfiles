#!/usr/bin/env bash

set -ue

echo "Start Installation for Termux."

# In order to have access to shared storage
termux-setup-storage

echo "Updating the packages to the latest ..."
echo "Use Pkg."
  pkg update && pkg upgrade -y
  pkg apt install wget git curl proot vim -y
echo "done."

echo "Installation complete."
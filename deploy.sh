#!/usr/bin/env bash

set -ue

cd $DOT_BASE

echo "Expanding symbolic links ..."

# to home
for file in .??*; do
  [[ "$file" == ".DS_Store" ]] && continue
  [[ "$file" == ".git" ]] && continue
  [[ "$file" == ".gitignore" ]] && continue
  ln -svfv "$(pwd)/$file" "$HOME/$file"
done

# to .Config
mkdir -p $HOME/.config
for file in "$(ls .config)"; do
  ln -snfv "$(pwd)/.config/$file" "$HOME/.config/$file"
done

echo "Symbolic link expansion is complete."
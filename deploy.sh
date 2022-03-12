#!/usr/bin/env bash

set -ue

if [[ -d $HOME/dotfiles ]]; then
  DOT_BASE=$HOME/dotfiles
  echo -e "\033[1;34mStart to deploy symlink.\033[1;34m"
else
  echo -e "\033[1;31mDotfiles is missing.\033[1;31m"
  exit 1
fi

echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo ""
for file in $(find . -not -path '*.git/*' -not -path '*.DS_Store' -path '*/.*' -type f -print | cut -b3-)
do
  mkdir -p "$HOME/$(dirname "$file")"
  if [ -L "$HOME/$file" ]; then
    ln -sfv "$DOT_BASE/$file" "$HOME/$file"
  else
    ln -sniv "$DOT_BASE/$file" "$HOME/$file"
  fi
done
echo ""
echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\033[1;32mEnd of symlink expansion.\033[1;32m\n"
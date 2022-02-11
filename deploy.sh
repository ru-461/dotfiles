#!/usr/bin/env bash

set -ue

echo "Expanding symbolic links ..."
echo "-------------------------------"

for file in $(find . -not -path '*.git/*' -not -path '*.DS_Store' -path '*/.*' -type f -print | cut -b3-)
do
  mkdir -p "$HOME/$(dirname "$file")"
  if [ -L "$HOME/$file" ]; then
    ln -sfv "$DOT_BASE/$file" "$HOME/$file"
  else
    ln -sniv "$DOT_BASE/$file" "$HOME/$file"
  fi
done

echo "-------------------------------"
echo "Symbolic link expansion is complete."
echo ""
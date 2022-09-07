#!/usr/bin/env bash

DOT_BASE=${HOME}/dotfiles

if [[ ! -d ${HOME}/dotfiles ]]; then
  error "Dotfiles is missing."
  exit 1
fi

info "Start to deploy"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo ""
if [[ $(uname) == "Darwin" ]]; then
  for FILE in $(find . -not -path "*.git/*" -not -path "*.DS_Store" -path "*/.*" -type f -print | cut -b3-)
  do
    mkdir -p "${HOME}/$(dirname "${FILE}")"
    if [ -L "${HOME}/${FILE}" ]; then
      ln -sfv "${DOT_BASE}/${FILE}" "${HOME}/${FILE}"
    else
      ln -sniv "${DOT_BASE}/${FILE}" "${HOME}/${FILE}"
    fi
  done
else
  for FILE in $(find . -not -path "*.git/*" -not -path "*.DS_Store" -not -path "*karabiner*" -path "*/.*" -type f -print | cut -b3-)
  do
    mkdir -p "${HOME}/$(dirname "${FILE}")"
    if [ -L "${HOME}/${FILE}" ]; then
      ln -sfv "${DOT_BASE}/${FILE}" "${HOME}/${FILE}"
    else
      ln -sniv "${DOT_BASE}/${FILE}" "${HOME}/${FILE}"
    fi
  done
fi
echo ""
echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
success "End of symlink expansion."

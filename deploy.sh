#!/usr/bin/env bash

DOT_BASE=${HOME}/dotfiles

if [[ ! -d ${DOT_BASE} ]]; then
  error "dotfiles is missing."
  exit 1
fi

info "Start to deploy."
echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo ""
if [[ $(uname) == "Darwin" ]]; then
  while IFS= read -r -d '' FILE; do
    FILE=${FILE#./}
    mkdir -p "${HOME}/$(dirname "${FILE}")"
    if [ -L "${HOME}/${FILE}" ]; then
      ln -sfv "${DOT_BASE}/${FILE}" "${HOME}/${FILE}"
    else
      ln -sniv "${DOT_BASE}/${FILE}" "${HOME}/${FILE}"
    fi
  done < <(find . -not -path "*.git/*" -not -path "*.DS_Store" -path "*/.*" -type f -print0)
else
  while IFS= read -r -d '' FILE; do
    FILE=${FILE#./}
    mkdir -p "${HOME}/$(dirname "${FILE}")"
    if [ -L "${HOME}/${FILE}" ]; then
      ln -sfv "${DOT_BASE}/${FILE}" "${HOME}/${FILE}"
    else
      ln -sniv "${DOT_BASE}/${FILE}" "${HOME}/${FILE}"
    fi
  done < <(find . -not -path "*.git/*" -not -path "*.DS_Store" -not -path "*karabiner*" -path "*/.*" -type f -print0)
fi
echo ""
echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
success "End of symlink expansion."

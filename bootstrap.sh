#!/usr/bin/env zsh

echo -e "\e[1;3;36mWelcom!!\e[m"
# echo -e "\e[1;3;36mWelcom!!\e[m"
# echo -e "\e[1;3;36mStart of deployment.\e[m"

# List
dotfiles=(.zshrc)

# Create simlink
for file in "${dotfiles[@]}"; do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  ln -svf ~/dotfiles/${file} ~/${file}
done

echo -e "\e[1;3;36mDeployment complete.\e[m"
echo -e "\e[1;3;36mHappy Hacking!!\e[m"
#!/bin/bash
#Make sure HOME is set
: "${HOME:?Need to set HOME}"

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

SEARCH_PREFIX="./files"

# Create the directory structure if necessary
for DIRECTORY in $(find "$SEARCH_PREFIX" -type d); do
  DESTINATION="$HOME${DIRECTORY#"$SEARCH_PREFIX"}"
  mkdir -p "$DESTINATION"
done

# Go through all of the files that need to be used, making
# symlinks here and overwriting previous symlinks but not files
for FILE in $(find "$SEARCH_PREFIX" -type f); do
  DESTINATION="$HOME/${FILE#"$SEARCH_PREFIX/"}"
  if [ -h "$DESTINATION" ]; then
    echo "${green}Symlink exists at $DESTINATION, overwriting${reset}"
    rm "$DESTINATION"
    ln -s "$(pwd)/$FILE" "$DESTINATION"
  elif [ -f "$DESTINATION" ]; then
    >&2 echo "${red}$DESTINATION already exists${reset}"
  else
    echo "${green}Making file $DESTINATION${reset}"
    ln -s "$(pwd)/$FILE" "$DESTINATION"
  fi
done

if [ -h "$HOME/.vimrc" ]; then
  echo "${green}Symlink exists at $HOME/.vimrc, overwriting${reset}"
  rm "$HOME/.vimrc"
  ln -s "$HOME/.config/nvim/init.vim" "$HOME/.vimrc"
elif [ ! -f $HOME/.vimrc ]; then
  ln -s "$HOME/.config/nvim/init.vim" "$HOME/.vimrc"
fi

vim +PlugInstall +PlugUpdate +qall

# Populate github_installs with ["user/repo"]="./installation_command"
declare -A github_installs=(["powerline/fonts"]="./install.sh")
for repo in ${!github_installs[@]}; do
  (rm -rf /tmp/$repo && mkdir -p /tmp/$repo && git clone https://github.com/$repo /tmp/$repo --depth 1 && cd /tmp/$repo && ${github_installs["$repo"]})
done

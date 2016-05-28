#Make sure HOME is set
: "${HOME:?Need to set HOME}"

# Create the directory structure if necessary
for DIRECTORY in $( \
  find . -type d -not -path "./.git*" ); do
  mkdir -p "$HOME/$DIRECTORY"
done

# Go through all of the files that need to be used, making
# symlinks here and overwriting previous symlinks but not files
for FILE in $( \
  find . -type f -not -path "./.git/*" \
                 -not -path "./install.sh" ); do
  if [ -f "$HOME/$FILE" ]; then
    echo "$HOME/$FILE already exists"
  elif [ -h "$HOME/$FILE" ]; then
    echo "Symlink exists at $HOME/$FILE, overwriting"
    rm "$HOME/$FILE"
    ln -s "$(pwd)/$FILE" "$HOME/$FILE"
  else
    echo "Making file $HOME/$FILE"
    ln -s "$(pwd)/$FILE" "$HOME/$FILE"
  fi
done

ln -s "$HOME/.config/nvim/init.vim" "$HOME/.vimrc"

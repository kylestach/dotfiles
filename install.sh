#Make sure HOME is set
: "${HOME:?Need to set HOME}"

SEARCH_PREFIX="./files"

# Create the directory structure if necessary
for DIRECTORY in $(find "$SEARCH_PREFIX" -type d); do
  mkdir -p "$HOME/$DIRECTORY"
done

# Go through all of the files that need to be used, making
# symlinks here and overwriting previous symlinks but not files
for FILE in $(find "$SEARCH_PREFIX" -type f); do
  DESTINATION="$HOME/${FILE#"$SEARCH_PREFIX/"}"
  if [ -f "$DESTINATION" ]; then
    echo "$DESTINATION already exists"
  elif [ -h "$DESTINATION" ]; then
    echo "Symlink exists at $DESTINATION, overwriting"
    rm "$DESTINATION"
    ln -s "$(pwd)/$FILE" "$DESTINATION"
  else
    echo "Making file $DESTINATION"
    ln -s "$(pwd)/$FILE" "$DESTINATION"
  fi
done

ln -s "$HOME/.config/nvim/init.vim" "$HOME/.vimrc"

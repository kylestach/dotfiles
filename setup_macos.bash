#!/bin/bash

source setup_functions.bash

# Neovim
checked_install check_neovim install_neovim 0.10.0
symlink_replace `realpath nvim` $HOME/.config/nvim

# Fallback vimrc
symlink_replace `realpath vimrc` $HOME/.vimrc

# Terminal (kitty)
symlink_replace `realpath kitty` $HOME/.config/kitty
checked_install check_kitty install_kitty

# Other miscellaneous configs
symlink_replace `realpath tmux.conf` $HOME/.tmux.conf

# SSH setup
echo "Remember to copy SSH keys to this machine!"
symlink_replace `realpath ssh` $HOME/.ssh

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Window manager
checked_install check_yabai install_yabai
checked_install check_skhd install_skhd
symlink_replace `realpath yabai` $HOME/.config/yabai

# ZSH and OMZ
chsh -s /bin/zsh kstachowicz
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "export PATH=\$PATH:$PATH_ADDONS" >> .zshenv
symlink_replace `realpath .zshrc` $HOME/.zshrc
symlink_replace `realpath .zshenv` $HOME/.zshenv
install_zsh_plugins
$HOME/miniforge3/mamba init zsh

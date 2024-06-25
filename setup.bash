#!/bin/bash

source setup_functions.bash

# Basic system utilities
sudo apt-get update && sudo apt-get -y install \
    curl wget zip openssh-server tmux zsh luajit luarocks liblua5.1-dev libmagickwand-dev

mkdir -p $HOME/.config
mkdir -p $HOME/.local
PATH_ADDONS='$HOME/.local/bin'

# Miniforge
checked_install check_mamba install_mamba 24.3.0-0

# Neovim
checked_install check_neovim install_neovim 0.10.0
symlink_replace `realpath nvim` $HOME/.config/nvim

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

## Desktop apps
install_ubuntu_desktop_apps

# ZSH and OMZ
chsh -s /bin/zsh kstachowicz
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "export PATH=\$PATH:$PATH_ADDONS" >> .zshenv
symlink_replace `realpath .zshrc` $HOME/.zshrc
symlink_replace `realpath .zshenv` $HOME/.zshenv
install_zsh_plugins
$HOME/miniforge3/mamba init zsh

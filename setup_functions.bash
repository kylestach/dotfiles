is_ubuntu() {
    [ -f /etc/lsb-release ] && grep -q "DISTRIB_ID=Ubuntu" /etc/lsb-release
}
is_macos() {
    [ "$(uname)" == "Darwin" ]
}
macos_only() {
    if ! is_macos; then
        echo "The function $1 is only available on macOS."
        return 1
    fi
}
ubuntu_only() {
    if ! is_ubuntu; then
        echo "The function $1 is only available on Ubuntu."
        return 1
    fi
}

symlink_replace() {
    local source="$1"
    local dest="$2"

    # Check if source exists
    if [ ! -e "$source" ]; then
        echo "Error: Source '$source' does not exist."
        return 1
    fi

    # Check if destination exists
    if [ -e "$dest" ]; then
        # Check if destination is a symlink
        if [ -L "$dest" ]; then
            echo "Destination '$dest' exists and is a symlink."
        else
            echo "Destination '$dest' exists and is not a symlink."
            echo "Contents of '$dest':"
            ls -la "$dest"
        fi

        # Ask user for confirmation
        read -p "Do you want to delete the existing destination and create a symlink? [y/N] " response
        if [[ ! $response =~ ^[Yy]$ ]]; then
            echo "Operation cancelled."
            return 0
        fi

        # If it's a directory (not a symlink), move contents to .bak
        if [ -d "$dest" ] && [ ! -L "$dest" ]; then
            local backup="${dest}.bak"
            mv "$dest" "$backup"
            echo "Moved existing contents to $backup"
        else
            rm -f "$dest"
        fi
    fi

    # Create the symlink
    ln -s "$source" "$dest"
    echo "Created symlink from $source to $dest"
}

checked_install() {
    local check_command="$1"
    local install_command="$2"
    shift 2  # Remove the first two arguments, leaving any remaining for the install command

    # Run the check command
    if ! $check_command; then
        echo "Check command '$check_command' failed. Running install command."
        # Run the install command with any additional arguments
        $install_command "$@"
        # Check if the installation was successful
        if [ $? -eq 0 ]; then
            echo "Installation successful."
        else
            echo "Installation failed."
            return 1
        fi
    else
        echo "Check command '$check_command' succeeded. No installation needed."
    fi
}

check_mamba() {
    command -v mamba &> /dev/null
}
install_mamba() {
    local TARGET_VERSION=$1
    wget https://github.com/conda-forge/miniforge/releases/download/$TARGET_VERSION/Miniforge3-Linux-x86_64.sh -o /tmp/Miniforge3-Linux-x86_64.sh
    sh /tmp/Miniforge3-Linux-x86_64.sh
}


check_brew() {
    command -v brew &> /dev/null
}
install_brew() {
    macos_only install_brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

check_neovim() {
    local NEOVIM_TARGET_VERSION=$1

    if command -v nvim &> /dev/null
    then
        # Get the first line of nvim -v output
        version_line=$(nvim -v | head -n 1)
        # Extract version number
        version=$(echo $version_line | grep -oP 'NVIM v\K[0-9]+\.[0-9]+\.[0-9]+')

        if [[ $(echo -e "$version\n$NEOVIM_TARGET_VERSION" | sort -V | head -n1) == "$NEOVIM_TARGET_VERSION" ]]
        then
            return 0
        else
            return 2
        fi
    else
        return 1
    fi
}
install_neovim() {
    if is_ubuntu; then
        sudo apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
        wget https://github.com/neovim/neovim/releases/download/v$TARGET_VERSION/nvim-linux64.tar.gz -o /tmp/nvim-linux64.tar.gz
        tar -C $HOME/.local/ -xvf /tmp/nvim-linux64.tar.gz
    elif is_macos; then
        brew install neovim
    fi
}

check_kitty() {
    command -v kitty &> /dev/null
}
install_kitty() {
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    # Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
    # your system-wide PATH)
    ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/
    echo -e "#!/bin/bash\n$HOME"'/.local/kitty.app/bin/kitty --listen-on=unix:@"$(date +%s%N)"' > $HOME/.local/bin/kitty
    chmod +x $HOME/.local/bin/kitty
    # Place the kitty.desktop file somewhere it can be found by the OS
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    # Update the paths to the kitty and its icon in the kitty desktop file(s)
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
    echo 'kitty.desktop' > ~/.config/xdg-terminals.list
    gsettings set org.gnome.desktop.default-applications.terminal exec "$HOME/.local/bin/kitty"
    kitten themes "Github Dark"
}


install_ubuntu_desktop_apps() {
    ubuntu_only install_ubuntu_desktop_apps

    # 1Password
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    sudo apt-get update && sudo apt-get -y install 1password snapd

    # Others
    sudo snap install slack todoist spotify
}

check_yabai() {
    command -v yabai &> /dev/null
}
install_yabai() {
    macos_only install_yabai
    brew install koekeishiya/formulae/yabai
    brew services start yabai
}

install_zsh_plugin() {
    local PLUGIN=$1
    local GIT_URL=$2
    local TARGET_DIR=$HOME/.oh-my-zsh/custom/plugins/$PLUGIN
    if [ -d $TARGET_DIR ]; then
        cd $TARGET_DIR
        git pull
        cd -
    else
        git clone $GIT_URL $TARGET_DIR
    fi
}
install_zsh_plugins() {
    install_zsh_plugin zsh_codex 'https://github.com/tom-doerr/zsh_codex'
    install_zsh_plugin zsh-syntax-highlighting 'https://github.com/zsh-users/zsh-syntax-highlighting.git'
    install_zsh_plugin zsh-autosuggestions 'https://github.com/zsh-users/zsh-autosuggestions'
    install_zsh_plugin conda-zsh-completion 'https://github.com/conda-incubator/conda-zsh-completion'

    curl -sS https://starship.rs/install.sh | sh
}

install_fonts() {
    mkdir -p $HOME/.local/share/fonts
    wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/NerdFontsSymbolsOnly.tar.xz" -o /tmp/NerdFontsSymbolsOnly.tar.xz
    tar -C $HOME/.local/share/fonts -xf /tmp/NerdFontsSymbolsOnly.tar.xz
    sudo fc-cache -fr
}

install_gcloud_cli() {
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz -o /tmp/google-cloud-cli-linux-x86_64.tar.gz
    tar -xvf /tmp/google-cloud-cli-linux-x86_64.tar.gz -C $HOME
    $HOME/google-cloud-sdk/install.sh
}

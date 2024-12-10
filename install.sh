# Install nvim, zsh, oh-my-zsh
pkgManager=dnf
# sudo dnf install zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#
# sudo dnf install -y neovim python3-neovim
# sudo dnf install nvim
# git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# sudo dnf install zsh-syntax-highlighting zsh-autosuggestions
# 
#
# CrOeate symlinks 
mkdir -p "$HOME/.dotfiles.bkp"
for file in $(ls -a); do
  # Skip directories (.) and (..) as well as specific files
  if [[ "$file" != "." && "$file" != ".." && "$file" != ".gitignore" && "$file" != "install.sh" && "$file" != ".git" ]]; then
    # Define the target symlink path
    target="$HOME/.config/$file"

    # Check if the file already exists in the target directory
    if [[ -e "$target" ]]; then
      # Backup the existing file or symlink
      mv "$target" "$HOME/.dotfiles.bkp/$file"
      echo "Backed up existing $file to $HOME/.dotfiles.bkp"
    fi

    # Create the symlink in $HOME/.config
    ln -s "$(pwd)/$file" "$target"
    echo "Created symlink for $file in $HOME/.config"
  fi
done
mv $HOME/.zshrc $HOME/.dotfiles.bkp/
mv $HOME/.tmux.conf $HOME/.dotfiles.bkp/.tmux.conf

ln -s $(pwd)/.zshrc $HOME/.zshrc
ln -s $(pwd)/.tmux.conf $HOME/.tmux.conf

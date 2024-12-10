# ./install.sh <pkg_manager e.g. apt>
# Install nvim, zsh, oh-my-zsh
package_manager=$1

# ZSH
sudo $package_manager install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Nvim kickstart
sudo $package_manager install -y neovim python3-neovim
sudo $package_manager install nvim
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

sudo $package_manager lazygit

for pkg in $(find . -maxdepth 1 -mindepth 1 -type d); do
  stow --adopt $pkg
  git restore .
  stow $pkg
done

if [ "$#" -ne 1 ]; then
    echo "No arguments provided."
    echo "./install.sh <pkg_manager e.g. apt>"
fi

# Install nvim, zsh, oh-my-zsh
package_manager=$1
sudo $package_manager install curl tmux
# 
# ZSH
sudo $package_manager install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Nvim kickstart
sudo $package_manager install -y neovim python3-neovim
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

CWD=$(pwd)
cd /tmp 

echo "Download latest lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

echo "Download latest NVIM"
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-arm64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xvzf nvim-linux-arm64.tar.gz
sudo chsh -s $(which zsh)

cd $CWD

git config --global user.email "daniele.coppola@inf.ethz.ch"
git config --global user.name "Daniele Coppola"
## Begin STOW
echo "Begin stowing"
sudo $pakage_manager install stow
for dir in $(find . -maxdepth 1 -mindepth 1 -type d); do
  pkg=$(basename $dir) 
  echo $pkg
  if [ "$pkg" == ".git" ]; then
      continue  # Skip to the next iteration if it's .git
  fi
  stow --adopt $pkg
  git restore $pkg
  stow $pkg
done

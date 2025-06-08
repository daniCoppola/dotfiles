This folder contains the dotfiles used and uses the stow framework.

To understand the stow framework read
https://www.jakewiesler.com/blog/managing-dotfiles

Basically in each pkg e.g. nvim recreate the folder structure of the config file that you want to be symlinked. 
For example if you want to symlink to `.config/nvim/after/lua/plugins`, then create a folder `nvim` in `dotfiles` and recreate the path e.g. `mkdir -p .config/nvim/after/lua/plugin`




## Found solutions

### GNOME tiling
Command to move a window to a certain workspace.
`gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"`

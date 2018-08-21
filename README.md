# dotfiles

Inspired by https://github.com/atomantic/dotfiles

Took some ideas on the script from there, amazing reference. Although that one is focused on MacOs, and this script is for Linux machines that use either `dnf` or `apt-get` as package managers. Also, for directories, it creates the directories instead of symlinking them, the reason for this is because, symlinks don't seem to work great all the times, and also because in the original home directory, some subdirectories may have been already created and I don't want to fully replace them but instead replace some of the files (like the neovim configuration file inside the `~/.config/nvim` directory).

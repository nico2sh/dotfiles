#!/usr/bin/env bash
# Only creates the simlinks

#################################
# Move to the directory
#################################
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
cd $DIR

source ./lib_sh/echos.sh

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  bot "Interrupting..."
  exit 1
}

# Ask for the administrator password upfront
if ! sudo -n true; then
  # Ask for the administrator password upfront
  bot "I need you to enter your sudo password so I can install some things:"
  sudo -v
fi

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#################################
# Copying dotfiles
#################################
bot "Creating symlinks for project dotfiles..."

symlinks() {
  local fullsubpath=$1
  echo "Creating symlinks for directory $fullsubpath"

  shopt -s dotglob
  for file in *; do
    if [[ $file == "." || $file == ".." ]]; then
      continue
    fi
    # Only files
    if [[ -f "$file" ]]; then
      if [[ $fullsubpath == "." ]]; then
        filefullsubpath=$file
      else
        filefullsubpath=$fullsubpath/$file
      fi
      running "~/$filefullsubpath"
      # if the file exists:
      if [[ -e ~/$filefullsubpath ]]; then
          mkdir -p ~/.dotfiles_backup/$now/$fullsubpath
          mv ~/$filefullsubpath ~/.dotfiles_backup/$now/$filefullsubpath
          echo "backup saved as ~/.dotfiles_backup/$now/$filefullsubpath"
      fi
      mkdir -p ~/$fullsubpath
      # symlink might still exist
      unlink ~/$filefullsubpath > /dev/null 2>&1
      # create the link
      ln -s ${DIR}/homedir/$filefullsubpath ~/$filefullsubpath
      echo -en '\tlinked';ok
    elif [[ -d "$file" ]]; then
      pushd $file > /dev/null 2>&1

      if [[ $fullsubpath == "." ]]; then
        newpath=$file
      else
        newpath=${fullsubpath}/${file}
      fi
      symlinks $newpath

      popd > /dev/null 2>&1
    fi
  done
}

now=$(date +"%Y.%m.%d.%H.%M.%S")
pushd homedir > /dev/null 2>&1
symlinks "."
popd > /dev/null 2>&1

#################################
# Install Vim Plugins
#################################
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 2> /dev/null
bot "Installing vim plugins"
vim +PluginInstall +qall
nvim +PluginInstall +qall

bot "Done, if you are using Windows, don't forget to add at the beginning of the ~/.bashrc file:
\n\n# Launch Zsh
\nif [ -t 1 ]; then
\n  exec zsh
\nfi"

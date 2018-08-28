#!/usr/bin/env bash

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
# Install required packages
#################################
if which dnf > /dev/null; then
  sudo dnf install -y zsh tmux neovim keychain curl git cmake
elif which apt-get > /dev/null; then
  sudo apt-add-repository -y ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get install -y zsh tmux keychain curl git cmake
  # Neovim stuff
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y neovim
else
  error "can't install packages"
  exit 1;
fi


#################################
# Install oh my zsh
#################################
bot "Installing oh-myh-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 2> /dev/null || true

#################################
# Install powerlevel zsh theme
#################################
bot "Installing powerlevel zsh theme"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k 2> /dev/null || true

#################################
# Install Pure zsh theme
#################################
bot "Installing Pure zsh theme"
git clone https://github.com/sindresorhus/pure.git ~/.oh-my-zsh/custom/themes/pure 2> /dev/null || true
mkdir -p ~/.oh-my-zsh/functions
ln -s ~/.oh-my-zsh/custom/themes/pure/pure.zsh ~/.oh-my-zsh/functions/prompt_pure_setup 2> /dev/null || true
ln -s ~/.oh-my-zsh/custom/themes/pure/async.zsh ~/.oh-my-zsh/functions/async 2> /dev/null || true
chmod -w ~/.oh-my-zsh/functions

#################################
# Install Zsh Syntax Highlighting
#################################
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2> /dev/null
chmod -w ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
 
#################################
# Install FZF
#################################
bot "Installing FZF"
if git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2> /dev/null ; then
  ~/.fzf/install
fi

#################################
# Install Pyenv
#################################
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash 2> /dev/null || true

#################################
# Install TPM
#################################
bot "Installing Tmux Plugin Manager"
if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2> /dev/null ; then
  bot "Tmux Plugin Manager installed, remember to do 'prefix'+I next time you start Tmux"
fi

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

#!/usr/bin/env bash

source ./lib_sh/echos.sh

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
  sudo dnf install -y zsh tmux neovim
elif which apt-get > /dev/null; then
  sudo apt-get update
  sudo apt-get install -y zsh tmux neovim
else
  error "can't install packages"
  exit 1;
fi

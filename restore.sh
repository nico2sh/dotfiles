#!/usr/bin/env bash

###########################
# This script restores backed up dotfiles
# @author Adam Eivy
###########################

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

# include my library helpers for colorized echo and require_brew, etc
source ./lib_sh/echos.sh

if [[ -z $1 ]]; then
  error "you need to specify a backup folder date. Take a look in ~/.dotfiles_backup/ to see which backup date you wish to restore."
  exit 1
fi

bot "Restoring dotfiles from backup..."

pushd ~/.dotfiles_backup/$1

for file in .*; do
  if [[ $file == "." || $file == ".." ]]; then
    continue
  fi

  running "~/$file"
  if [[ -e ~/$file ]]; then
      unlink $file;
      echo -en "project dotfile $file unlinked";ok
  fi

  if [[ -e ./$file ]]; then
      mv ./$file ./
      echo -en "$1 backup restored";ok
  fi
  echo -en '\done';ok
done

popd

bot "Woot! All done."

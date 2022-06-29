#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
  brew install neovim
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  sudo apt install software-properties-common
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt update
  sudo apt install neovim
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

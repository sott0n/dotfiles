#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
  brew install tmux
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  sudo apt install tmux
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

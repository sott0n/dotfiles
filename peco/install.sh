#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
  brew install peco
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  sudo apt install peco
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

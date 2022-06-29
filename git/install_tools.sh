#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
  brew install tig git-delta
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  sudo apt install tig
  wget https://github.com/dandavison/delta/releases/download/0.13.0/delta-0.13.0-x86_64-unknown-linux-gnu.tar.gz
  tar -zxvf delta-0.13.0-x86_64-unknown-linux-gnu.tar.gz
  sudo mv delta-0.13.0-x86_64-unknown-linux-gnu/delta /usr/local/bin/
  rm -f delta-0.13.0-x86_64-unknown-linux-gnu.tar.gz
  rm -rf delta-0.13.0-x86_64-unknown-linux-gnu
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

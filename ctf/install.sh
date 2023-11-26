#!/bin/bash

DIRECTORY="$HOME/.ctf"

if ! [ -d "$DIRECTORY" ]; then
    mkdir -p "$DIRECTORY"
fi

# Install checksec.sh
if ! [ -L "/usr/local/bin/checksec"]; then
    git clone git@github.com:slimm609/checksec.sh.git ~/.ctf/checksec.sh
    sudo ln -s ~/.ctf/checksec.sh/checksec /usr/local/bin/checksec
    echo "DONE! checksec is installed!!"
fi

# Install Peda
git clone https://github.com/longld/peda.git ~/.ctf/peda
echo "source ~/.ctf/peda/peda.py" >> ~/.gdbinit
echo "DONE! peda is installed!!"

# Install ropper
pip install ropper

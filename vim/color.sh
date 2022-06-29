#/bin/bash
git clone https://github.com/jacoborus/tender.vim.git
mkdir -p $HOME/.config/nvim/colors
mv tender.vim/colors/tender.vim $HOME/.config/nvim/colors
rm -rf tender.vim

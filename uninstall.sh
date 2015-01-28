#!/bin/bash

rm ~/.bashrc
rm ~/.ctags
rm ~/.gdbinit
rm ~/.gemrc
rm ~/.gitconfig
rm ~/.git-completion.bash
rm ~/.gvimrc
rm ~/.inputrc
rm ~/.tmux.conf
rm ~/.tmux-powerlinerc
rm ~/.vimrc
rm ~/.zshrc
rm -rf ~/.vim
rm -rf ~/bin
rm -rf ~/lib

cp .dotfiles_backup/* ~/

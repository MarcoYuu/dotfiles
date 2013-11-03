#!/bin/bash

rm ~/.bashrc
rm ~/.gdbinit
rm ~/.gitconfig
rm ~/.gvimrc
rm ~/.inputrc
rm ~/.tmux.conf
rm ~/.tmux-powerlinerc
rm ~/.vimrc
rm ~/.zshrc
rm ~/.ctags
rm -rf ~/.vim
rm -rf ~/bin

ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.gdbinit ~/.gdbinit
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.gvimrc ~/.gvimrc
ln -s ~/dotfiles/.inputrc ~/.inputrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.tmux-powerlinerc ~/.tmux-powerlinerc
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.ctags ~/.ctags
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/bin ~/bin

VIM_DIR=~/.vim
if [ ! -d ${VIM_DIR}/bundle ]; then
	mkdir -p ${VIM_DIR}/bundle
fi

NEO_BUNDLE_DIR=${VIM_DIR}/bundle/neobundle.vim
if [ ! -d ${NEO_BUNDLE_DIR}]; then
	git clone git://github.com/Shougo/neobundle.vim NEO_BUNDLE_DIR
fi


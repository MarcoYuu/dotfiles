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

mkdir -p .vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim


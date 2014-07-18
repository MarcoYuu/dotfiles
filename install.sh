#!/bin/bash

mkdir ~/dotfiles_backup

mv ~/.bashrc ~/dotfiles_backup
mv ~/.gdbinit ~/dotfiles_backup
mv ~/.gitconfig ~/dotfiles_backup
mv ~/.gvimrc ~/dotfiles_backup
mv ~/.inputrc ~/dotfiles_backup
mv ~/.tmux.conf ~/dotfiles_backup
mv ~/.tmux-powerlinerc ~/dotfiles_backup
mv ~/.vimrc ~/dotfiles_backup
mv ~/.zshrc ~/dotfiles_backup
mv ~/.ctags ~/dotfiles_backup
mv -rf ~/.vim ~/dotfiles_backup
mv -rf ~/bin ~/dotfiles_backup
mv -rf ~/lib ~/dotfiles_backup

ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.gdbinit ~/.gdbinit
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.git-completion.bash ~/.git-completion.bash
ln -s ~/dotfiles/.gvimrc ~/.gvimrc
ln -s ~/dotfiles/.inputrc ~/.inputrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.tmux-powerlinerc ~/.tmux-powerlinerc
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.ctags ~/.ctags
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/bin ~/bin
ln -s ~/dotfiles/lib ~/lib


VIM_DIR=~/.vim
if [ ! -d ${VIM_DIR}/bundle ]; then
	mkdir -p ${VIM_DIR}/bundle
fi

NEO_BUNDLE_DIR=${VIM_DIR}/bundle/neobundle.vim
if [ ! -d ${NEO_BUNDLE_DIR} ]; then
	git clone git://github.com/Shougo/neobundle.vim $NEO_BUNDLE_DIR
fi

RBENV_DIR=~/.rbenv
if [ ! -d ${RBENV_DIR} ]; then
	git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
	mkdir -p ~/.rbenv/plugins
	git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

ZSH_EASY_SETTING_DIR=~/.rbenv
if [ ! -d ${ZSH_EASY_SETTING_DIR} ]; then
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/dotfiles/.oh-my-zsh
fi

sudo apt-get install command-not-found
sudo apt-get install tig

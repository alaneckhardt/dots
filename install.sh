#!/bin/sh

dots=~/dots

# bash
ln -sf $dots/bash/.bashrc ~/.bashrc

# vim
mkdir -p ~/.vim/syntax
ln -sf $dots/vim/.vimrc ~/.vimrc
ln -sf $dots/vim/psp.vim ~/.vim/syntax/psp.vim
ln -sf $dots/vim/htmljinja.vim ~/.vim/syntax/htmljinja.vim
ln -sf $dots/vim/proto.vim ~/.vim/syntax/proto.vim

# git
ln -sf $dots/git/.gitconfig ~/.gitconfig
ln -sf $dots/git/.gitignore ~/.gitignore

# pylint
ln -sf $dots/pylint/pylintrc ~/.pylintrc

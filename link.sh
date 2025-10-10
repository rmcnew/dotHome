#!/bin/env bash
cd $HOME
ln -f -s .dotHome/.gitconfig
ln -f -s .dotHome/.zshrc
ln -f -s .dotHome/.vimrc
ln -f -s .dotHome/.screenrc
ln -f -s .dotHome/.tmux.conf
ln -f -s .dotHome/.emacs
ln -f -s .dotHome/.quiltrc
ln -f -s .dotHome/.dput.cf
ln -f -s .dotHome/.mk-sbuild.rc
mkdir -p $HOME/.config
cd $HOME/.config
ln -f -s $HOME/.dotHome/helix 
ln -f -s $HOME/.dotHome/sbuild
ln -f -s $HOME/.dotHome/fish

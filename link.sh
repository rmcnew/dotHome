#!/bin/env bash
cd $HOME
ln -s .dotHome/.zshrc
ln -s .dotHome/.vimrc
ln -s .dotHome/.screenrc
ln -s .dotHome/.tmux.conf
ln -s .dotHome/.emacs
mkdir -p $HOME/.config/helix
ln -s .dotHome/helix_config.toml $HOME/.config/helix/config.toml

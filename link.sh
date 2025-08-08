#!/bin/env bash
cd $HOME
ln -f -s .dotHome/.zshrc
ln -f -s .dotHome/.vimrc
ln -f -s .dotHome/.screenrc
ln -f -s .dotHome/.tmux.conf
ln -f -s .dotHome/.emacs
mkdir -p $HOME/.config/helix
ln -f .dotHome/helix_config.toml $HOME/.config/helix/config.toml
ln -f .dotHome/helix_languages.toml $HOME/.config/helix/languages.toml

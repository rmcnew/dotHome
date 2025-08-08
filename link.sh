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
ln -f -s .dotHome/.sbuildrc
ln -f -s .dotHome/.mk-sbuild.rc
mkdir -p $HOME/.config/helix
ln -f .dotHome/helix_config.toml $HOME/.config/helix/config.toml
ln -f .dotHome/helix_languages.toml $HOME/.config/helix/languages.toml

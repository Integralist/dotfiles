#!/usr/bin/env bash
#
# Note: .bashrc is loaded FIRST, then this .bash_profile is loaded

if [ -f "$HOME/.bashrc" ]; then
  source ~/.bashrc
  cd . || exit
fi

if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  source "$(brew --prefix)/etc/bash_completion"
fi

# prevent tmux from triggering the path to be updated with duplicate items
if [[ -z $TMUX ]]; then
  export PATH="/set/something/here:$PATH"
fi

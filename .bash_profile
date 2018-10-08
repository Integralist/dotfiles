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

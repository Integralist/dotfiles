#!/usr/bin/env bash
#
# Note: .bash_profile is loaded BEFORE .bashrc

echo .bash_profile loaded

if [ -f "$HOME/.bashrc" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.bashrc"
  cd . || exit
fi

if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  # shellcheck source=/dev/null
  source "$(brew --prefix)/etc/bash_completion"
fi

# prevent tmux from triggering the path to be updated with duplicate items
if [[ -z $TMUX ]]; then
  export PATH="/set/something/here:$PATH"
fi

#!/usr/bin/env bash
#
# Note: .bash_profile is loaded BEFORE .bashrc

echo .bash_profile loaded

export FASTLY_API_TOKEN="123"
export FASTLY_SERVICE_ID="456"

export VCL_DIRECTORY="$HOME/code/buzzfeed/cdn"
export VCL_MATCH_PATH="_util|www"
export VCL_SKIP_PATH="fastly_boilerplate"

if [ -f "$HOME/.bashrc" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.bashrc"
  cd . || exit
fi

if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  # shellcheck source=/dev/null
  source "$(brew --prefix)/etc/bash_completion"
fi

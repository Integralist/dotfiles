#!/usr/bin/env bash
#
# NOTES:
# new terminal windows in macOS will start a 'login' shell
# which means .bash_profile is sourced, but not .bashrc
#
# if you were to execute the `bash` command from within your shell
# this would cause bash to open as an 'interactive' shell (not login)
# this would also result in it sourcing only the .bashrc file and not this
# .bash_profile configuration.

echo .bash_profile loaded

if [ -f "$HOME/.bashrc" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.bashrc"
  cd . || exit
fi

# bash configuration that you don't want as part of your main .bashrc
# e.g. $PATH modifications
#
if [ -f "$HOME/.localrc" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.localrc"
fi

if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  # shellcheck source=/dev/null
  source "$(brew --prefix)/etc/bash_completion"
fi

#!/usr/bin/env bash
#
# NOTES:
# new terminal windows in macOS will start a 'login' shell
# which means .bash_profile is sourced, but not .bashrc
# so in .bash_profile we check if .bashrc exists and source it
# after sourcing .bashrc we use its exported pathmunge()
#
# if you were to execute the `bash` command from within your shell
# this would cause bash to open as an 'interactive' shell (not login)
# this would also result in it sourcing only the .bashrc file

echo .bash_profile loaded

if [ -f "$HOME/.bashrc" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.bashrc"
  cd . || exit
fi

# bash extensions that you don't want as part of your main .bashrc
if [ -f "$HOME/.localrc" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.localrc"
fi

if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  # shellcheck source=/dev/null
  source "$(brew --prefix)/etc/bash_completion"
fi

# Required to fix issue where openssl was upgraded by homebrew and it broke an
# existing cli tool. So I had to backport to earlier openssl in a way that
# wouldn't affect system libs that needed the system installed version of openssl
pathmunge "/usr/local/opt/openssl@1.1/bin"

# Created when installing rust
pathmunge "$HOME/.cargo/bin"

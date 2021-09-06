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

# AVOID $(brew --prefix) as it can be quite slow compared to hard coded value
#
# We load bash completion script BEFORE .bashrc which loads FZF completion.
# Otherwise the FZF completion gets overridden by the bash completion.
#
if [ -f "/usr/local/etc/bash_completion" ]; then
  source "/usr/local/etc/bash_completion"
fi

if [ -f "$HOME/.bashrc" ]; then
  source "$HOME/.bashrc"
fi

# bash extensions that you don't want as part of your main .bashrc
# e.g. $PATH modifications
#
if [ -f "$HOME/.localrc" ]; then
  source "$HOME/.localrc"
fi

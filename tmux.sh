#!/usr/bin/env bash

# check if we've not already got a session created
#
if [[ $(tmux ls 2> /dev/null | grep -c work) -eq 1 ]]; then
  tmux attach -t work
else
  # create a new session and detach from it
  #
  tmux new -s work -d

  # work stuff
  #
  tmux rename-window -t 1 'fastly'
  tmux send-keys -t work:1 'cd ~/Code/fastly' 'C-m'
  tmux split-window -p 30
  tmux send-keys -t work:1 'export GPG_USER=mark.mcdx@gmail.com' 'C-m'

  # ipython REPL
  # expects a 'repl' virtual environment to have already been created
  #
  tmux new-window -n 'ipython' -t work:2
  tmux send-keys -t work:2 'cd ~/Code/python && pyenv activate repl && ipython' 'C-m'

  # now everything is setup we'll attach to a specific window we're interested in
  #
  tmux attach -t work:2
fi

#!/usr/bin/env bash

# check if we've not already got a session created
#
if [[ $(tmux ls 2> /dev/null | grep -c fastly) -eq 1 ]]; then
  tmux attach -t fastly
else
  # create a new session and detach from it
  #
  tmux new -s fastly -d

  # Go-Fastly
  #
  tmux rename-window -t 1 'go-fastly'
  tmux send-keys -t fastly:1 'cd ~/Code/fastly/go-fastly && clear' 'C-m'
  tmux split-window -p 20
  tmux send-keys -t fastly:1 'cd ~/Code/fastly/go-fastly && export GPG_USER=integralist@fastly.com && clear' 'C-m'

  # CLI
  #
  tmux new-window -n 'cli' -t fastly:2
  tmux send-keys -t fastly:2 'cd ~/Code/fastly/cli && clear' 'C-m'
  tmux split-window -p 20
  tmux send-keys -t fastly:2 'cd ~/Code/fastly/cli && export GPG_USER=integralist@fastly.com && clear' 'C-m'
  tmux send-keys -t fastly:2 'clear' 'C-m'

  # Terraform
  #
  tmux new-window -n 'terraform' -t fastly:3
  tmux send-keys -t fastly:3 'cd ~/Code/fastly/terraform-provider-fastly && clear' 'C-m'
  tmux split-window -p 20
  tmux send-keys -t fastly:3 'cd ~/Code/fastly/terraform-provider-fastly && export GPG_USER=integralist@fastly.com && clear' 'C-m'
  tmux send-keys -t fastly:3 'clear' 'C-m'

  # now everything is setup we'll attach to a specific window we're interested in
  #
  tmux attach -t fastly:1
fi

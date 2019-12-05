#!/usr/bin/env bash

# Check if we've not already got a session created
if [[ $(tmux ls 2> /dev/null | grep -c work) -eq 1 ]]; then
  tmux attach -t work
else
  # Every time I restart my computer I forget about doing this
  # I then wonder why I can't push to GitHub/GitLab
  eval "$(ssh-agent -s)"
  ssh-add -K ~/.ssh/github_rsa

  # Create a new session and detach from it
  tmux new -s work -d

  # Jump into our BuzzFeed directory
  tmux rename-window -t 1 'mono'
  tmux send-keys -t work:1 'cd ~/Code/buzzfeed/mono' 'C-m'

  # Prepare Rig VM
  tmux new-window -n 'rig' -t work:2
  tmux send-keys -t work:2 'export GPG_USER=mark.mcdonnell@buzzfeed.com' 'C-m'
  tmux send-keys -t work:2 'cd ~/Code/buzzfeed/mono && python3 -m pip install -e ./rig && rig local bootstrap' 'C-m'

  # ipython REPL
  tmux new-window -n 'ipython' -t work:3
  tmux send-keys -t work:3 'cd ~/Code/Python/3.8-dev && pyenv activate ipython_env && ipython' 'C-m'

  # htop
  tmux new-window -n 'htop' -t work:4
  tmux send-keys -t work:4 'htop' 'C-m'

  # Now everything is setup we'll attach to a specific window we're interested in
  tmux attach -t work:4
fi

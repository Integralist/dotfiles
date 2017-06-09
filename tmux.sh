#!/usr/bin/env bash

# Check if we've not already got a session created
if [[ $(tmux ls 2> /dev/null | grep -c work) -eq 1 ]]; then
  tmux attach -t work
else
  # Every time I restart my computer I forget about doing this
  # I then wonder why I can't push to GitHub/GitLab
  eval "$(ssh-agent -s)"
  ssh-add -K ~/.ssh/github_rsa
  ssh-add -K ~/.ssh/gitlab_rsa

  # Create a new session and detach from it
  tmux new -s work -d

  # Run the tasks cli tool in our first window
  tmux rename-window -t 1 'todo'
  tmux send-keys 'task' 'C-m'

  # Jump into our BuzzFeed directory
  tmux new-window -n 'mono' -t work:2
  tmux send-keys -t work:2 'cd ~/code/buzzfeed/mono' 'C-m'

  # Prepare Rig VM
  tmux new-window -n 'rig' -t work:3
  tmux send-keys -t work:3 'export GPG_USER=mark.mcdonnell@buzzfeed.com'
  tmux send-keys -t work:3 '# "execute v up followed by sshvm command (requires gpg passphrase)"' 'C-m'

  # Python REPL
  tmux new-window -n 'ipython' -t work:4
  tmux send-keys -t work:4 'cd ~/code/python && ipython' 'C-m'

  # CDN
  tmux new-window -n 'cdn' -t work:5
  tmux send-keys -t work:5 'cd ~/code/buzzfeed/cdn' 'C-m'

  # Go Code Project
  tmux new-window -n 'go' -t work:6
  tmux send-keys -t work:6 'cd ~/code/go' 'C-m'

  # IRC
  tmux new-window -n 'irc' -t work:7
  tmux send-keys -t work:7 'irc' 'C-m'

  # Attach to the session, now we have everything setup
  # We connect to the Rig window as we have to manually run vagrant (due to GPG passphrase requirement)
  tmux attach -t work:3
fi

# Check if we've not already got a session created
if [[ $(tmux ls | grep -c work) -eq 1 ]]; then
  tmux attach -t work
else
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
  tmux send-keys -t work:3 '# "execute v up followed by sshvm command (requires gpg passphrase)"' 'C-m'

  # Python REPL
  tmux new-window -n 'ipython' -t work:4
  tmux send-keys -t work:4 'cd ~/code/python && ipython' 'C-m'

  # IRC
  tmux new-window -n 'ipython' -t work:5
  tmux send-keys -t work:5 'irc' 'C-m'

  # Rust Code Project
  tmux new-window -n 'rust' -t work:6
  tmux send-keys -t work:6 'cd ~/code/rust' 'C-m'

  # Attach to the session, now we have everything setup
  tmux attach -t work:3
fi

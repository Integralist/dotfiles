#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Otherwise tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# Increase the number of file descriptors from default of 254.
ulimit -n 10240

# Ensure every new shell instance has our ssh keys added.
#
# NOTE: To figure out which local SSH key matches the SSH key in GitHub:
# ssh-keygen -lf ~/.ssh/<private_ssh_filename> -E sha256
#
# Also try:
# ssh -vT git@github.com
if ! ssh-add -l >/dev/null 2>&1; then
  echo "Starting new ssh-agent..."
  eval "$(ssh-agent -s)" >/dev/null
else
  echo "ssh-agent already running."
fi
ssh-add --apple-use-keychain ~/.ssh/github > /dev/null 2>&1
ssh-add --apple-use-keychain ~/.ssh/fastly > /dev/null 2>&1
ssh-add --apple-use-keychain ~/.ssh/fastly_integralist > /dev/null 2>&1
ssh-add --apple-use-keychain ~/.ssh/domainr_ssh_proxy.key > /dev/null 2>&1

# Ensure every new shell instance has a gpg-agent running.
# This is for when we do `git commit` and we need our signing key passphrase.
# We store that into the macOS keychain using pinentry.
pgrep gpg-agent &>/dev/null || eval $(gpg-agent --daemon)

# Auto-run Go/Rust updates with a manual lock mechanism
mkdir -p "$HOME/.cache"
cache_file="$HOME/.cache/shell-update"
lock_file="$HOME/.cache/shell-update.lock"
current_day=$(date +%Y-%m-%d)

# release_lock releases the lock
release_lock() {
  rm -f "$lock_file"
}

# is_locked checks if another process is holding the lock
is_locked() {
  if [ -f "$lock_file" ]; then
    # check if the PID in the lock file is still running
    lock_pid=$(cat "$lock_file")

		# using /bin/ps as ps is aliased to procs binary
    if /bin/ps -p "$lock_pid" > /dev/null 2>&1; then
      return 0  # lock is still active
    else
      echo "stale lock detected, cleaning up."
      rm -f "$lock_file"
    fi
  fi
  return 1  # no lock
}

# Check if the script is locked
if is_locked; then
	echo "another shell (PID $(cat "$lock_file")) is already running dependency updates so skip-ahead"
else
	echo "acquiring shell lock for PID $$ ($lock_file)"

	# write the current process's PID to the lock file
	echo $$ > "$lock_file"

	# ensure lock is released if the script exits or is interrupted
	trap release_lock EXIT

	# run the dependency update logic if no lock is present
	if [ -f "$cache_file" ]; then
		# get the last modification date of the cache file in YYYY-MM-DD format
		last_modified_day=$(date -r "$cache_file" +%Y-%m-%d)

		# if the cache file was last modified on a different day, run the command
		if [ "$current_day" != "$last_modified_day" ]; then
			echo "updating dependencies for homebrew and rust (last updated: $last_modified_day)"
			# go_tools # DISABLED: we only do this on `cd` to a Go project now
			brew_update
			rust_update
			touch "$cache_file" # update last_modified date
		fi
	else
		echo "updating dependencies for homebrew and rust (no previous cache file found)"
		# go_tools # DISABLED: we only do this on `cd` to a Go project now
		brew_update
		rust_update
		touch "$cache_file" # update last_modified date
	fi

	echo "releasing shell lock for PID $$ ($lock_file)"
	release_lock
fi

# Ensure terminal prompt is two lines under the actual Starship prompt.
PROMPT="${PROMPT}"$'\n\n'

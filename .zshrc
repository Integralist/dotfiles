#!/usr/bin/zsh

# WARNING: tty isn't available from subshell so I set it here for later reference.
# It's referenced from inside of ~/.config/zsh/exports.zsh
tty_instance=$(tty)

function load_script {
	local path=$1
	if test -f $path; then
		source $path
	else
		echo "no $path found"
	fi
}

# IMPORTANT: $PATH in sourced scripts is the path to the script itself.
# So we assign the parent .zshrc PATH to MODIFIED_PATH and use that in sourced scripts.
# We do this by re-assigning PATH in the sourced script to MODIFIED_PATH.
# Then at the end of the sourced script we re-export the updated MODIFIED_PATH.
# Later on you'll see us prefix this .zshrc PATH with MODIFIED_PATH.
export MODIFIED_PATH="$PATH"

load_script ~/.config/zsh/options.zsh
load_script ~/.config/zsh/exports.zsh
load_script ~/.config/zsh/alias.zsh
load_script ~/.config/zsh/tools.zsh
load_script ~/.config/zsh/autocomplete.zsh
load_script ~/.config/zsh/functions.zsh
load_script ~/.config/zsh/bindings.zsh
load_script ~/.config/zsh/shell.zsh

export PATH="$MODIFIED_PATH:$PATH"
typeset -U path

# DISABLED: Zsh has its own approach (see above).
#
# dedupe

echo .zshrc loaded

# Configuration you don't want as part of your main .zshrc
#
if [ -f "$HOME/.localrc" ]; then
  source "$HOME/.localrc"
fi

# The following is a modification from running `curl -sSL "https://humanlog.io/install.sh" | bash`
export PATH="/Users/integralist/.humanlog/bin:$PATH"

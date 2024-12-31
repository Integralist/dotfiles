#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Also, other tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# Shift-Tab for backward searching auto-complete entries
#
# NOTE: Not really necessary when using https://github.com/Aloxaf/fzf-tab
bindkey '^[[Z' reverse-menu-complete

# Explicitly override VI-MODE set because of EDITOR value.
#
# DISABLED:
# See `setopt VI` earlier in the file.
# We went back to using vi-mode as ghostty doesn't support text selection.
#
# bindkey -e .

# Configure a shortcut for the `vf` alias
bindkey -s '^f' 'vim $(fzf)\n'

# Allow yanking command input to system clipboard.
#
# It works like this:
# echo $BUFFER prints the command you're currently typing.
# Piping (|) it into pbcopy sends that text to the macOS system clipboard.
# We use Zsh's zle (Zsh Line Editor) to intercept the buffer before execution and copy it to the clipboard.
#
# NOTE: This only works when you've typed a command but not run.
copy-buffer-to-clipboard() {
  echo $BUFFER | pbcopy
  zle reset-prompt  # refresh the prompt to avoid command overlap
}
zle -N copy-buffer-to-clipboard
bindkey '^Y' copy-buffer-to-clipboard

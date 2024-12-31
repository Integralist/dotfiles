#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Also, other tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# Setup fpath for brew-installed completions, if available
#
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

# Bash Autocomplete Helpers
#
autoload -U +X bashcompinit && bashcompinit

# Zsh Autocomplete Helpers
#
# Extended with help from fzf-tab (https://github.com/Aloxaf/fzf-tab)
#
autoload -U compinit; compinit

# fzf-tab
#
dir_zsh="$HOME/.zsh"
dir_fzf_tab="$dir_zsh/fzf-tab"
path_fzf_tab="$dir_fzf_tab/fzf-tab.plugin.zsh"
if test -f $path_fzf_tab; then
  source $path_fzf_tab
else
	mkdir -p "$dir_zsh"
	git clone https://github.com/Aloxaf/fzf-tab $dir_fzf_tab
  source $path_fzf_tab
fi

# Git Autocomplete
#
path_git_completion="$HOME/git-completion.zsh"
if ! test -f $path_git_completion; then
	curl -so $path_git_completion https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-completion.zsh
	chmod +x $path_git_completion
fi
fpath=($dir_zsh $fpath)
zstyle ':completion:*:default' menu select=2 # Highlight the selected option when using auto-complete.

# fzf shell support
#
# The `brew install fzf` installation provides an `install` script, which:
#
# Enables ctrl-r for fuzzy searching command history.
# Enables ctrl-t for selecting multiple files to append to command line (see also vf alias).
# Enables esc-c for cd'ing to the selected directory (esc == alt/meta).
#
path_fzf_script="$HOME/.fzf.zsh"
if test -f $path_fzf_script; then
  source $path_fzf_script
else
	$(brew --prefix)/opt/fzf/install
  source $path_fzf_script
fi

# zsh-users/zsh-autosuggestions
#
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-users/zsh-syntax-highlighting
#
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Terraform Autocomplete
#
complete -o nospace -C $(brew --prefix)/bin/terraform terraform

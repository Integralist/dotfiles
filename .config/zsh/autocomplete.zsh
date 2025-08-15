#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Otherwise tools like `curl`, `sh` etc can't be found otherwise.
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

dir_zsh="$HOME/.zsh"

# Install integralist/zsh-cli-json-parser
# For custom CLI autocomplete (for when a CLI doesn't provide autocomplete itself)
#
path_json_parser="$dir_zsh/get_cli_options.zsh"
if ! test -f $path_json_parser; then
	curl -so $path_json_parser https://raw.githubusercontent.com/Integralist/zsh-cli-json-parser/refs/heads/main/get_cli_options.zsh
	chmod +x $path_json_parser
fi
source $path_json_parser

# fzf-tab
#
dir_fzf_tab="$dir_zsh/fzf-tab"
path_fzf_tab="$dir_fzf_tab/fzf-tab.plugin.zsh"
if test -f $path_fzf_tab; then
  source $path_fzf_tab
else
	mkdir -p "$dir_zsh"
	git clone https://github.com/Aloxaf/fzf-tab $dir_fzf_tab
  source $path_fzf_tab
fi
# The following are common configurations for fzf-tab
# https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#configure
#
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# # switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Git Autocomplete
#
# IMPORTANT: The bash completion script is required even when using zsh shell.
#
path_zsh_git_completion="$dir_zsh/_git"
if ! test -f $path_zsh_git_completion; then
	curl -so $path_zsh_git_completion https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-completion.zsh
	chmod +x $path_zsh_git_completion
fi
path_bash_git_completion="$HOME/git-completion.bash"
if ! test -f $path_bash_git_completion; then
	curl -so $path_bash_git_completion https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-completion.bash
	chmod +x $path_bash_git_completion
fi

# Rust Autocomplete
#
path_rustup_completion="$dir_zsh/_rustup"
if ! test -f $path_rustup_completion; then
	rustup completions zsh > $path_rustup_completion
fi
source "$path_rustup_completion"
path_cargo_completion="$dir_zsh/_cargo"
if ! test -f $path_cargo_completion; then
	rustup completions zsh cargo > $path_cargo_completion
fi

fpath=($dir_zsh $fpath)
zstyle ':completion:*:*:git:*' script $path_bash_git_completion
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

# Doggo Autocomplete
#
if ! command -v doggo &> /dev/null
then
  brew install doggo
fi
doggo completions zsh > "${fpath[1]}/_doggo"

# 1Password Autocomplete
#
if command -v op &> /dev/null
then
	eval "$(op completion zsh)"; compdef _op op
fi

# Golangci-lint Autocomplete
#
if command -v golangci-lint &> /dev/null
then
	eval "$(golangci-lint completion zsh)"
fi

# Dagger Autocomplete
#
if command -v dagger &> /dev/null
then
	eval "$(dagger completion zsh)"
fi

# DISABLED:
#
# Example Autocomplete
# Uses https://github.com/integralist/zsh-cli-json-parser (installed earlier)
#
# path_example_completion="$dir_zsh/_example"
# chmod +x $path_example_completion
# source "$path_example_completion"

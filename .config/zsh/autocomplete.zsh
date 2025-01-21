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
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# DISABLED: As the preview window was annoying.
#
# # To make fzf-tab follow FZF_DEFAULT_OPTS.
# # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
# zstyle ':fzf-tab:*' use-fzf-default-opts yes

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

# 1Password Autocomplete
#
eval "$(op completion zsh)"; compdef _op op

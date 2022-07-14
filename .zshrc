# NOTE:
# additional configuration of the shell is handled by ~/.inputrc which
# instructs the Readline utility as to what behaviours it should respect.
#
# DOCUMENTATION:
#   - https://twobithistory.org/2019/08/22/readline.html
#   - man zsh (+ /Readline Variables)
#
# STRUCTURE:
#   - SCRIPTS
#   - CONFIGURATION
#   - EXPORTS
#   - CUSTOM FUNCTIONS
#   - ALIAS
#   - BINDINGS
#   - SHELL
#   - SOFTWARE
#

# ⚠️  SCRIPTS ⚠️

# fig.io autocomplete helpers
#
if test -f "$HOME/.fig/shell/zshrc.pre.zsh"; then
  . "$HOME/.fig/shell/zshrc.pre.zsh"
fi

# general autocomplete helpers
#
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# + brew install zsh-completions
#
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# git autocomplete
#
# https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
# https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh
#
# NOTE: The zsh file is saved as: ~/.zsh/_git
#
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.git-completion.bash

# fzf shell support
#
# run:
# $(brew --prefix)/opt/fzf/install
#
if test -f ~/.fzf.zsh; then
  source ~/.fzf.zsh
fi

# fzf git utility tool
# https://github.com/wfxr/forgit
#
# `git forgit log`, `forgit::log` OR `glo` alias (if set).
#
# NOTE: I manually set the alias' because I prefer to source scripts at the top
# of my file, while my existing git alias' would otherwise be partially replaced.
#
if ! test -f "$HOME/Code/shell/forgit/forgit.plugin.sh"; then
  mkdir -p "$HOME/Code/shell"
  git clone git@github.com:wfxr/forgit.git
fi
export FORGIT_NO_ALIASES=true
source $HOME/Code/shell/forgit/forgit.plugin.sh

# ⚠️  CONFIGURATION ⚠️
#
# https://zsh.sourceforge.io/Doc/Release/Options.html
#
setopt AUTO_CD
setopt CDABLE_VARS
setopt CD_SILENT
setopt CHASE_DOTS
setopt CHASE_LINKS
setopt ALWAYS_LAST_PROMPT
setopt ALWAYS_TO_END
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_NAME_DIRS
setopt AUTO_PARAM_KEYS
setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH
setopt COMPLETE_IN_WORD
setopt GLOB_COMPLETE
setopt HASH_LIST_ALL
setopt LIST_AMBIGUOUS
setopt LIST_PACKED
setopt LIST_TYPES
setopt MENU_COMPLETE
setopt EXTENDED_GLOB
setopt REMATCH_PCRE
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt ALIASES
setopt VI
setopt CORRECT
setopt CORRECT_ALL
unsetopt BEEP
unsetopt CASE_GLOB
unsetopt CASE_MATCH

# increase number of file descriptors from default of 254
ulimit -n 10240

# ⚠️  EXPORTS ⚠️

# Homebrew
#
eval "$(/opt/homebrew/bin/brew shellenv)"

# NOTES:
# LSCOLOR is for BSD (i.e. macOS).
# LS_COLOR is for Linux.
#
# There are 11 attributes:
#
# directory
# symlink
# socket
# pipe
# executable
# special block
# special character
# executable setuid
# executable setgid
# dir_writeothers_sticky
# dir_writeothers_NOsticky
#
# Each attribute has a foreground/background colour.
#
# DOCUMENTATION:
#   - http://geoff.greer.fm/lscolors/
#   - https://www.cyberciti.biz/faq/apple-mac-osx-terminal-color-ls-output-option/
#
# COLOURS:
#   - directory: blue/white (eh)
#   - symlink: black/yellow (aD)
#   - executable: white/red (Hb)
#
# NOTE:
# The `tree` command requires an underscore version of LSCOLOR(S).
#
export LSCOLORS="ehaDxxxxHbxxxxxxxxxxxx"
export LS_COLORS="rs=0:di=36:ln=32:mh=00:pi=33:so=33:do=33:bd=00:cd=00:or=05;36:mi=04;93:su=31:sg=31:ca=00:tw=36:ow=36:st=36:ex=031:*.tar=00:*.tgz=00:*.arc=00:*.arj=00:*.taz=00:*.lha=00:*.lz4=00:*.lzh=00:*.lzma=00:*.tlz=00:*.txz=00:*.tzo=00:*.t7z=00:*.zip=00:*.z=00:*.dz=00:*.gz=00:*.lrz=00:*.lz=00:*.lzo=00:*.xz=00:*.zst=00:*.tzst=00:*.bz2=00:*.bz=00:*.tbz=00:*.tbz2=00:*.tz=00:*.deb=00:*.rpm=00:*.jar=00:*.war=00:*.ear=00:*.sar=00:*.rar=00:*.alz=00:*.ace=00:*.zoo=00:*.cpio=00:*.7z=00:*.rz=00:*.cab=00:*.wim=00:*.swm=00:*.dwm=00:*.esd=00:*.jpg=00:*.jpeg=00:*.mjpg=00:*.mjpeg=00:*.gif=00:*.bmp=00:*.pbm=00:*.pgm=00:*.ppm=00:*.tga=00:*.xbm=00:*.xpm=00:*.tif=00:*.tiff=00:*.png=00:*.svg=00:*.svgz=00:*.mng=00:*.pcx=00:*.mov=00:*.mpg=00:*.mpeg=00:*.m2v=00:*.mkv=00:*.webm=00:*.ogm=00:*.mp4=00:*.m4v=00:*.mp4v=00:*.vob=00:*.qt=00:*.nuv=00:*.wmv=00:*.asf=00:*.rm=00:*.rmvb=00:*.flc=00:*.avi=00:*.fli=00:*.flv=00:*.gl=00:*.dl=00:*.xcf=00:*.xwd=00:*.yuv=00:*.cgm=00:*.emf=00:*.ogv=00:*.ogx=00:*.aac=00:*.au=00:*.flac=00:*.m4a=00:*.mid=00:*.midi=00:*.mka=00:*.mp3=00:*.mpc=00:*.ogg=00:*.ra=00:*.wav=00:*.oga=00:*.opus=00:*.spx=00:*.xspf=00:";

# application configuration
#
export EDITOR="vim"
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_DEFAULT_COMMAND="rg --hidden --files"
export FZF_DEFAULT_OPTS='--multi --ansi --preview="bat --color=always {}" --preview-window=right:50%:wrap'
export GPG_TTY=$(tty)
export GREP_COLOR="1;32"
export GREP_OPTIONS="--color=auto"
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page
export TERM="xterm-256color" # avoid "terminals database is inaccessible" and not being able to run `clear` command (also fixes tmux/vim colour issues).
export TERMINFO=/usr/share/terminfo
export TIMEFORMAT="$(printf '\n\e[01;31m')elapsed:$(printf '\e[00m') %Rs, $(printf '\e[01;33m')user mode (cpu time):$(printf '\e[00m') %U, $(printf '\e[01;32m')system mode (cpu time):$(printf '\e[00m') %S"

# git specific configurations
#
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true     # * for unstaged changes (+ staged but uncommitted changes)
export GIT_PS1_SHOWSTASHSTATE=true     # $ for stashed changes
export GIT_PS1_SHOWUNTRACKEDFILES=true # % for untracked files
export GIT_PS1_SHOWUPSTREAM="auto"     # > for local commits on HEAD not pushed to upstream
                                       # < for commits on upstream not merged with HEAD
                                       # = HEAD points to same commit as upstream

# history configuration
#
# NOTES:
# can be partially controlled by Readline directly using ~/.inputrc
#
export HISTSIZE=500000

# man pages colour configuration
# https://www.tuxarena.com/2012/04/tutorial-colored-man-pages-how-it-works/
#
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode – red
export LESS_TERMCAP_md=$(printf '\e[01;33m') # enter double-bright mode – bold, yellow
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode – yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;31m') # enter underline mode – red

# programming language modifications
#
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/go/bin:$PATH" # go command (e.g. go version) install location
export PATH="$HOME/go/bin:$PATH"      # go executables (e.g. go install) install location
export PATH="$HOME/.cargo/bin:$PATH"  # rust executables
export PATH="$HOME/bin:$PATH"         # terraform executables (via tfswitch)

# rustup
#
# avoid https://github.com/rust-analyzer/rust-analyzer/issues/4172
#
# NOTE: Has to be defined after PATH update to locate .cargo directory.
#
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# ⚠️  CUSTOM FUNCTIONS ⚠️

# update Homebrew and check for outdated packages
function brew_update {
  brew update
  brew outdated
  brew upgrade
}

# sshagent ensures each shell instance knows about our GitHub SSH connection key(s).
#
# NOTE: To figure out which local SSH key matches the SSH key in GitHub:
# ssh-keygen -lf ~/.ssh/<private_ssh_filename> -E sha256
#
# Also try:
# ssh -vT git@github.com
function sshagent {
  local private_key=$1
  eval "$(ssh-agent -s)" > /dev/null
  ssh-add --apple-use-keychain ~/.ssh/$1 > /dev/null 2>&1
}

# to ensure there are no duplicates in the $PATH
# we call dedupe at the end of each sourced shell script.
function dedupe {
  export PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
}

# create directory structure and cd into it
#
function mkcdir() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

# pretty print $PATH
#
function ppath() {
  echo "${PATH//:/$'\n'}"
}

# random number generator
# selects from the given number (default 100)
#
function rand() {
  local limit=${1:-100}
  seq $limit | gshuf -n 1
}

# tabs are indicated by ^I and line endings by $
# useful for validating things like a Makefile
#
function hiddenchars() {
  local filename=$1
  cat -e -t -v $filename
}

# delete tag from both local and remote repositories
#
function git_tag_delete() {
  git tag -d "v$1"
  git push --delete origin "v$1"
}

# cut a new release for a git project
#
function git_tag_release() {
  tag="v$1"
  # git tag -s $tag -m "$tag" && git push origin $tag
  git tag $tag -m "$tag" && git push origin $tag
}

# display contents of archive file
#
function list_contents() {
  if echo $1 | grep -Ei '.tar.gz$' &> /dev/null; then
    tar -ztvf $1
    return
  fi

  if echo $1 | grep -Ei '.zip$' &> /dev/null; then
    unzip -l $1
    return
  fi

  echo unsupported file extension
}

# ⚠️  ALIAS ⚠️

# NOTE: use `type <alias>` to see what is assigned to an alias/fn/builtin/keyword
#       alternatively use the `list` alias to show all defined alias' from this file
#       the `alias` function itself with no arguments will actually print all too
#
alias brew="HOMEBREW_NO_AUTO_UPDATE=1 brew"
alias c="clear"
alias cat="bat"
alias dns="scutil --dns | grep 'nameserver\\[[0-9]*\\]'"

read -r -d '' network_help <<- EOF
connectivity debugging steps...

  * Check your upload/download speed:
    networkQuality -s

  * check what dns servers are being used by executing the 'dns' alias:
    dns

    > you can also check via nslookup
    > default should be: 192.168.86.1

  * check we can reach a highly available public domain:
    ping google.com

  * check route from home router to internet:
    traceroute -av google.com

  * check hostnames can be resolved:
    host www.integralist.co.uk

  * execute a dns lookup using different dns servers (one remote, one local):
    nslookup google.com 8.8.8.8
    nslookup google.com 192.168.1.1

    > you can also use Cloudfare's 1.1.1.1 resolvers
    > you can change via Network UI tab in macOS (dns sub tab)
    > or via terminal: https://superuser.com/a/86188
    >
    > e.g.
    > networksetup -getdnsservers Wi-Fi
    > networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
    > sudo discoveryutil mdnsflushcache

  * can we curl an endpoint:
    curl -Lsvo /dev/null http://google.com/

  * also check performance:
    https://www.speedcheck.org/
    https://www.speedtest.net/
    https://speed.cloudflare.com/
    https://fast.com/
EOF
alias networkhelp='echo "$network_help"'

alias dockerprune='docker system prune --all'
alias dockerrmi='docker rmi $(docker images -a -q)'
alias dockerrmc='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# git alias' with git autocomplete support
#
# __git_complete is lazy loaded by the bash shell, meaning calling it in bash
# configuration files like .bash_profile and .bashrc won't work because it
# won't be loaded yet.
#
# to solve this problem I source the internal code at the top of this file
# (look for: source ~/.git-completion.bash)
#
# NOTE: for information on the new `git switch` and `git restore` commands...
# https://www.banterly.net/2021/07/31/new-in-git-switch-and-restore/
#
alias g="git"
alias ga="git add"
alias gai="forgit::add"
alias gb="git branch"
alias gc="git checkout"
alias gcp="forgit::cherry::pick"
alias gd="git diff"
alias gdi="forgit::diff"
alias gup="git push"
alias gdown="git pull"
alias gr="git rebase"
alias gri="forgit::rebase"
alias grs="git restore"
alias gsh="git stash"
alias gshs="forgit::stash::show"
alias gsw="git switch"

# git abstraction alias'
# some of these (e.g. pushit, wip etc) are custom alias defined in ~/.gitconfig
#
# NOTE: some of these abstractions (e.g. gbd, gpr) need autocomplete support still.
#
alias gap="git add --patch"
alias gbi="git branch --list 'integralist*'"
alias gbd="git branch -D"
alias gcm="git commit"
alias gca="git commit --amend"
alias gco="git checkout origin/main --" # followed by path to file to checkout
alias gcoi="forgit::checkout::file"
alias gcv="git commit -v"
alias gf="git pushit"
alias gl="git log"
alias gli="forgit::log"
alias gld="git log-detailed"
alias gls="git log-short"
alias golatest="curl -L https://github.com/golang/go/tags 2>&1 | ag '/golang/go/releases/tag/go[\w.]+' -o | cut -d '/' -f 6 | awk NR==1 | ag '\d.+' -o"
alias gpr="git pull --rebase origin" # make sure to specify the branch name!
alias gst="git st"
alias gwip="git wip"

alias json="python -m json.tool"

bold=$(tput bold)
normal=$(tput sgr0)
alias list='cat ~/.zshrc | grep "^alias" | gsed -En "s/alias (\w+)=(.+)/${bold}\1\n  ${normal}\2\n/p"'

# Note: for the ll alias output...
#
# Slash ('/') immediately after each pathname is a directory
# Asterisk ('*') after each pathname is an executable
# At sign ('@') after each pathname is a symbolic link
# Equals sign ('=') after each pathname is a socket
# Percent sign ('%') after each pathname is a whiteout
# Vertical bar ('|') after each pathname is a FIFO
#
# DISABLED:
# The ls command is now an alias to exa which doesn't have the same flags.
# I've made ls display (using exa) how I want it to, to not need ll.
#
# alias ll="ls -laGpFHh"

alias ls="exa -lh --icons --octal-permissions --no-user --git --group-directories-first --ignore-glob '.git|node_modules' --all"
alias nv="novowels"
alias ping="gping"
alias ps="procs"
alias psw="pwgen -sy 20 1" # brew install pwgen
alias r="source ~/.zshrc"
alias rm="rip"
alias sizeit="du -ahc" # can also add on a path at the end `sizeit ~/some/path`
alias sys='sw_vers && echo && system_profiler SPSoftwareDataType && curl -s https://en.wikipedia.org/wiki/MacOS_version_history | grep -Eo "Version $(version=$(sw_vers -productVersion) && echo ${version%.*}): \"[^\"]+\"" | uniq'
alias tf="terraform"
alias top='htop'
alias uid="uuidgen"
alias updates="softwareupdate --list" # --install --all (or) --install <product name>
alias vim=nvim
alias vimbasic="vim -u /Users/integralist/.vimrc-basic"
alias vimlight="vim -u /Users/integralist/.vimrc-light"

read -r -d '' git_icons <<- EOF
# starship prompt...

conflicted "="	merge conflicts.
ahead      "⇡"	ahead
behind     "⇣"	behind
diverged   "⇕"	diverged
untracked  "?"	untracked
stashed    "$"	stashed
modified   "!"	modified
staged     "+"	staged
renamed    "»"	renamed
deleted    "✘"  deleted
EOF
alias wat='echo "$git_icons"'
alias wut='echo "$git_icons"'

# ⚠️  BINDINGS ⚠️
#
# NOTE: Ctrl+t is setup by FZF and any file(s) selected to be displayed after
# the cursor on the command prompt (e.g. vim <Ctrl-t>). Which is better than
# using my own Ctrl+f binding below if you don't need to preview the file.

# we want Ctrl+g to pass files into vim for editing (e.g. 'go to').
#
# NOTE: Pressing Ctrl+v followed by another key will insert the relevant key
# code into the text for you. So this is what I do with the <Enter> key. Also,
# for <Enter> you can just use \n too.
bindkey -s '^g' 'vim $(fzf)'

# help fix VI mode, and not being able to delete characters
bindkey "^?" backward-delete-char

# To support the configuring our go environment we will override the cd
# command to call the go logic for checking the go version.
#
# We also make sure to call ls when changing directories as it's nice to see
# what's in each directory.
#
function cd {
  builtin cd "$@"
  RET=$?
  ls
  go_version
  return $RET
}

# ⚠️  SHELL ⚠️

# ensure every new shell instance has our ssh keys added
# as it's so tedious when I forget to execute this manually
#
sshagent github
sshagent fastly_integralist

# ensure every new shell instance has a gpg-agent running
# as we want to be storing our git commit signing key passphrase into
# the macOS keychain using pinentry
#
pgrep gpg-agent &>/dev/null || eval $(gpg-agent --daemon)

# to ensure there are no duplicates in the $PATH we call dedupe
#
dedupe

# ⚠️  SOFTWARE ⚠️

# configure fnm node version manager
#
eval "$(fnm env --use-on-cd)"

# configure terraform auto-complete
#
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# configure go environment
#
# Custom go binaries are installed in $HOME/go/bin.
#
# NOTE: Some tools, e.g. TinyGo, won't work with this approach because we're
# just replacing the go binary and the VERSION file, where the originally
# installed version of go will have things like CGO files that TinyGo will try
# to use and if those don't align with the version of the binary we've switched
# to, then it means TinyGo will fail to compile. In that scenario use
# `go_install` function defined below.
#
function go_version {
    if [ -f "go.mod" ]; then
        v=$(grep -E '^go \d.+$' ./go.mod | grep -oE '\d.+$')
        if [[ ! $(go version | grep "go$v") ]]; then
          echo ""
          echo "About to switch go version to: $v"
          if ! command -v "$HOME/go/bin/go$v" &> /dev/null
          then
            go install golang.org/dl/go$v@latest && go$v download && sudo cp $(which go$v) $(which go)
          fi
          sudo cp $(which go$v) $(which go)
          echo -n go$v | sudo tee $(dirname $(dirname $(which go)))/VERSION > /dev/null
        fi
    fi
}
# full go pkg install, not a simple binary switch like 'go_version'
#
function go_install {
  if [ -z "$1" ]; then
    echo USAGE: go_install 1.18.1 OR go_install \$\(golatest\)
    return
  fi
  v=$1
  osname=$(uname -s | tr '[:upper:]' '[:lower:]')
  hardware=$(uname -m)
  mkdir -p ~/goversions
  if ! test -f "~/goversions/go$v.$osname-$hardware.pkg"; then
    printf "\nDownloading %s\n\n" "go$v.$osname-$hardware"
    curl -L -o ~/goversions/go$v.$osname-$hardware.pkg https://go.dev/dl/go$v.$osname-$hardware.pkg
  fi
  echo ""
  sudo rm -rf /usr/local/go; sudo installer -pkg ~/goversions/go$v.$osname-$hardware.pkg -target /usr/local/
  clear
  go version
}
if [ ! -f "$HOME/go/bin/gofumpt" ]; then
    go install mvdan.cc/gofumpt@latest
fi
if [ ! -f "$HOME/go/bin/revive" ]; then
    go install github.com/mgechev/revive@latest
fi
function go_update_tools {
  go install mvdan.cc/gofumpt@latest
  go install github.com/mgechev/revive@latest
}

# configure rust environment
#
# - autocomplete
# - rust-analyzer
# - cargo audit
# - cargo-nextest
# - cargo fmt
# - cargo clippy
# - cargo edit
#
source $HOME/.cargo/env
if [ ! -f "$HOME/.config/rustlang/autocomplete/rustup" ]; then
  mkdir -p ~/.config/rustlang/autocomplete
  rustup completions zsh rustup >> ~/.config/rustlang/autocomplete/rustup
fi
source "$HOME/.config/rustlang/autocomplete/rustup"
if ! command -v rust-analyzer &> /dev/null
then
  brew install rust-analyzer
fi
if ! cargo audit --version &> /dev/null; then
  cargo install cargo-audit --features=fix
fi
if ! cargo nextest --version &> /dev/null; then
  cargo install cargo-nextest
fi
if ! cargo fmt --version &> /dev/null; then
  rustup component add rustfmt
fi
if ! cargo clippy --version &> /dev/null; then
  rustup component add clippy
fi
if ! ls ~/.cargo/bin | grep 'cargo-upgrade' &> /dev/null; then
  cargo install cargo-edit
fi
function rust_update_tools {
  brew_update # called because of rust-analyzer
  rustup self update
  rustup component add rustfmt
  rustup component add clippy
  cargo install cargo-audit --features=fix
  cargo install cargo-nextest
  cargo install cargo-edit
  rustup update
}


# broot (tree replacement) requires a companion shell function (br) to allow
# alt+enter to cd into a directory.
#
# If you install broot via Homebrew then `broot --install` will add a `source`
# to the br function for you. So I've manually moved it from being appended to
# within the following conditional.
#
if [ -f "/Users/integralist/.config/broot/launcher/zsh/br" ]; then
  source /Users/integralist/.config/broot/launcher/zsh/br
fi

# zoxide is a directory switcher
#
# z <pattern>
# zoxide query -ls
#
eval "$(zoxide init zsh)"

# Refer to overridden `cd` function ☝️ for implementation details.
function __zoxide_cd {
  # Original implementation...
  # https://github.com/ajeetdsouza/zoxide/blob/df148c834fa0eb4a99cac18720e05059bf771430/templates/bash.txt#L17-L21
  builtin cd "$@"
  RET=$?
  ls
  go_version
  return $RET
}

# Alacritty
#
if [ -f "~/.bash_completion/alacritty" ]; then
  source ~/.bash_completion/alacritty
fi

# Configuration you don't want as part of your main .zshrc
#
if [ -f "$HOME/.localrc" ]; then
  source "$HOME/.localrc"
fi

# Starship prompt
# https://starship.rs/
#
eval "$(starship init zsh)"

# fig.io autocomplete helpers
#
if test -f "$HOME/.fig/shell/zshrc.post.zsh"; then
  . "$HOME/.fig/shell/zshrc.post.zsh"
fi

echo .zshrc loaded

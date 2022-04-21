# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/bashrc.pre.bash"
#!/usr/bin/env bash
#
# NOTE:
# additional configuration of the shell is handled by ~/.inputrc which
# instructs the Readline utility as to what behaviours it should respect.
#
# DOCUMENTATION:
#   - https://twobithistory.org/2019/08/22/readline.html
#   - man bash (+ /Readline Variables)
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
echo .bashrc loaded

# ⚠️  SCRIPTS ⚠️

# https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/.git-completion.bash

# fzf shell support
#
# run:
# $(brew --prefix)/opt/fzf/install
#
if test -f ~/.fzf.bash; then
  source ~/.fzf.bash
fi

# ⚠️  CONFIGURATION ⚠️

# append to the history file, don't overwrite it
shopt -s histappend

# save multi-line commands as one command
shopt -s cmdhist

# no need to type cd (works for .. but not -, although alias -- -='cd -' fixes it)
shopt -s autocd 2>/dev/null

# autocorrect minor spelling errors
shopt -s dirspell 2>/dev/null
shopt -s cdspell 2>/dev/null

# check windows size if windows is resized
shopt -s checkwinsize 2>/dev/null

# use extra globing features. See man bash, search extglob.
shopt -s extglob 2>/dev/null

# include .files when globbing.
shopt -s dotglob 2>/dev/null

# case insensitive globbing
shopt -s nocaseglob 2>/dev/null

# can be useful to utilise the gnu style error message format
shopt -s gnu_errfmt 2>/dev/null

# ensure SIGHUP is sent to all jobs when an interactive login shell exits
shopt -s huponexit 2>/dev/null

# increase number of file descriptors from default of 254
ulimit -n 1000

# ⚠️  EXPORTS ⚠️

# Homebrew
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
export LSCOLORS="ehaDxxxxHbxxxxxxxxxxxx"

# The `tree` command requires an underscore version of LSCOLOR(S).
export LS_COLORS="rs=0:di=36:ln=32:mh=00:pi=33:so=33:do=33:bd=00:cd=00:or=05;36:mi=04;93:su=31:sg=31:ca=00:tw=36:ow=36:st=36:ex=031:*.tar=00:*.tgz=00:*.arc=00:*.arj=00:*.taz=00:*.lha=00:*.lz4=00:*.lzh=00:*.lzma=00:*.tlz=00:*.txz=00:*.tzo=00:*.t7z=00:*.zip=00:*.z=00:*.dz=00:*.gz=00:*.lrz=00:*.lz=00:*.lzo=00:*.xz=00:*.zst=00:*.tzst=00:*.bz2=00:*.bz=00:*.tbz=00:*.tbz2=00:*.tz=00:*.deb=00:*.rpm=00:*.jar=00:*.war=00:*.ear=00:*.sar=00:*.rar=00:*.alz=00:*.ace=00:*.zoo=00:*.cpio=00:*.7z=00:*.rz=00:*.cab=00:*.wim=00:*.swm=00:*.dwm=00:*.esd=00:*.jpg=00:*.jpeg=00:*.mjpg=00:*.mjpeg=00:*.gif=00:*.bmp=00:*.pbm=00:*.pgm=00:*.ppm=00:*.tga=00:*.xbm=00:*.xpm=00:*.tif=00:*.tiff=00:*.png=00:*.svg=00:*.svgz=00:*.mng=00:*.pcx=00:*.mov=00:*.mpg=00:*.mpeg=00:*.m2v=00:*.mkv=00:*.webm=00:*.ogm=00:*.mp4=00:*.m4v=00:*.mp4v=00:*.vob=00:*.qt=00:*.nuv=00:*.wmv=00:*.asf=00:*.rm=00:*.rmvb=00:*.flc=00:*.avi=00:*.fli=00:*.flv=00:*.gl=00:*.dl=00:*.xcf=00:*.xwd=00:*.yuv=00:*.cgm=00:*.emf=00:*.ogv=00:*.ogx=00:*.aac=00:*.au=00:*.flac=00:*.m4a=00:*.mid=00:*.midi=00:*.mka=00:*.mp3=00:*.mpc=00:*.ogg=00:*.ra=00:*.wav=00:*.oga=00:*.opus=00:*.spx=00:*.xspf=00:";

# application configuration
#
export EDITOR="vim"
export TERM="xterm-256color" # avoid "terminals database is inaccessible" and not being able to run `clear` command (also fixes tmux/vim colour issues).
export TERMINFO=/usr/share/terminfo
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_DEFAULT_COMMAND="ag --path-to-ignore ~/.ignore --hidden --ignore-dir node_modules --ignore-dir vendor --filename-pattern ''"
export FZF_DEFAULT_OPTS='--multi --ansi --preview="bat --color=always {}" --preview-window=right:50%:wrap'
export GPG_TTY=$(tty)
export GREP_COLOR="1;32"
export GREP_OPTIONS="--color=auto"
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page
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
# set history-size 10000000000000000000
#
export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth" # avoid duplicate entries
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history" # don't record some commands
export HISTTIMEFORMAT='%F %T ' # useful timestamp format
history -a # record each line as it gets issued

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
export PATH="$HOME/.cargo/bin:$PATH"

# rustup
#
# avoid https://github.com/rust-analyzer/rust-analyzer/issues/4172
#
# NOTE: Has to be defined after PATH update to locate .cargo directory.
#
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# ⚠️  CUSTOM FUNCTIONS ⚠️

# to ensure there are no duplicates in the $PATH
# we call dedupe at the end of each sourced shell script.
function dedupe {
  export PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
}

# join an array using a specified separator
# e.g. join_by '|' ${exclude[@]}
#
function join_by {
  local IFS="$1"
  shift
  echo "$*"
}

# search for files based on content pattern
# uses 'silver searcher' `ag`
#
function search {
  local flags=${1:-}
  local pattern=$2
  local directory=${3:-.}
  local exclude=(
    '(js/d3/|jquery|prototype).*\.js'
    '\.eps'
    '\.gif'
    '\.git/'
    '\.html'
    '\.jpg'
    '\.json'
    '\.map'
    '\.mypy_cache'
    '\.psd'
    '\.sav'
    '\.so'
    '\.sql'
    'build/'
    'build\.js'
    'dist/'
    'fb\.js'
    'node_modules'
    'swagger'
    'tests/'
    'vendors-bundle\.js'
  )

  if [ -z "$1" ]; then
    printf "\\n\\tUsage:\\n\\t\\tsearch <flags:[--]> <pattern:['']> <directory:[./]>\\n"

    # disabled because \\\\b for literal \b (with double quotes) is ridiculous
    printf '\n\tExample:\n\t\tsearch -- "def\\b" ~/python/app'
    printf '\n\t\tsearch "-G Dockerfile --context=5" "FROM" ./'
    return
  fi

  exclude_joined=$(join_by '|' ${exclude[@]})

  # for some reason I can't just execute the command, I needed to evaluate it?
  #
  cmd=$(echo time ag --ignore "'($exclude_joined)'" "$flags" "'$pattern'" "$directory" 2>/dev/null)
  eval $cmd

  # OLD IMPLEMENTATIONS...
  #
  # time sift -n -X json --err-skip-line-length --group --exclude-ipath "$exclude" "$flags" "$pattern" "$directory" 2>/dev/null
  # time grep --exclude-dir .git -irlno $pattern $directory
}

# create directory structure and cd into it
#
function mkcdir() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

# strip vowels from a string
#
function novowels() {
  echo $1 | tr -d iouae | tee /tmp/novowels | tr -s $(cat /tmp/novowels)
  rm /tmp/novowels
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
  seq $limit | shuf -n 1
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
  git tag -s $tag -m "$tag" && git push origin $tag
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

read -r -d '' dns_help <<- EOF
connectivity debugging steps...

  * check what dns servers are being used:
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
alias dnshelp='echo "$dns_help"'

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
__git_complete g _git
alias ga="git add"
__git_complete ga _git_add
alias gb="git branch"
__git_complete gb _git_branch
alias gc="git checkout"
__git_complete gc _git_checkout
alias gd="git diff"
__git_complete gd _git_diff
alias gup="git push"
__git_complete gup _git_push
alias gdown="git pull"
__git_complete gdown _git_pull
alias gr="git rebase"
__git_complete gr _git_rebase
alias grs="git restore"
__git_complete grs _git_restore
alias gsh="git stash"
__git_complete gsh _git_stash
alias gsw="git switch"
__git_complete gsw _git_switch

# git abstraction alias'
# some of these (e.g. pushit, wip etc) are custom alias defined in ~/.gitconfig
#
# NOTE: some of these abstractions (e.g. gbd, gpr) need autocomplete support still.
#
alias gap="git add --patch"
__git_complete gap _git_add
alias gbi="git branch --list 'integralist*'"
__git_complete gbi _git_branch
alias gbd="git branch -D"
__git_complete gbd _git_branch
alias gcm="git commit"
__git_complete gcm _git_commit
alias gca="git commit --amend"
__git_complete gca _git_commit
alias gco="git checkout origin/main --" # followed by path to file to checkout
__git_complete gco _git_checkout
alias gcv="git commit -v"
__git_complete gcv _git_commit
alias gf="git pushit"
__git_complete gf _git_push
alias gl="git log"
__git_complete gl _git_log
alias gld="git log-detailed"
__git_complete gld _git_log
alias gls="git log-short"
__git_complete gls _git_log
alias gpr="git pull --rebase origin" # make sure to specify the branch name!
__git_complete gpr _git_pull
alias gst="git st"
__git_complete gst _git_status
alias gwip="git wip"

alias json="python -m json.tool"

bold=$(tput bold)
normal=$(tput sgr0)
alias list='cat ~/.bashrc | grep "^alias" | gsed -En "s/alias (\w+)=(.+)/${bold}\1\n  ${normal}\2\n/p"'

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
alias ps="procs --color disable" # disable colours as it's hard to see with dark terminal theme
alias psw="pwgen -sy 20 1" # brew install pwgen
alias r="source ~/.bash_profile" # .bash_profile sources .bashrc and so also causes `pass` autocomplete to be reloaded
alias rm="rip"
alias sizeit="du -ahc" # can also add on a path at the end `sizeit ~/some/path`
alias sshagent='eval "$(ssh-agent -s)" > /dev/null && ssh-add --apple-use-keychain ~/.ssh/github > /dev/null 2>&1'
alias sys='sw_vers && echo && system_profiler SPSoftwareDataType && curl -s https://en.wikipedia.org/wiki/MacOS_version_history | grep -Eo "Version $(version=$(sw_vers -productVersion) && echo ${version%.*}): \"[^\"]+\"" | uniq'
alias tf="terraform"
alias tmuxy='bash ~/tmux.sh'
alias top='btm --current_usage'
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

# we want Ctrl+f to 'find' files using fzf and copy filename to clipboard
bind -x '"\C-f": fzf | pbcopy'

# we want Ctrl+g to pass files into vim for editing (e.g. 'go to').
bind -x '"\C-g": vim $(fzf)'

# every time we want to `time` as shell command, instead of pressing <Enter>
# we'll do <Ctrl+j> and that will prefix the time command.
#
# the '\e indicates an escape code and the I represents <Shift-I>, which in my
# bash shell (due to me having vim bindings enabled) means move the cursor to
# the start of the line. So I can then insert the `time` command.
#
# DISABLED:
# As it is built into starship.
#
# bind '"\C-j": "\eI time \C-m"'

# To support the configuring our go environment we will override the cd
# command to call the go logic for checking the go version.
#
# We also make sure to call ls when changing directories as it's nice to see
# what's in each directory.
#
# NOTE: We use `command` and not `builtin` because the latter doesn't take into
# account anything available on the user's $PATH but also because it didn't
# work with the Starship prompt which seems to override cd also.
function cd {
  command cd "$@"
  RET=$?
  ls
  go_version
  return $RET
}

# ⚠️  SHELL ⚠️

# ensure every new shell instance has our ssh keys added
# as it's so tedious when I forget to execute this manually
#
sshagent

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
eval "$(fnm env)"

# configure terraform auto-complete
#
complete -C /opt/homebrew/bin/terraform terraform

# configure go environment
#
# Custom go binaries are installed in $HOME/go/bin.
#
function go_version {
    if [ -f "go.mod" ]; then
        v=$(grep -E '^go \d.+$' ./go.mod | grep -oE '\d.+$')
        if [[ ! $(go version | grep "go$v") ]]; then
          echo ""
          echo "About to switch go version to: $v"
          if ! command -v "$HOME/go/bin/go$v" &> /dev/null
          then
            echo "run: go install golang.org/dl/go$v@latest && go$v download && sudo cp \$(which go$v) \$(which go)"
            return
          fi
          sudo cp $(which go$v) $(which go)
        fi
    fi
}
if [ ! -f "$HOME/go/bin/gofumpt" ]; then
    go install mvdan.cc/gofumpt@latest
fi
if [ ! -f "$HOME/go/bin/revive" ]; then
    go install github.com/mgechev/revive@latest
fi

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
  rustup completions bash rustup >> ~/.config/rustlang/autocomplete/rustup
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

# broot (tree replacement) requires a companion shell function (br) to allow
# alt+enter to cd into a directory.
#
# If you install broot via Homebrew then `broot --install` will add a `source`
# to the br function for you. I've moved that line from my
# .bashrc/.bash_profile into here.
#
# Extra configuration can be found here:
# /Users/integralist/Library/Application Support/org.dystroy.broot/conf.hjson
#
if [ -f "/Users/integralist/Library/Application Support/org.dystroy.broot/launcher/bash/br" ]; then
  source "/Users/integralist/Library/Application Support/org.dystroy.broot/launcher/bash/br"
fi

# zoxide is a directory switcher
#
# z <pattern>
# zoxide query -ls
#
eval "$(zoxide init bash)"

# Refer to overridden `cd` function ☝️ for implementation details.
function __zoxide_cd {
  # Original implementation...
  # https://github.com/ajeetdsouza/zoxide/blob/df148c834fa0eb4a99cac18720e05059bf771430/templates/bash.txt#L17-L21
  command cd "$@"
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

# Fig
#
# DISABLED until I know it's needed anymore.
#
#
# initialize the starship shell
# https://starship.rs/
#
eval "$(starship init bash)"

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/bashrc.post.bash"

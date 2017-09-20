#!/usr/bin/env bash

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh

# https://github.com/jarun/googler/blob/master/auto-completion/bash/googler-completion.bash
source ~/googler-completion.bash

# https://git.zx2c4.com/password-store/plain/src/completion/pass.bash-completion
# https://www.passwordstore.org/
source /usr/local/etc/bash_completion.d/password-store

# tells Readline to perform filename completion in a case-insensitive fashion
bind "set completion-ignore-case on"

# filename matching during completion will treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# will get Readline to display all possible matches for an ambiguous pattern at the first <Tab> press instead of at the second
bind "set show-all-if-ambiguous on"

# no bell sound on error
bind "set bell-style none"

# enable emacs like bindings (<C-a> and <C-e> for start and end of line shortcuts)
set -o emacs

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

# specify other paths to look inside of when autocompleting
# disabled as I don't use it and it ends up confusing me later
# CDPATH=".:~/code"

# custom environment variables
export DROPBOX="$HOME/Dropbox"
export GITHUB_USER="integralist"

# application configuration
export GOOGLER_COLORS=bjdxxy # https://github.com/jarun/googler/
export LSCOLORS="dxfxcxdxbxegedabagacad" # http://geoff.greer.fm/lscolors/
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page
export GOPATH=$HOME/code/go
export PATH=$HOME/code/go/bin:$HOME/dotvim/voom:/usr/local/sbin:$PATH
export EDITOR="vim"
export HOMEBREW_NO_ANALYTICS=1
export SSH_PUBLIC_KEY="$HOME/.ssh/github_rsa.pub"
# export PROMPT_DIRTRIM=4 # truncate start of long path

# git specific configurations
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true     # * for unstaged changes (+ staged but uncommitted changes)
export GIT_PS1_SHOWSTASHSTATE=true     # $ for stashed changes
export GIT_PS1_SHOWUNTRACKEDFILES=true # % for untracked files
export GIT_PS1_SHOWUPSTREAM="auto"     # > for local commits on HEAD not pushed to upstream
                                       # < for commits on upstream not merged with HEAD
                                       # = HEAD points to same commit as upstream

# history configuration
history -a # record each line as it gets issued
export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth" # avoid duplicate entries
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history" # don't record some commands
export HISTTIMEFORMAT='%F %T ' # useful timestamp format

# force colours
export force_color_prompt=yes

# use colour prompt
export color_prompt=yes

# \e indicates escape sequence (sometimes you'll see \033)
# the m indicates you've provided a colour sequence
#
# 30: Black
# 31: Red
# 32: Green
# 33: Yellow
# 34: Blue
# 35: Purple
# 36: Cyan
# 37: White
#
# a semicolon allows additional attributes:
#
# 0: Normal text
# 1: Bold or light, depending on terminal
# 4: Underline text
#
# there are also background colours (put before additional attributes with ; separator):
#
# 40: Black background
# 41: Red background
# 42: Green background
# 43: Yellow background
# 44: Blue background
# 45: Purple background
# 46: Cyan background
# 47: White background

function prompt_right() {
  echo -e ""
}

function prompt_left() {
  num_jobs=$(jobs | wc -l)

  if [ "$num_jobs" -eq 0 ]; then
    num_jobs=""
  else
    num_jobs=" (\j)"
  fi

  echo -e "\e[33m\]\u. \[\e[37m\]\w\[\e[00m\]$num_jobs\e[31m\]$(__git_ps1)\e[00m\] \e[0;37m(\A)\e[0m"
}

function prompt() {
  compensate=11
  unset PS1
  PS1=$(printf "%*s\r%s\n\$ " "$(($(tput cols)+compensate))" "$(prompt_right)" "$(prompt_left)")
}

function rubo() {
  docker run \
    --cpu-shares 1024 \
    --rm=true \
    --volume "$(pwd):/app" \
    bbcnews/rubocop-config --format simple --fail-level F | grep '^F:\|=='
}

function toggle_hidden() {
  setting=$(defaults read com.apple.finder AppleShowAllFiles)

  if [ "$setting" == "NO" ]; then
    echo "Enabling hidden files"
    defaults write com.apple.finder AppleShowAllFiles YES
  else
    echo "Disabling hidden files"
    defaults write com.apple.finder AppleShowAllFiles NO
  fi

  killall Finder
}

function gms() {
  git merge --squash "$1"
}

function pt {
  # Token found in ~/.papertrail.yml

  if [ -z "$1" ]; then
    printf "\n\tTemplate: papertrail -f \$* | lnav\n"
    printf "\tExample: pt --min-time \"2 hours ago\" \"program:<env>/<service> '<query>'\"\n"
    printf "\tNote: \"program:\" can help with performance\n"
  else
    papertrail -f $* | lnav
  fi
}

function dash {
  local docs=$1
  local query=$2
  open "dash://$docs:$query"
}

function gc {
  if [ -z "$1" ]; then
    printf "\n\tUse: gc some-existing-branch-name\n"
  else
    git checkout "$1"
  fi
}

function gcb {
  if [ -z "$1" ]; then
    printf "\n\tUse: gcb some-new-branch-name (branch will be created)\n"
  else
    git checkout -b "$1"
  fi
}

function dotf {
  if [ -z "$1" ]; then
    pushd "$PWD" && dotfiles && popd
  else
    pushd "$1" && dotfiles && popd
  fi
}

function merge-diff {
  # show all of the commits that were merged in by <commit>
  # but none of the commits that were already on the branch
  # you get to see this (sort of) when using my `git lg` alias (see my .gitconfig)
  git log "$1^-"
}

function headers {
  # Note: also possible by using 2>&1 after curl
  #       which allows piping of output
  #       curl -v -o /dev/null https://www.buzzfeed.com/?site-router-debug=true 2>&1 | grep -i siterouter

  if [[ "$1" =~ -(h|help) ]]; then
    printf "\n\t1st param: URL\n\t2nd param: regex\n\t3rd param: http request header"
    printf "\n\n\tif you have no need for a regex\n\tbut need a http header\n\tthen just use an empty string ''\n"
    return
  fi

  if [ -z "$1" ]; then
    printf "\n\tExamples:\n\t\theaders https://www.buzzfeed.com/?country=us 'x-cache|x-timer|device' '-H User-Agent:iphone'\n"
    printf "\t\theaders https://www.buzzfeed.com/?country=us '' '-H User-Agent:iphone -H X-Foo:bar'\n"
    printf "\n\tHelp:\theaders -h\n\t\theaders -help\n"
    return
  fi

  local url=$1
  local pattern=${2:-''}
  local header=${3:-}
  local response=$(curl -H Fastly-Debug:1 $header -D - -o /dev/null -s "$url") # -D - will dump to stdout
  local status=$(echo "$response" | head -n 1)

  printf "\n%s\n\n" "$status"
  echo "$response" | sort | tail -n +3 | egrep -i "$pattern"
}

function replace {
  # given an extension ($1), find all files with that extension,
  # then search each file for the specified text ($2) and
  # replace it with the specified text ($3)
  local extension=$1
  local f=$2
  local r=$3
  find . -type f -name "*.$extension" -exec gsed -i "s/$f/$r/g" {} +
}

function age {
  local filename=$1;
  local changed=$(perl -MFile::stat -e "print stat(\"${filename}\")->mtime");
  local now=`date +%s`;
  local elapsed;
  let elapsed=now-changed;
  echo $elapsed
}

function search {
  local pattern=$1
  local directory=${2:-.}

  time sift -n -X json --err-show-line-length --exclude-ipath '(build/|\.sav|vendors-bundle\.js|dist/|\.map|\.git/|build\.js|node_modules|tests/|swagger|fb\.js)' $pattern $directory
  # time grep --exclude-dir .git -irlno $pattern $directory
}

# We use _ to indicate an unused variable
# Otherwise shellcheck will kick up a stink
# shellcheck disable=SC2034
read -r -d '' git_icons <<- EOF
* unstaged changes
+ staged but uncommitted changes
$ stashed changes
% untracked files
> local commits on HEAD not pushed to upstream
< commits on upstream not merged with HEAD
= HEAD points to same commit as upstream
EOF

# use `type <alias>` to see what is assigned to an alias/fn/builtin/keyword
alias ascii='man 7 ascii'
alias be="bundle exec"
alias c-="git checkout -"
alias c="clear"
alias cm="git checkout master"
alias copy="tr -d '\n' | pbcopy" # e.g. echo $DEV_CERT_PATH | copy
alias datesec='date +%s'
alias dns="scutil --dns | grep 'nameserver\[[0-9]*\]'"
alias dotfiles="ls -a | grep '^\.' | grep --invert-match '\.DS_Store\|\.$'"
alias drm='docker rm $(docker ps -a -q)'
alias drmi='docker rmi $(docker images -q)'
alias gb="git branch"
alias gbd="git branch -D"
alias gcp="git cherry-pick -"
alias getcommit="git rev-parse HEAD | tr -d '\n' | pbcopy"
alias gitupstream="echo git branch -u origin/\<branch\>"
alias gpr="git pull --rebase origin master"
alias irc="irssi"
alias ll="ls -laGpFHh"
alias ls="ls -GpF"
alias muttb="mutt -F ~/.muttrc-buzzfeed"
alias nvimupdate="brew reinstall --HEAD neovim" # brew reinstall --env=std neovim
alias pipall="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias psw="pwgen -sy 20 1" # brew install pwgen
alias r="source ~/.bashrc"
alias sizeit="du -ahc" # can also add on a path at the end `sizeit ~/some/path`
alias spotify='echo $((1 + RANDOM % 10))' # pick random track to start playing playlist from
alias sshagent='eval "$(ssh-agent -s)" && ssh-add -K ~/.ssh/github_rsa'
alias sshconfig='nvim -c "norm 12ggVjjjgc" -c "wq" ~/.ssh/config && cat ~/.ssh/config | awk "/switch/ {for(i=0; i<=3; i++) {getline; print}}"'
alias sshkey="cd ~/.ssh && ssh-keygen -t rsa -b 4096 -C 'mark.mcdx@gmail.com'"
alias sshvm="ssh dev.buzzfeed.io"
alias tmuxy='bash ~/tmux.sh'
alias uid='echo $(uuidgen)'
alias v='$HOME/code/buzzfeed/mono/scripts/rig_vm'
alias wat='echo "$git_icons"'
alias wut='echo "$git_icons"'

# connectivity debugging steps...
#
#   dns (alias above, to check dns servers set)
#   ping google.com
#   nslookup google.com 8.8.8.8
#   nslookup google.com 192.168.1.1
#   curl -Lsvo /dev/null http://google.com/

eval "$(rbenv init -)"
eval "$(pyenv init -)"

# lazyload nvm
# all props goes to http://broken-by.me/lazy-load-nvm/
# grabbed from reddit @ https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/

lazynvm() {
  unset -f nvm node npm
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}

nvm() {
  lazynvm
  nvm "$@"
}

node() {
  lazynvm
  node "$@"
}

npm() {
  lazynvm
  npm "$@"
}

# Setup File Search AutoComplete (Ctrl-f, type to filter, arrow to look inside folders)
[[ -s "$HOME/.qfc/bin/qfc.sh" ]] && source "$HOME/.qfc/bin/qfc.sh"

# https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
source ~/.bash-preexec.sh

# preexec executes just BEFORE a command is executed
# preexec() { echo "just typed $1"; }

# precmd executes just AFTER a command is executed, but before the prompt is shown
precmd() { prompt; }

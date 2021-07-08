#!/usr/bin/env bash
#
# NOTES:
# additional configuration of the shell is handled by ~/.inputrc which
# instructs the Readline utility as to what behaviours it should respect.
#
# DOCUMENTATION:
#   - https://twobithistory.org/2019/08/22/readline.html
#   - man bash (+ /Readline Variables)
#
echo .bashrc loaded

# to ensure there are no duplicates in the $PATH
# we call dedupe at the end of each sourced shell script.
function dedupe {
  export PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
}

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh

# https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/.git-completion.bash

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

# application configuration
#
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page
export EDITOR="vim"
export FZF_DEFAULT_COMMAND="ag --path-to-ignore ~/.ignore --hidden --ignore-dir node_modules --ignore-dir vendor --skip-vcs-ignores --filename-pattern ''"

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
function novowels() {
  echo $1 | tr -d iouae | tee /tmp/novowels | tr -s $(cat /tmp/novowels)
  rm /tmp/novowels
}

# pretty print $PATH
function ppath() {
  echo "${PATH//:/$'\n'}"
}

# custom alias'
#
# note: use `type <alias>` to see what is assigned to an alias/fn/builtin/keyword
#       alternatively use the `list` alias to show all defined alias' from this file
#
alias brew="HOMEBREW_NO_AUTO_UPDATE=1 brew"
alias c="clear"
alias dns="scutil --dns | grep 'nameserver\\[[0-9]*\\]'"

read -r -d '' dns_help <<- EOF
connectivity debugging steps...

  * check what dns servers are being used:
    dns

    > you can also check via nslookup
    > default should be: 192.168.86.1

  * check we can reach google domain:
    ping google.com

  * check route from home router to internet:
    traceroute google.com

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
    speedtest-cli
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
alias gsh="git stash"
__git_complete gsh _git_stash

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
alias ll="ls -laGpFHh"

alias ls="ls -GpF"
alias nv="novowels"
alias psw="pwgen -sy 20 1" # brew install pwgen
alias r="source ~/.bash_profile" # .bash_profile sources .bashrc and so also causes `pass` autocomplete to be reloaded
alias sizeit="du -ahc" # can also add on a path at the end `sizeit ~/some/path`
alias sshagent='eval "$(ssh-agent -s)" > /dev/null && ssh-add -K ~/.ssh/github > /dev/null 2>&1'
alias sys='sw_vers && echo && system_profiler SPSoftwareDataType && curl -s https://en.wikipedia.org/wiki/MacOS_version_history | grep -Eo "Version $(version=$(sw_vers -productVersion) && echo ${version%.*}): \"[^\"]+\"" | uniq'
alias tf="terraform"
alias tmuxy='bash ~/tmux.sh'
alias uid="uuidgen"
alias updates="softwareupdate --list" # --install --all (or) --install <product name>

read -r -d '' git_icons <<- EOF
* unstaged changes
+ staged but uncommitted changes
$ stashed changes
% untracked files
> local commits on HEAD not pushed to upstream
< commits on upstream not merged with HEAD
= HEAD points to same commit as upstream
EOF
alias wat='echo "$git_icons"'
alias wut='echo "$git_icons"'

function prompt_right() {
  echo -e ""
}

# DOCUMENTATION:
#   - man bash (+ /PROMPTING)
#
function prompt_left() {
  num_jobs=$(jobs | wc -l)

  if [ "$num_jobs" -eq 0 ]; then
    num_jobs=""
  else
    num_jobs=' (\j)'
  fi

  echo -e "\\e[33m\\]\\u. \\[\\e[37m\\]\\w\\[\\e[00m\\]$num_jobs\\e[31m\\]$(__git_ps1)\\e[00m\\] \\e[0;37m(\\A)\\e[0m"

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
}

function prompt() {
  local EXIT="$?"
  local red='\[\e[0;31m\]'
  local normal=$(tput sgr0)

  compensate=11
  unset PS1

  err=""
  if [ $EXIT != 0 ]; then
    err="${red}❌${normal}"
  fi

  PS1=$(printf "%*s\\r%s %s\\n\$ " "$(($(tput cols)+compensate))" "$(prompt_right)" "$(prompt_left)" "${err}")
}

# DOCUMENTATION:
#   - man bash (+ /PROMPT_COMMAND)
#
PROMPT_COMMAND=prompt

# provides a fzf command for searching for single files
# but fzf requires piping to pbcopy to be useful
#
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# we want Ctrl+f to 'find' files using fzf and copy filename to clipboard
#
bind -x '"\C-f": fzf --preview="cat {}" --preview-window=top:50%:wrap | pbcopy'

# we want Ctrl+g to pass files into vim for editing.
# -m allows multiple file selection using <Tab>
#
bind -x '"\C-g": vim $(fzf -m)'

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

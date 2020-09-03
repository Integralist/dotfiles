#!/usr/bin/env bash
#
# NOTES:
# additional configuration of the shell is handled by ~/.inputrc which
# instructs the Readline utility as to what behaviours it should respect.
#
# Throughout this configuration file you'll see:
# shellcheck source=/dev/null
#
# This prevents the shellcheck tool from worrying about code sourced at runtime.
# e.g. source ~/.foo doesn't make shellcheck happy
# https://github.com/koalaman/shellcheck/wiki/SC1090
#
# DOCUMENTATION:
#   - https://twobithistory.org/2019/08/22/readline.html
#   - man bash (+ /Readline Variables)
#
echo .bashrc loaded

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# shellcheck source=/dev/null
source ~/.git-prompt.sh

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
export FZF_DEFAULT_COMMAND="ag --ignore-dir node_modules --filename-pattern ''" # can use --ignore-dir multiple times

# git specific configurations
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

# disabled following change as bash-preexec states it'll break things
#
# PROMPT_COMMAND="history -a" # don't lose commands when session accidentally terminates

# shellcheck source=/dev/null
# https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
source ~/.bash-preexec.sh

# force colours
export force_color_prompt=yes

# use colour prompt
export color_prompt=yes

# setup golang bin directory so various tools can be found
export PATH="$HOME/go/bin:/usr/local/sbin:$PATH"

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
  compensate=11
  unset PS1

  PS1=$(printf "%*s\\r%s\\n\$ " "$(($(tput cols)+compensate))" "$(prompt_right)" "$(prompt_left)")
}

function gcb {
  # create git branch

  if [ -z "$1" ]; then
    printf "\\n\\tUse: gcb <create-branch-name>\\n"
  else
    transformed=$(echo "$1" | tr '-' '_')
    git checkout -b "integralist/$(date +%Y_%m_%d)_$transformed"
  fi
}

function gbr {
  # rename git branch

  if ! git rev-parse --show-toplevel --quiet 1> /dev/null 2>&1; then
    echo "you're not within a git repository."
    return 0
  fi

  # short circuit logic if actual branch names given
  if [ -n "$1" ] && [ -n "$2" ]; then
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]]; then
      echo ""
      git branch -m "$1" "$2"
    fi

    return 0
  fi

  branches=$(git branch | perl -pe 'BEGIN{$N=1;$S=". "} s/^/$N++ . $S/ge')

  echo -e "\nselect a branch to rename (e.g. gbr <number>)\n"
  echo -e "\nnote: if you called 'gbr -p' then the new name you give will be prefixed\n"
  echo "$branches"
  echo ""

  read selection

  index=0

  while IFS= read -r line; do
    _=$(( index++ ))

    if [ "$index" -eq "$selection" ]; then
      branch=$(echo "$line" | cut -d " " -f 4)

      # catch scenario where `master` is the current branch
      # so the spacing is off when trying to cut with 'space' as a delimeter
      if [ "$branch" = "" ]; then
        branch=$(echo "$line" | cut -d " " -f 3)
      fi

      break;
    fi
  done <<< "$branches"

  echo "give us the new branch name..."
  read new_branch_name

  if [[ "$1" == "-p" ]]; then
    git branch -m "$branch" "$new_branch_name/$branch"
  else
    git branch -m "$branch" "$new_branch_name"
  fi
}

function gc {
  # checkout git branch

  if ! git rev-parse --show-toplevel --quiet 1> /dev/null 2>&1; then
    echo "you're not within a git repository."
    return 0
  fi

  # short circuit logic if actual branch name given
  if [ -n "$1" ]; then
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]]; then
      echo ""
      git checkout "$1"
    fi

    return 0
  fi

  branches=$(git branch | perl -pe 'BEGIN{$N=1;$S=". "} s/^/$N++ . $S/ge')

  echo -e "\nselect a branch to checkout (e.g. gbd <number|name>)\n"
  echo "$branches"
  echo ""

  read selection

  index=0

  while IFS= read -r line; do
    _=$(( index++ ))

    if [ "$index" -eq "$selection" ]; then
      branch=$(echo "$line" | cut -d " " -f 4)

      # catch scenario where `master` is the current branch
      # so the spacing is off when trying to cut with 'space' as a delimeter
      if [ "$branch" = "" ]; then
        branch=$(echo "$line" | cut -d " " -f 3)
      fi

      git checkout "$branch"

      break;
    fi
  done <<< "$branches"
}

function gbd {
  # delete git branch

  if ! git rev-parse --show-toplevel --quiet 1> /dev/null 2>&1; then
    echo "you're not within a git repository."
    return 0
  fi

  # short circuit logic if actual branch name given
  if [ -n "$1" ]; then
    if [ "$1" == "master" ]; then
      echo "sorry, not going to let you delete 'master'"
    else
      git branch -D "$1"
    fi

    return 0
  fi

  branches=$(git branch | perl -pe 'BEGIN{$N=1;$S=". "} s/^/$N++ . $S/ge')

  echo -e "\nselect a branch to delete (e.g. gbd <number|name>)\n"
  echo "$branches"
  echo ""

  read selection

  index=0

  while IFS= read -r line; do
    _=$(( index++ ))

    if [ "$index" -eq "$selection" ]; then
      branch=$(echo "$line" | cut -d " " -f 4)

      # catch scenario where `master` is the current branch
      # so the spacing is off when trying to cut with 'space' as a delimeter
      if [ "$branch" = "" ]; then
        branch=$(echo "$line" | cut -d " " -f 3)
      fi

      if [ "$branch" == "master" ]; then
        echo "sorry, not going to let you delete 'master'"
      else
        git branch -D "$branch"
      fi

      break;
    fi
  done <<< "$branches"
}

function headers {
  # make network request and print response headers
  # allow for filtering of headers based on regex pattern
  #
  # Note: also possible by using 2>&1 after curl
  #       which allows piping of output
  #       curl -v -o /dev/null https://www.buzzfeed.com/?site-router-debug=true 2>&1 | grep -i siterouter

  if [[ "$1" =~ -(h|help)$ ]]; then
    printf "\\n\\t1st param: URL\\n\\t2nd param: regex\\n\\t3rd param: http request header"
    printf "\\n\\n\\tif you have no need for a regex\\n\\tbut need a http header\\n\\tthen just use an empty string ''\\n"
    return
  fi

  if [ -z "$1" ]; then
    printf "\\n\\tExamples:\\n\\t\\theaders https://www.buzzfeed.com/?country=us 'x-(vcl|buzz|cache|site)' '-H User-Agent:iphone'\\n"
    printf "\\t\\theaders https://www.buzzfeed.com/?country=us 'mobile' '-H User-Agent:iphone -H X-Foo:bar'\\n"
    printf "\\t\\theaders https://www.buzzfeed.com/?country=us '' '-H User-Agent:iphone -H X-Foo:bar'\\n"
    printf "\\n\\tHelp:\\theaders -h\\n\\t\\theaders -help\\n"
    return
  fi

  local url=$1
  local pattern=${2:-''}
  local header=${3:-}

  # why define local variables separate from their sub processes?
  # summary: return values are ignored otherwise, and so `set -e` might miss them
  # https://github.com/koalaman/shellcheck/wiki/SC2155
  local response status

  # don't quote $header as it breaks everything
  # shellcheck disable=SC2086
  response=$(curl -H X-BF-Debug:1 -H "X-BF-DebugKey: $BUZZFEED_DEBUG_KEY" $header -D - -o /dev/null -s "$url") # -D - will dump to stdout
  status=$(echo "$response" | head -n 1)

  printf "\\n%s\\n\\n" "$status"
  echo "$response" | sort | tail -n +3 | grep -Ei "$pattern"
}

function search {
  # search for files based on content pattern
  # uses sift search tool

  local flags=${1:-}
  local pattern=$2
  local directory=${3:-.}
  local exclude='(build/|\.mypy_cache|\.sav|vendors-bundle\.js|dist/|\.map|\.git/|(js/d3/|jquery|prototype).*\.js|build\.js|node_modules|tests/|swagger|fb\.js|\.eps|\.so|\.sql|\.jpg|\.gif|\.psd|\.html)'

  if [ -z "$1" ]; then
    printf "\\n\\tUsage:\\n\\t\\tsearch <flags:[--]> <pattern:['']> <directory:[./]>\\n"

    # shellcheck disable=SC1117
    # disabled because \\\\b for literal \b (with double quotes) is ridiculous
    printf '\n\tExample:\n\t\tsearch -- "def\\b" ~/code/buzzfeed/mono/site_router'
    printf '\n\t\tsearch "--files=Dockerfile" "--context=5" "FROM node" ./'
    printf '\n\t\tsearch --exclude-ipath "(.venv|.rig)" "arn:aws:s3"'
    printf '\n\t\tsearch "-A 5" "..." ./  # shows 5 lines before search results'
    printf '\n\t\tsearch "-B 5" "..." ./  # shows 5 lines after search results\n'
    return
  fi

  time sift -n -X json --err-skip-line-length --group --exclude-ipath "$exclude" "$flags" "$pattern" "$directory" 2>/dev/null
  # time grep --exclude-dir .git -irlno $pattern $directory
}

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

# shellcheck disable=SC2034
read -r -d '' dns_help <<- EOF
connectivity debugging steps...

  * check what dns servers are being used:
    dns

    > you can also check via nslookup
    > default should be: 192.168.86.1

  * check we can reach google domain:
    ping google.com

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

# custom alias'
#
# note: use `type <alias>` to see what is assigned to an alias/fn/builtin/keyword
#       alternatively use the `list` alias to show all defined alias' from this file

alias c-="git checkout -"
alias c="clear"
alias cm="git checkout master"
alias dns="scutil --dns | grep 'nameserver\\[[0-9]*\\]'"
alias dnshelp='echo "$dns_help"'
alias dockerrmi='docker rmi $(docker images -a -q)'
alias dockerrmc='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
# to work around the fact that another fastly cli tool I use (go-fastly-cli) uses `FASTLY_API_TOKEN` env var
# and that env var is set to stage.buzzfeed.com api key
alias fastly='fastly -t $(head -n 1 $HOME/Library/Application\ Support/fastly/config.toml | cut -d '\''"'\'' -f 2)'
alias gb="git branch --list 'integralist*'"
alias gba="git branch"
alias gls="git log-short"
alias gpr="git pull --rebase origin master"

# shellcheck disable=SC2034
bold=$(tput bold)
# shellcheck disable=SC2034
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
alias psw="pwgen -sy 20 1" # brew install pwgen
alias r="source ~/.bash_profile" # this also sources .bashrc and also causes `pass` autocomplete to be reloaded
alias sizeit="du -ahc" # can also add on a path at the end `sizeit ~/some/path`
alias sshagent='eval "$(ssh-agent -s)" > /dev/null && ssh-add -K ~/.ssh/github_rsa > /dev/null 2>&1'
alias sshvm="ssh dev.buzzfeed.io"
alias tmuxy='bash ~/tmux.sh'
alias uid="uuidgen"
alias updates="softwareupdate --list" # --install --all (or) --install <product name>
alias v='$HOME/code/buzzfeed/mono/scripts/rig_vm'
alias wat='echo "$git_icons"'
alias wut='echo "$git_icons"'

eval "$(python3 -m pip completion --bash)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# preexec executes just BEFORE a command is executed
# preexec() { echo "just typed $1"; }
# precmd executes just AFTER a command is executed, but before the prompt is shown
precmd() { prompt; }

# shellcheck source=/dev/null
# provides a fzf command for searching for single files
# but fzf requires piping to pbcopy to be useful
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# we want Ctrl+f to 'find' files using fzf and copy filename to clipboard
# we use `copy`, which is an alias for trimming newline before using pbcopy
bind -x '"\C-f": fzf --preview="cat {}" --preview-window=top:50%:wrap | pbcopy'

# shellcheck disable=SC2016
# we want Ctrl+g to pass files into vim for editing (-m allows multiple file
# selection using Tab)
bind -x '"\C-g": vim $(fzf -m)'

if [ -n "$KITTY_WINDOW_ID" ]; then
  source <(kitty + complete setup bash)
fi

# ensure every new shell instance has our ssh keys added
# as it's so tedious when I forget to execute this manually
#
sshagent

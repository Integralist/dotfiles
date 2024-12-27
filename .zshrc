#!/usr/bin/zsh
#
# NOTE:
# additional configuration of the shell is handled by ~/.inputrc which
# instructs the Readline utility as to what behaviours it should respect.
#
# DOCUMENTATION:
#   - https://twobithistory.org/2019/08/22/readline.html
#   - man zsh (+ /Readline Variables)
#
# STRUCTURE:
#   - CONFIGURATION
#   - EXPORTS
#   - SCRIPTS
#   - CUSTOM FUNCTIONS
#   - ALIAS
#   - BINDINGS
#   - BIND KEYS
#   - SHELL
#   - SOFTWARE
#

# ⚠️  CONFIGURATION ⚠️
#
# https://zsh.sourceforge.io/Doc/Release/Options.html
#
# If you want to share history across terminal instances:
#   setopt SHARE_HISTORY
# But be warned this can be annoying when you want to ⬆️ the history and find your recent command is no longer the most recent.
#

setopt AUTO_CD # Automatically changes to a directory if a command matches a directory name, without requiring the cd command.
setopt CDABLE_VARS # Allows variable names to be used with cd. If the argument to cd matches a variable name, Zsh changes to the directory stored in the variable.
setopt CD_SILENT # Suppresses output when changing directories with cd.
setopt CHASE_DOTS # Resolves . and .. in pathnames when navigating directories, even if symbolic links are present.
setopt CHASE_LINKS # Resolves symbolic links to their target directory when changing directories.
setopt ALWAYS_LAST_PROMPT # Ensures the prompt is always displayed after executing a command, even if the terminal output is redirected.
setopt ALWAYS_TO_END # Moves the cursor to the end of the line when a history entry is modified during editing.
setopt AUTO_LIST # Automatically lists completions when the tab key is pressed, and there is more than one possible match.
setopt AUTO_MENU # Displays a menu of completion options after a partial match is typed and tab is pressed multiple times.
setopt AUTO_NAME_DIRS # Automatically creates named directory aliases for directories specified in the cdpath.
setopt AUTO_PARAM_KEYS # When completing associative array keys, Zsh will add a closing ] automatically.
setopt AUTO_PARAM_SLASH # Automatically adds a trailing slash when completing directory names.
setopt AUTO_REMOVE_SLASH # Removes an unnecessary trailing slash from pathnames when not needed.
setopt COMPLETE_IN_WORD # Allows completion to occur in the middle of a word rather than just at the cursor’s end.
setopt GLOB_COMPLETE # Enables completion that treats globs (e.g., *.txt) as potential matches to complete filenames.
setopt HASH_LIST_ALL # Lists all executables in the hash table when hashing is enabled (used for command lookup).
setopt LIST_AMBIGUOUS # Lists possible completions for ambiguous inputs instead of waiting for more typing.
setopt LIST_PACKED # Displays completion options in a compact, multi-column format.
setopt LIST_TYPES # Adds a file type indicator (e.g., / for directories, * for executables) when listing completions.
setopt MENU_COMPLETE # Cycles through completion options by repeatedly pressing the tab key.
setopt EXTENDED_GLOB # Enables advanced globbing features like negation (^), matching ranges, etc.
setopt REMATCH_PCRE # Enables Perl-compatible regular expressions (PCRE) for pattern matching in Zsh.
setopt INC_APPEND_HISTORY # Appends commands to the history file incrementally as they are executed.
setopt HIST_EXPIRE_DUPS_FIRST # Removes the oldest duplicate entries from history when the history size limit is reached.
setopt HIST_FCNTL_LOCK # Uses file locking to prevent simultaneous access issues with the history file.
setopt HIST_FIND_NO_DUPS # Avoids showing duplicate history entries when searching interactively.
setopt HIST_IGNORE_ALL_DUPS # Removes all duplicate entries from history when a new duplicate command is added.
setopt HIST_REDUCE_BLANKS # Removes extra whitespace from commands saved to history.
setopt ALIASES # Enables alias expansion for command lines.

# Enables Vi-style keybindings for command-line editing.
#
# DISABLED:
# When using the Warp terminal it wasn't necessary to use vi-mode.
# As the terminal had great text selection/navigation support built-in.
#
# WARNING: If `vi` is part of the EDITOR substring then VI mode is auto-enabled!
# So as we set EDITOR to "nvim" we have to use `bindkey -e .` to forcibly disable.
# See BIND KEYS section where we set that.
#
# RE-ENABLED:
# Because ghostty doesn't have support for selecting text easily.
setopt VI

setopt NOCORRECT NOCORRECTALL # Disables spell checking for the current command or for all commands.
unsetopt BEEP # Disables the terminal bell or audible beep when an error or alert occurs.
unsetopt CASE_GLOB # Makes globbing case-insensitive (disabled here, so globbing is case-sensitive).
unsetopt CASE_MATCH # Requires case-sensitive pattern matching (disabled here, so matching is case-insensitive).

# http://zsh.sourceforge.net/Doc/Release/Options.html#Expansion-and-Globbing
# By default, if a command line contains a globbing expression which doesn't
# match anything, Zsh will print the error message you're seeing, and not run
# the command at all. You can disable this using the following...
setopt +o nomatch

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
export EDITOR="nvim"
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_DEFAULT_COMMAND="rg --hidden --files"
export FZF_DEFAULT_OPTS='--multi --ansi --preview="bat --color=always {}" --preview-window=right:50%:wrap'
export GPG_TTY=$(tty) # tell gpg which terminal to use when prompting for a passphrase
export GREP_COLOR="1;32"
export GREP_OPTIONS="--color=auto"
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page
# export PINENTRY_USER_DATA="USE_CURSES=1" # tell pinentry to use a terminal-based interface (not the OS UI prompt)
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

# PATH modifications
#
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"           # rust executables
export PATH="/opt/homebrew/opt/ruby/bin:$PATH" # ruby executables
export PATH="$HOME/bin:$PATH"                  # terraform executables (via tfswitch)

# rustup
#
# avoid https://github.com/rust-analyzer/rust-analyzer/issues/4172
#
# NOTE: Has to be defined after PATH update to locate .cargo directory.
#
if ! command -v rustc &> /dev/null
then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# ⚠️  SCRIPTS ⚠️

# 🚨 If using the Warp terminal you'll find it doesn't support shell auto-complete.
# https://github.com/warpdotdev/Warp/discussions/434
# The workaround is to spawn a subshell ($ zsh) but this DISABLES lots of Warp features 😞
# But you can always `exit` the subshell after you're done (which is fine for me as I only use this workaround for searching `pass` entries).

# marlonrichert/zsh-autocomplete
# requires removing any calls to compinit from your .zshrc file.
# DISABLED: in favour of using fzf-tab (below)
#
# source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# general autocomplete helpers
#
autoload -U +X bashcompinit && bashcompinit

# Setup fpath for brew-installed completions, if available
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

# Load Zsh completion system
# DISABLED: in favour of marlonrichert/zsh-autocomplete (loaded above)
# RE-ENABLED: in favour of using fzf-tab (https://github.com/Aloxaf/fzf-tab)
#
# autoload -Uz compinit && compinit
autoload -U compinit; compinit

# fzf-tab
#
if test -f ~/.zsh/fzf-tab/fzf-tab.plugin.zsh; then
  source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
else
	git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
  source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
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
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# zstyle ':completion:*' menu no
# zstyle ':completion:*' list-suffixes
# zstyle ':completion:*' expand prefix suffix

# Highlight the selected option when using auto-complete.
zstyle ':completion:*:default' menu select=2

# fzf shell support
#
# The `brew install fzf` installation provides an `install` script, which:
#
# Enables ctrl-r for fuzzy searching command history.
# Enables ctrl-t for selecting multiple files to append to command line (see also vf alias).
# Enables esc-c for cd'ing to the selected directory (esc == alt/meta).
#
if test -f ~/.fzf.zsh; then
  source ~/.fzf.zsh
else
	$(brew --prefix)/opt/fzf/install
  source ~/.fzf.zsh
fi

# zsh-users/zsh-autosuggestions
#
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-users/zsh-syntax-highlighting
#
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


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
  ssh-add --apple-use-keychain ~/.ssh/"$1" > /dev/null 2>&1
}

# to ensure there are no duplicates in the $PATH
# we call dedupe at the end of each sourced shell script.
function dedupe {
  export PATH=$(echo -n "$PATH" | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
}

# create directory structure and cd into it
#
function mkcdir() {
  mkdir -p -- "$1" && cd -P -- "$1" || exit
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
  seq "$limit" | gshuf -n 1
}

# tabs are indicated by ^I and line endings by $
# useful for validating things like a Makefile
#
function hiddenchars() {
  local filename=$1
  cat -e -t -v "$filename"
}

# delete tag from both local and remote repositories
#
function git_tag_delete() {
  if [ -z "$1" ]; then
    echo "Please pass the tag you want deleted."
    echo "NOTE: Go requires a v prefix."
    return
  fi
  git tag -d "$1"
  git push --delete origin "$1"
}

# cut a new release for a git project
#
function git_tag_release() {
  if [ -z "$1" ]; then
    echo "Please pass the tag you want created."
    echo "NOTE: Go requires a v prefix."
    return
  fi
  tag="$1"
  git tag -s "$tag" -m "$tag" && git push origin "$tag"
  # git tag $tag -m "$tag" && git push origin $tag
}

# display contents of archive file
#
function list_contents() {
  if echo "$1" | grep -Ei '\.t(ar\.)?gz$' &> /dev/null; then
    tar -ztvf "$1"
    return
  fi

  if echo "$1" | grep -Ei '.zip$' &> /dev/null; then
    unzip -l "$1"
    return
  fi

  echo unsupported file extension
}

# clean out docker
#
function docker_clean() {
  dockerrmc
  dockerrmi
  dockerprune
}

# zellij terminal multiplexer
#
function zell() {
  if [ -z "$1" ]; then
    echo "USAGE: zell <SESSION_NAME>"
    return
  fi
  if zellij list-sessions | grep '(current)' &> /dev/null; then
    zellij -s "$1"
  fi
}

# reverse IP lookup
# like `dig -x <IP>` but using dog instead
# dog doesn't have a built in solution (https://github.com/ogham/dog/issues/32)
#
function dogr() {
  if [ -z "$1" ]; then
    echo "USAGE: dogr <IP>"
    return
  fi
  echo "$1" | awk -F. '{print $4"."$3"."$2"."$1}' | xargs -I % dog %.in-addr.arpa ANY
}

# ⚠️  ALIAS ⚠️

# NOTE: use `type <alias>` to see what is assigned to an alias/fn/builtin/keyword
#       the use of `type` doesn't always work in Zsh so use `whence -c` instead
#       alternatively use the `list` alias to show all defined alias' from this file
#       the `alias` function itself with no arguments will actually print all too
#
alias c="clear"
alias cat="bat"
alias commit='cat ~/.gitcommit'
alias datets='date -u +"%s"'
alias dns="scutil --dns | grep 'nameserver\\[[0-9]*\\]'"

read -r -d '' network_help <<- EOF
* Check DNS resolution:

  $ networksetup -listnetworkserviceorder
  $ networksetup -getinfo Wi-Fi
  $ networksetup -getdnsservers Wi-Fi
  $ scutil --dns | grep 'nameserver[[0-9]*]'
  $ host {HOSTNAME}
  $ nslookup {HOSTNAME} <RESOLVER_IP: 8.8.8.8|1.1.1.1>
  $ dog {HOSTNAME}

  > Change DNS Resolver via the Network UI tab in macOS or via Terminal:
  > https://superuser.com/a/86188
  >
  > e.g.
  > networksetup -getdnsservers Wi-Fi
  > networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
  > sudo discoveryutil mdnsflushcache

* Check HTTP (while avoiding DNS resolution):

  $ curl -v -H "Host:{HOSTNAME}" \$(dog {HOSTNAME} --short)

* Check hostname availability:

  $ /sbin/ping {HOSTNAME}
  $ gping {HOSTNAME...}
  $ gping github.com fastly.com integralist.co.uk

* Check route from home router to internet:

  $ traceroute -av {HOSTNAME}
  $ sudo mtr {HOSTNAME} --report-wide --show-ips --aslookup

  You can also get the geolocation information using:

  $ curl -s https://api.ipbase.com/v1/json/{IP} | jq

* Check LAN (Local Area Network) IPs:

  $ arp -a # ARP (Address Resolution Protocol)

* Check upload/download speed:

  $ networkQuality -s

* Check performance via external sites:

  https://www.speedcheck.org/
  https://www.speedtest.net/
  https://speed.cloudflare.com/
  https://fast.com/
EOF
alias networkhelp='echo "$network_help"'

alias dockerprune='docker system prune --all'
alias dockerrmi='docker rmi $(docker images -a -q)'
alias dockerrmc='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
alias fd='fd --hidden'

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
alias gb="git branch-verbose"
alias gc="git checkout"
alias gcp="forgit::cherry::pick"
alias gd="git diff"
alias gdw="git diff-word"
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
alias gam="git add -u" # stage only modified files
alias gan="git add -N" # stage only new files
alias gap="git add --patch"
alias gbi="git branch --list 'integralist*'"
alias gbd="git branch -D"
alias gcm="git commit"
alias gca="git commit --amend"
alias gco="git checkout origin/main --" # followed by path to file to checkout
alias gcoi="forgit::checkout::file"
alias gcv="git commit -v"
alias gf="git pushit"
alias gl="git log-graphstat"
alias gli="forgit::log"
alias glm="git log-me"
alias gls="git log-short"
alias golatest="curl -L https://github.com/golang/go/tags 2>&1 | ag '/golang/go/releases/tag/go[\w.]+' -o | cut -d '/' -f 6 | grep -v 'rc' | awk NR==1 | ag '\d.+' -o"
alias golatestall="curl -s 'https://go.dev/dl/?mode=json' | jq -c '.[]' | jq -c '.files[] | select(.os == \"darwin\" or .os == \"linux\" or .os == \"freebsd\") | select(.arch == \"386\" or .arch == \"amd64\" or .arch == \"armv6l\" or .arch == \"arm64\") | select(.kind == \"archive\")'"
alias gpr="git pull --rebase origin" # make sure to specify the branch name!
alias gst="git st"
alias gstm="git stm"
alias gt="git tag --sort=-creatordate | tac" # brew install tac (cat backwards)
alias gwip="git wip"

# To view built-in command help documentation Zsh doesn't have a `help` command like Bash.
# So we have to install its equivalent: run-help.
unalias run-help 2>/dev/null
autoload run-help
HELPDIR=$(command brew --prefix)/share/zsh/help
alias help=run-help

alias history="history 0" # force history to show full history

alias ips="arp -a" # some IPs (like my NAS DS220) don't show up until I able to ping it as that starts up the box.
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
# The ls command is now an alias to eza which doesn't have the same flags.
# I've made ls display (using eza) how I want it to, to not need ll.
#
# alias ll="ls -laGpFHh"

alias ldd="otool -L" # display shared object files a binary is linked to
alias ls="eza -lh --icons --octal-permissions --no-user --git --group-directories-first --all" # REMOVED: `--ignore-glob '.git|node_modules'`
alias lsd="ls -s 'modified'"
alias mtr="sudo mtr --report-wide --show-ips --aslookup"
alias nv="novowels"
alias ping="gping"
alias ps="procs"
alias psw="pwgen -sy 20 1" # brew install pwgen
alias r="source ~/.zshrc"
alias rg="rg --glob '!node_modules/' --no-ignore --hidden"
alias ripall='rip * &> /dev/null ; rip .* &> /dev/null' # for redirection to work in Zsh we need to set `setopt +o nomatch`
alias sizeit="du -ahc" # can also add on a path at the end `sizeit ~/some/path`
alias sys='sw_vers && echo && system_profiler SPSoftwareDataType && curl -s https://en.wikipedia.org/wiki/MacOS_version_history | grep -Eo "Version $(version=$(sw_vers -productVersion) && echo ${version%.*}): \"[^\"]+\"" | uniq'
alias tf="terraform"
alias top='htop'
alias tree='tree -I node_modules'
alias uid="uuidgen"
alias updates="softwareupdate --list" # --install --all (or) --install <product name>
alias v=nvim
alias vf='vim $(fzf)'
alias vim=nvim
alias vi='vi -c "set nocompatible" -c "set number" -c "set cursorline" -c "set expandtab" -c "set hlsearch" -c "set visualbell" -c "set tabstop=2" -c "set shiftwidth=2" -c "syntax on"'
alias weather="curl wttr.in"
alias which='whence -va'

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

# We override the cd command to call ls when changing directories as it's nice
# to see what's in each directory. We do this using a Zsh hook function.
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
function chpwd() {
    ls
    if [ -e .go-version ]; then
      "$GOPATH"/bin/g install $(cat .go-version)
    else
      "$GOPATH"/bin/g install $(golatest)
    fi

    # configure git maintenance
    #
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
      git maintenance start
    fi

    # clean out any .DS_Store files
    #
    if [[ $PWD != $HOME ]]; then
			# find . -type f -name '.DS_Store' -delete
			fd '.DS_Store' --type f --hidden --absolute-path | xargs -I {} rm {}
    fi
}

# ⚠️  BIND KEYS ⚠️
#
# 🚨 If using the Warp terminal you'll find it doesn't support shell bindings.

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

# ⚠️  SHELL ⚠️

# ensure every new shell instance has our ssh keys added
# as it's so tedious when I forget to execute this manually
#
sshagent github
sshagent fastly
sshagent fastly_integralist

# ensure every new shell instance has a gpg-agent running
# as we want to be storing our git commit signing key passphrase into
# the macOS keychain using pinentry
#
pgrep gpg-agent &>/dev/null || eval $(gpg-agent --daemon)

# to ensure there are no duplicates in the $PATH we call dedupe
#
dedupe

# ensure we use https://github.com/garabik/grc (brew install grc) to colourize
# the shell output for some standard tools.
#
# if (( $+commands[grc] )) && (( $+commands[brew] ))
# then
  # DISABLED: as grc was breaking docker command
  # source `brew --prefix`/etc/grc.zsh
# fi

# ⚠️  SOFTWARE ⚠️

if ! command -v shellcheck &> /dev/null
then
  brew install shellcheck
fi

# configure fnm node version manager
# https://github.com/Schniz/fnm/blob/master/docs/configuration.md
#
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# configure terraform auto-complete
#
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# configure go environment
#
# https://github.com/stefanmaric/g
# curl -sSL https://git.io/g-install | sh -s
#
# auto-switching of go versions is done using .go-version file (see chpwd() function)
#
# Example version install location:
# /Users/integralist/.go/.versions/1.21.0
#
# The $GOROOT/bin/go executable is either the latest go version or .go-version
#
# Running `go install` will install binaries into ~/go/bin
export GOROOT="$HOME/.go"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.humanlog/bin:$PATH" # https://github.com/humanlogio/humanlog (installed via `go install` then upgrade via the installed binary which installs the upgrade in a different path)
alias gov="$GOPATH/bin/g"

if [ -e .go-version ]; then
  "$GOPATH"/bin/g install $(cat .go-version)
else
  "$GOPATH"/bin/g install $(golatest)
fi

if [ ! -f "$HOME/go/bin/gopls" ]; then
  go install golang.org/x/tools/gopls@latest
fi
if [ ! -f "$HOME/go/bin/gofumpt" ]; then
  go install mvdan.cc/gofumpt@latest
fi
if [ ! -f "$HOME/go/bin/revive" ]; then
  go install github.com/mgechev/revive@latest
fi

# Go tools are installed into $GOPATH/bin
function go_update {
  local golangcilatest=$(curl -s "https://github.com/golangci/golangci-lint/releases" | grep -o 'tag/v[0-9]\+\.[0-9]\+\.[0-9]\+' | head -n 1 | cut -d '/' -f 2)
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin "$golangcilatest"

  go install github.com/rakyll/gotest@latest
  go install github.com/mgechev/revive@latest
  go install golang.org/x/tools/gopls@latest
  go install mvdan.cc/gofumpt@latest
  go install honnef.co/go/tools/cmd/staticcheck@latest # https://github.com/dominikh/go-tools
  go install golang.org/x/vuln/cmd/govulncheck@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install go.uber.org/nilaway/cmd/nilaway@latest
  go install golang.org/x/tools/cmd/goimports@latest
  go install github.com/incu6us/goimports-reviser/v3@latest
  go install github.com/google/gops@latest
  go install github.com/securego/gosec/v2/cmd/gosec@latest

  # documentation preview
  # go get golang.org/x/tools/godoc@v0.1.8
  # go get golang.org/x/tools/godoc/redirect@v0.1.8
  # go install golang.org/x/tools/cmd/godoc
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
source "$HOME"/.cargo/env
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
function rust_update {
  brew_update # called because of rust-analyzer
  rustup self update
  rustup update stable
  rustup component add rustfmt
  rustup component add clippy
  cargo install cargo-audit --features=fix
  cargo install cargo-nextest
  cargo install cargo-edit
  rustup update
}

# zoxide is a directory switcher
#
# z <pattern>
# zoxide query -ls
#
eval "$(zoxide init zsh)"

################################################################################

# auto-run Go/Rust updates with a manual lock mechanism
#
mkdir -p "$HOME/.cache"
cache_file="$HOME/.cache/shell-update"
lock_file="$HOME/.cache/shell-update.lock"
current_day=$(date +%Y-%m-%d)

# function to release the lock
release_lock() {
  rm -f "$lock_file"
}

# function to check if another process is holding the lock
is_locked() {
  if [ -f "$lock_file" ]; then
    # check if the PID in the lock file is still running
    lock_pid=$(cat "$lock_file")

		# using /bin/ps as ps is aliased to procs binary
    if /bin/ps -p "$lock_pid" > /dev/null 2>&1; then
      return 0  # lock is still active
    else
      echo "stale lock detected, cleaning up."
      rm -f "$lock_file"
    fi
  fi
  return 1  # no lock
}

# check if the script is locked
if is_locked; then
	echo "another shell (PID $(cat "$lock_file")) is already running dependency updates so skip-ahead"
else
	echo "acquiring shell lock for PID $$ ($lock_file)"

	# write the current process's PID to the lock file
	echo $$ > "$lock_file"

	# ensure lock is released if the script exits or is interrupted
	trap release_lock EXIT

	# run the dependency update logic if no lock is present
	if [ -f "$cache_file" ]; then
		# get the last modification date of the cache file in YYYY-MM-DD format
		last_modified_day=$(date -r "$cache_file" +%Y-%m-%d)

		# if the cache file was last modified on a different day, run the command
		if [ "$current_day" != "$last_modified_day" ]; then
			echo "updating dependencies for homebrew, go and rust (last updated: $last_modified_day)"
			go_update
			rust_update
			touch "$cache_file" # update last_modified date
		fi
	else
		echo "updating dependencies for homebrew, go and rust (no previous cache file found)"
		go_update
		rust_update
		touch "$cache_file" # update last_modified date
	fi

	echo "releasing shell lock for PID $$ ($lock_file)"
	release_lock
fi

################################################################################

# Starship prompt
# https://starship.rs/
#
eval "$(starship init zsh)"

echo .zshrc loaded

# Configuration you don't want as part of your main .zshrc
#
if [ -f "$HOME/.localrc" ]; then
  source "$HOME/.localrc"
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Ensure terminal prompt is two lines under the actual Starship prompt.
# This is how the Warp terminal used to work and mimics its behaviour.
PROMPT="${PROMPT}"$'\n\n'

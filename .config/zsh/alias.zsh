#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Otherwise tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

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
alias fd='fd --hidden --no-ignore-vcs'

alias g="git"
alias ga="git add"
alias gb="git branch-verbose" # defined in ~/.gitconfig
alias gc="git checkout"
alias gd="git diff"
alias gdw="git diff-word" # defined in ~/.gitconfig
alias gup="git push"
alias gdown="git pull"
alias gr="git rebase"
alias grs="git restore"
alias gsh="git stash"
alias gsw="git switch"
alias gam="git add -u" # stage only modified files
alias gan='git add $(git ls-files -o --exclude-standard)' # stage only new files
alias gap="git add --patch"
alias gbi="git branch --list 'integralist*'"
alias gbd="git branch -D" # pass branch name to delete
alias gcm="git commit"
alias gca="git commit --amend"
alias gco="git checkout origin/main --" # followed by path to file to checkout
alias gcv="git commit -v"
alias gf="git pushit" # push with force lease - defined in ~/.gitconfig
alias ghosttydocs="ghostty +show-config --default --docs"
alias gl="git log-graphstat" # defined in ~/.gitconfig
alias glm="git log-me" # defined in ~/.gitconfig
alias gls="git log-short" # defined in ~/.gitconfig
alias godoc="stdsym | fzf | xargs go doc " -- https://github.com/lotusirous/gostdsym
alias gom="go run golang.org/x/tools/gopls/internal/analysis/modernize/cmd/modernize@latest -test -fix -diff ./... | delta"
alias goma="go run golang.org/x/tools/gopls/internal/analysis/modernize/cmd/modernize@latest -test -fix ./..."
alias golatest="curl -L https://github.com/golang/go/tags 2>&1 | rg '/golang/go/releases/tag/go[\w.]+' -o | cut -d '/' -f 6 | grep -v 'rc' | awk NR==1 | rg '\d.+' -o"
alias golatestall="curl -s 'https://go.dev/dl/?mode=json' | jq -c '.[]' | jq -c '.files[] | select(.os == \"darwin\" or .os == \"linux\" or .os == \"freebsd\") | select(.arch == \"386\" or .arch == \"amd64\" or .arch == \"armv6l\" or .arch == \"arm64\") | select(.kind == \"archive\")'"
alias gpr="git pull --rebase origin" # pass branch name
alias gst="git st" # defined in ~/.gitconfig
alias gstm="git stm" # display only modified files (exclude untracked) - defined in ~/.gitconfig
alias gt="git tag --sort=-creatordate | tac" # brew install tac (cat backwards)
alias gwip="git wip" # defined in ~/.gitconfig

# To view built-in command help documentation Zsh doesn't have a `help` command like Bash.
# So we have to install its equivalent: run-help.
unalias run-help 2>/dev/null
autoload run-help
HELPDIR=$(command brew --prefix)/share/zsh/help
alias help=run-help

alias history="history 0" # force history to show full history
alias ips="arp -a" # some IPs (like my NAS DS220) don't show up until I'm able to ping it (as that starts up the box).
alias json="python -m json.tool"

bold=$(tput bold)
normal=$(tput sgr0)
alias list='cat ~/.config/zsh/alias.zsh | grep "^alias" | gsed -En "s/alias (\w+)=(.+)/${bold}\1\n  ${normal}\2\n/p"'

alias ldd="otool -L" # display shared object files a binary is linked to
alias ls="eza -lh --icons --octal-permissions --no-user --git --group-directories-first --all" # REMOVED: `--ignore-glob '.git|node_modules'`
alias lsd="ls -s 'modified'"
alias mtr="sudo mtr --report-wide --show-ips --aslookup"
alias nv="novowels"
alias ping="gping"
alias ps="procs"
alias psw="pwgen -sy 20 1" # brew install pwgen
alias r="source ~/.zshrc" # reload zsh shell configuration
alias rr="exec zsh" # completely replace the zsh shell process
alias rg="rg --glob '!node_modules/' --glob '!.git/' --no-ignore --hidden"
alias ripall='rip * &> /dev/null ; rip .* &> /dev/null' # for redirection to work in Zsh we need to set `setopt +o nomatch`
alias sizeit="du -ahc" # can also add on a path at the end `sizeit ~/some/path`
alias sys='sw_vers && echo && system_profiler SPSoftwareDataType && curl -s https://en.wikipedia.org/wiki/MacOS_version_history | grep -Eo "Version $(version=$(sw_vers -productVersion) && echo ${version%.*}): \"[^\"]+\"" | uniq'
alias tf="terraform"
alias top='htop'
alias tree='tree -I node_modules'
alias uid="uuidgen" # this is a macOS binary (man uuidgen)
alias updates="softwareupdate --list" # --install --all (or) --install <product name>
alias v=/opt/homebrew/bin/nvim # brew stable version
alias vn=/usr/local/bin/nvim # nightly version manually compiled
alias vf='/opt/homebrew/bin/nvim $(fzf)'
alias vim=/opt/homebrew/bin/nvim # brew stable version
alias vi='vi -c "set nocompatible" -c "set number" -c "set cursorline" -c "set expandtab" -c "set hlsearch" -c "set visualbell" -c "set tabstop=2" -c "set shiftwidth=2" -c "syntax on"'
alias weather="curl wttr.in/southend-on-sea"
alias where='whence -va'

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

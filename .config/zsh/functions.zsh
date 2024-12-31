#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Also, other tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# brew_update updates Homebrew and checks for outdated packages
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

# dedupe ensures there are no duplicates in the $PATH
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

# chpwd overrides the cd command to call ls when changing directories as it's
# nice to see what's in each directory. We do this using a Zsh hook function.
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
function chpwd() {
    ls
    if [ -e .go-version ]; then
      "$GOPATH"/bin/g install $(cat .go-version)
    else
      "$GOPATH"/bin/g install $(golatest)
    fi

    # clean out any .DS_Store files
    #
    if [[ $PWD != $HOME ]]; then
			# find . -type f -name '.DS_Store' -delete
			fd '.DS_Store' --type f --hidden --absolute-path | xargs -I {} rm {}
    fi
}

# go_update updates/installs necessary Go tools.
#
# NOTE: Go tools are installed into $GOPATH/bin
#
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

# rust_update updates Homebrew and updates/installs necessary Rust tools.
#
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

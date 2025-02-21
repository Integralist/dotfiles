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

# digc is dig-clean meaning the output is just ANSWER and AUTHORITY.
# it also hides comment lines that start with ;
#
if ! command -v pcregrep &> /dev/null
then
  brew install pcre2
fi
function digc() {
  if [ -z "$1" ]; then
    echo "USAGE: digc <DOMAIN> [RECORD-TYPE: SOA|CNAME|NS|A|...]"
    return
  fi
	# NOTE: I don't use `+noall` as it hides lines like `;; ANSWER` and `;; AUTHORITY` which I want to keep
	dig "$1" $2 +answer +authority | pcregrep -v '^(;[^;]|;;(?! (ANSWER|AUTHORITY)))'

}

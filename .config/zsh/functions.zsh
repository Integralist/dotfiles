#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Otherwise tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# brew_update updates Homebrew and checks for outdated packages
function brew_update {
  brew update
  brew outdated
  brew upgrade
}

# dedupe ensures there are no duplicates in the $PATH
function dedupe {
  export PATH=$(echo -n "$PATH" | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
}

# remove "" warning from a binary
#
function force_run() {
  if [ -z "$1" ]; then
    echo "Provide path to a binary you want to run."
    return
  fi
  binpath=$1
	xattr -d com.apple.quarantine $binpath
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

# digg adds colors to the standard dig output to improve readability while not losing contextual information.
#
# DIG_COMMENT_COLOR_SINGLE="\e[48;5;8m\e[1;37m"  # Grey background, bold white text
# DIG_COMMENT_COLOR_SINGLE="\e[34m"  # Blue text, no background, no bold
DIG_COMMENT_COLOR_SINGLE="\e[38;5;8m"  # Dark grey text, no background, no bold
DIG_COMMENT_COLOR_DOUBLE="\e[48;5;88m\e[1;37m" # Dark red background, bold white text
DIG_RESET_COLOR="\e[0m"
digg() {
	local domain="$1"
	local record="${2:-A}"
	local dig_output=$(dig "$domain" "$record")
	local question_section_found=0

	while IFS= read -r line; do
		if [[ "$line" == ";"* ]]; then
			if [[ "$line" == ";;"* ]]; then
				if [[ "$line" == *' SECTION:'* ]]; then
					if [[ "$line" == *'QUESTION SECTION:'* ]]; then
						question_section_found=1;
						echo ""
					fi
					echo -e "${DIG_COMMENT_COLOR_DOUBLE}${line#';;'} ${DIG_RESET_COLOR}"
				else
					echo -e "${DIG_COMMENT_COLOR_SINGLE}${line#';;'} ${DIG_RESET_COLOR}"
				fi
			else
				if [[ "$question_section_found" -eq 1 ]]; then
					echo "${line#';'}";
					question_section_found=0;
				else
					echo -e "${DIG_COMMENT_COLOR_SINGLE}${line#';'}${DIG_RESET_COLOR}"
				fi
			fi
		else
			echo "$line";
		fi
	done <<< "$dig_output"
}

# check ssl connection to a website
#
function ssl_check() {
  if [ -z "$1" ]; then
    echo "USAGE: ssl_check <DOMAIN>"
    return
  fi
	openssl s_client -connect $1:443 | openssl x509 -noout -text
}

# use sips command to resize images
#
function imgr() {
  if [ -z "$1" ]; then
    echo "Please pass a width size in pixels"
    return
  fi
  if [ -z "$2" ]; then
    echo "Please pass an output path/filename"
    return
  fi
  if [ -z "$3" ]; then
    echo "Please pass an input path/filename"
    return
  fi
	sips --resampleWidth "$1" -o "$2" "$3"
}

# add a git note to a commit
#
function gnote {
  if [ -z "$1" ]; then
		echo "Please pass reference (e.g. docs)"
    return
  fi
  if [ -z "$2" ]; then
    echo "Please pass message"
    return
  fi
  if [ -z "$3" ]; then
    echo "Please pass commit"
    return
  fi
	git notes --ref=$1 add -m "$2" $3
}

# push all git notes
#
function gnoteup {
	for ref in $(git for-each-ref --format='%(refname)' refs/notes/); do
		git push origin "$ref"
	done
}

# curl with dump headers + json format
#
# EXAMPLES:
#
# GET request
# curl_json http://localhost:8080/api
#
# POST request with data
# curl_json --request POST --data '{"foo": "bar"}' http://localhost:8080/api
#
# PUT with data
# curl_json -X PUT --data '{"id":123,"status":"active"}' http://localhost:8080/update
#
function curl_json() {
  verb="GET"
  data_flag=""
  data_value=""
  url=""

  while [ $# -gt 0 ]; do
    case "$1" in
      -X|--request)
        verb="$2"
        shift 2
        ;;
      --data|--data-raw|--data-binary)
        data_flag="$1"
        data_value="$2"
        shift 2
        ;;
      *)
        url="$1"
        shift
        ;;
    esac
  done

  if [ -z "$url" ]; then
    echo "Usage: curl_json [--request VERB] [--data 'JSON'] URL"
    return 1
  fi

  if [ -n "$data_flag" ]; then
    curl -s -D - -X "$verb" "$data_flag" "$data_value" "$url"
  else
    curl -s -D - -X "$verb" "$url"
  fi | awk 'BEGIN {body=0} /^[[:space:]]*$/ {body=1; next} {if (body) print > "/dev/stderr"; else print}' \
    2> >(jq .)
}

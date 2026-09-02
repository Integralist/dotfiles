#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Otherwise tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# gochangelog opens the Go release notes for the active (or specified) Go version.
# For minor/point releases, it opens both the major release doc and the direct
# anchor on the release history page.
function gochangelog() {
  local version="${1:-$(go env GOVERSION 2>/dev/null)}"
  if [[ -z "$version" ]]; then
    echo "gochangelog: go not found or GOVERSION unavailable" >&2
    return 1
  fi
  [[ "$version" != go* ]] && version="go$version"

  local major=$(echo "$version" | cut -d. -f1,2)
  open "https://go.dev/doc/$major"

  local patch=$(echo "$version" | cut -s -d. -f3)
  if [[ -n "$patch" && "$patch" != "0" ]]; then
    open "https://go.dev/doc/devel/release#${version}"
  fi
}

# qt runs the full test suite, filters to just status lines, and highlights
# FAIL in red and PASS in green.
#
# The `|$` in the colorising greps matches the zero-width end-of-line on every
# line, so non-matching lines pass through untouched while FAIL/PASS get
# coloured. Without it, grep would filter out lines that don't contain the
# keyword.
function qt() {
  make test-all 2>&1 | tee /tmp/output | \
    grep -E '^(\s*--- (PASS|FAIL)|PASS|FAIL|ok\s+.*e2e)' | \
    sed -e $'s/FAIL/\033[01;31m&\033[0m/g' -e $'s/PASS/\033[01;32m&\033[0m/g'
}

# brew_update updates Homebrew and checks for outdated packages
function brew_update {
  echo "🚀 Running: brew update"
  brew update
  echo "🚀 Running: brew outdated"
  brew outdated
  echo "🚀 Running: brew upgrade"
  brew upgrade
}

# certdns displays the SAN (Subject Alternative Names) for a website's TLS
# certificate.
function certdns() {
  if [ -z "$1" ]; then
      echo "Usage: certdns <domain>" >&2
      return 1
  fi
  openssl s_client -connect "$1:443" </dev/null 2>/dev/null | \
      openssl x509 -noout -text | \
      grep "DNS:" | \
      sed 's/^[[:space:]]*//' | \
      tr ',' '\n' | \
      sed 's/^[[:space:]]*DNS://' | \
      sed 's/^[[:space:]]*//'
}

# update updates various software (e.g. Homebrew, Go packages etc).
# Rust function is defined in ./tools.zsh
# Go is done separately on cd (see `chpwd` in ./tools.zsh)
function update {
  echo "🔄 Running: brew_update"
  brew_update
  echo "🔄 Running: rust_update"
  rust_update
  echo "🔄 Running: go_tools"
	go_tools
  echo "🔄 Running: ai_update"
	ai_update
}

# ai_update updates various AI clients
function ai_update {
	echo "🚀 Running: pi update"
	pi update && echo "🚀 Running: pi update --extensions" && pi update --extensions
	echo "🚀 Running: claude update"
	claude update
	echo "🚀 Running: opencode upgrade"
	opencode upgrade
	echo "🚀 Running: agy update"
	agy update
	echo "🚀 Running: copilot update"
	copilot update
}

# dedupe ensures there are no duplicates in the $PATH
function dedupe {
  export PATH=$(echo -n "$PATH" | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
}

# fix gpg agent by restarting it
#
function gpgfix() {
	gpgconf --kill gpg-agent
	gpgconf --launch gpg-agent
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

# restore a file to either the main branch (default) or to an earlier commit
# version.
#
git_restore() {
  local file=$1
  local commit=$2

  if [[ -z "$file" ]]; then
    echo "Usage: git_restore <file> [commit]"
    return 1
  fi

  if [[ -z "$commit" ]]; then
    # restore file from current branch (e.g., main)
    git restore -- "$file"
  else
    # restore file from specific commit
    git restore --source="$commit" -- "$file"
  fi
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
	# The regex also filters out empty lines (^$)
	dig "$1" $2 +answer +authority | pcregrep -v '^(;[^;]|;;(?! (ANSWER|AUTHORITY))|^$)'
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

# Git Notes: metadata attached to commits without modifying the commit SHA.
# Unlike trailers (Signed-off-by, Co-authored-by) which live inside the commit
# message, notes are stored in separate refs (refs/notes/*) and can be
# added/edited/removed after the fact. Multiple namespaces are supported via
# --ref (e.g. refs/notes/docs, refs/notes/review).
#
# Requires fetch.notes=true and log.showNotes=true in ~/.gitconfig to
# automatically fetch and display notes. See also the `gn` alias in alias.zsh
# which adds a fetch refspec for pulling all remote note refs.
#
# Docs: https://git-scm.com/docs/git-notes
#
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
# Set HTTP header(s)
# curl_json -H "Foo: Bar" -H "Baz: Qux" http://localhost:8080/api
# curl_json -X POST --data '{"foo":"bar"}' -H "Content-Type: application/json" http://localhost:8080/api
#
function curl_json() {
  verb="GET"
  data_flag=""
  data_value=""
  url=""
  extra_args=()

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
      -H|--header)
        extra_args+=("$1" "$2")
        shift 2
        ;;
      *)
        if [[ "$1" =~ ^https?:// ]]; then
          url="$1"
          shift
        else
          # anything else not matching above gets passed to curl as-is
          extra_args+=("$1")
          shift
        fi
        ;;
    esac
  done

  if [ -z "$url" ]; then
    echo "Usage: curl_json [--request VERB] [--data 'JSON'] [-H 'Header: Value'] URL"
    return 1
  fi

  if [ -n "$data_flag" ]; then
    curl -s -D - -X "$verb" "$data_flag" "$data_value" "${extra_args[@]}" "$url"
  else
    curl -s -D - -X "$verb" "${extra_args[@]}" "$url"
  fi | awk 'BEGIN {body=0} /^[[:space:]]*$/ {body=1; next} {if (body) print > "/dev/stderr"; else print}' \
    2> >(jq .)
}

# psw generates a password using pwgen.
# Pass NO_SYM=true to omit symbols (drops the -y flag).
#
# brew install pwgen
#
function psw() {
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    cat <<-EOF
	Usage: psw [LENGTH]

	Generate a secure password using pwgen.

	Arguments:
	  LENGTH         password length (default: 20)

	Environment overrides:
	  NO_SYM=true    omit symbols (drops the -y flag)

	Examples:
	  psw
	  psw 32
	  NO_SYM=true psw 32
	EOF
    return
  fi
  local length="${1:-20}"
  if [[ "$NO_SYM" == "true" ]]; then
    pwgen -s "$length" 1
  else
    pwgen -sy "$length" 1
  fi
}

# claude_cost reads the Claude Session Costs log file to sum up the costs for
# today. you can specify a date if you want to check a day other than today.
# e.g. claude_cost 2026-02-22
# or you can calculate multiple days:
# e.g. claude_cost -5
#
# REQUIRES:
# ~/.claude/scripts/log-session-cost.sh to generate the costs log.
# That script is invoked via Claude Code's "SessionEnd" hook.
#
claude_cost() {
    local log_file="$HOME/.claude/session-costs.log"

    if [[ ! -f "$log_file" ]]; then
        echo "Log file not found."
        return 1
    fi

    if [[ "$1" =~ ^-[0-9]+$ ]]; then
        local days=${1#-}
        local dates=()
        for (( i=0; i<days; i++ )); do
            dates+=("$(date -v-${i}d +%F)")
        done
        local pattern="${(j:|:)dates}"

        awk -v date="$pattern" -v days="$days" '
        $0 ~ "^("date")" {
            found = 1
            for (i=1; i<=NF; i++) {
                if ($i ~ /^total_cost=/) {
                    split($i, parts, "=")
                    val = substr(parts[2], 2)
                    sum += val
                }
            }
        }
        END {
            if (found) {
                printf "Total for last %d days: $%.4f\n", days, sum
            } else {
                printf "No entries found for last %d days.\n", days
            }
        }
        ' "$log_file"
    else
        local target_date="${1:-$(date +%F)}"

        awk -v date="$target_date" '
        $0 ~ "^"date {
            found = 1
            for (i=1; i<=NF; i++) {
                if ($i ~ /^total_cost=/) {
                    split($i, parts, "=")
                    val = substr(parts[2], 2)
                    sum += val
                }
            }
        }
        END {
            if (found) {
                printf "Total for %s: $%.4f\n", date, sum
            } else {
                printf "No entries found for %s.\n", date
            }
        }
        ' "$log_file"
    fi
}

# aicosts calculates all AI CLI harness usage for the last N days
# Default: 0 (the current day)
# npm install -g ccusage
# https://github.com/ryoppippi/ccusage
#
aicosts() {
	local days=${1:-0}
	local since_date=$(date -v-"${days}"d +%Y-%m-%d)
	ccusage daily --since "$since_date"
}

# repos_update fast-forwards the default branch (main/master) of every git repo
# under a directory (default: ~/code/fastly) without disturbing work in
# progress.
#
# Each repo costs exactly one network round trip, and that round trip only ever
# writes remote-tracking refs:
#
#   git fetch origin +refs/heads/*:refs/remotes/origin/*
#
# refs/remotes/origin/* mirror origin and are always safe to force, so this is
# performed in dry-run mode too. Everything after it is local: the repo is
# classified from those refs, and only then, and only in a live run, is the
# local branch moved with
#
#   git fetch . refs/remotes/origin/<branch>:<branch>
#
# which writes the fetched commits straight into refs/heads/<branch> and never
# reads or writes the working tree, the index or HEAD. Without a leading `+`
# that refspec is fast-forward only, so a diverged local branch is rejected
# rather than clobbered. That is also why there is no stash/pop here: nothing
# in the working tree is ever at risk, and stash/pop is the step that would
# actually put it at risk. It never runs checkout, stash, reset or pull.
#
# Git refuses that refspec when <branch> is checked out here or in a linked
# worktree. Being checked out here falls back to `git merge --ff-only`, and
# only when the working tree is clean; a linked worktree is skipped. Anything
# else is skipped with a printed reason.
#
# Classifying before mutating is what makes --dry-run trustworthy: both modes
# run the same checks in the same order and diverge only at the final update,
# so a preview cannot promise something a live run then refuses.
#
# Usage: repos_update [-n|--dry-run] [directory]
function repos_update {
	# Flags are accepted in any position. A misplaced flag must never be treated
	# as a path or silently dropped: doing so would turn a requested preview
	# into a live run.
	local dry_run=0 root= arg
	for arg in "$@"; do
		case $arg in
			-n|--dry-run) dry_run=1 ;;
			-*)
				echo "repos_update: unknown option: $arg" >&2
				echo "usage: repos_update [-n|--dry-run] [directory]" >&2
				return 2 ;;
			*)
				if [[ -n $root ]]; then
					echo "repos_update: unexpected argument: $arg" >&2
					return 2
				fi
				root=$arg ;;
		esac
	done

	root=${root:-$HOME/code/fastly}
	if [[ ! -d $root ]]; then
		echo "repos_update: not a directory: $root" >&2
		return 1
	fi

	# Across 80+ repos a single credential prompt would stall the whole run, and
	# an unresponsive host would stall it just as effectively, so both fail fast
	# rather than block. The ssh options bound the ssh transport; the
	# http.lowSpeed* pair does the same for https by aborting a transfer that
	# sits under 1KB/s for 20s. Neither transport is left able to hang forever.
	local ssh_cmd="${GIT_SSH_COMMAND:-ssh}"
	local -x GIT_TERMINAL_PROMPT=0
	local -x GIT_SSH_COMMAND="$ssh_cmd -o BatchMode=yes -o ConnectTimeout=10 -o ServerAliveInterval=10 -o ServerAliveCountMax=3"
	local -a timeout_opts=(-c http.lowSpeedLimit=1000 -c http.lowSpeedTime=20)

	# Escapes only when stdout is a terminal, so piping to a file or a pager
	# yields plain text rather than literal control codes.
	local green= yellow= red= dim= off=
	if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
		green=$'\033[32m' yellow=$'\033[33m' red=$'\033[31m' dim=$'\033[2m' off=$'\033[0m'
	fi

	local -i updated=0 uptodate=0 skipped=0 failed=0
	local dir name git_dir top branch cur_branch before remote_sha after err msg counts b
	local -i ahead behind
	local -a g

	# Pointing at a repo root should act on that one repo, not on its
	# subdirectories.
	local -a repos
	top=$(git -C $root rev-parse --show-toplevel 2>/dev/null)
	if [[ -n $top && ${top:A} == ${root:A} ]]; then
		repos=($root)
	else
		repos=($root/*(N-/))
	fi

	for dir in $repos; do
		name=${dir:t}

		# rev-parse discovers the *enclosing* repo, so without this check any
		# plain subdirectory of a repo masquerades as a repo of its own and the
		# same repo gets processed once per subdirectory.
		top=$(git -C $dir rev-parse --show-toplevel 2>/dev/null) || continue
		[[ -n $top && ${top:A} == ${dir:A} ]] || continue
		git_dir=$(git -C $dir rev-parse --absolute-git-dir 2>/dev/null) || continue
		printf '%-34s ' $name

		# Pin git to this repo once instead of repeating -C on every call.
		g=(git $timeout_opts -C $dir)

		if ! $g remote get-url origin >/dev/null 2>&1; then
			printf '%s\n' "${dim}skip: no origin remote${off}"; (( skipped++ )); continue
		fi

		# A rebase/merge/cherry-pick/bisect leaves HEAD detached, which would let
		# the update move a branch the operation is still replaying onto.
		if [[ -e $git_dir/rebase-merge || -e $git_dir/rebase-apply || -e $git_dir/MERGE_HEAD || -e $git_dir/CHERRY_PICK_HEAD || -e $git_dir/BISECT_LOG ]]; then
			printf '%s\n' "${yellow}skip: git operation in progress${off}"; (( skipped++ )); continue
		fi

		# Resolve the default branch from the cached origin/HEAD; set-head only
		# rewrites a remote-tracking ref, so it is safe to repair on the fly.
		branch=$($g symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
		if [[ -z $branch ]]; then
			$g remote set-head origin --auto >/dev/null 2>&1
			branch=$($g symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
		fi
		branch=${branch#origin/}
		if [[ -z $branch ]]; then
			for b in main master; do
				$g show-ref --verify --quiet refs/remotes/origin/$b && { branch=$b; break }
			done
		fi
		if [[ -z $branch ]]; then
			printf '%s\n' "${yellow}skip: cannot determine default branch${off}"; (( skipped++ )); continue
		fi

		# The one network operation, and the only one. It writes nothing but
		# remote-tracking refs, so a dry run performs it too and both modes go on
		# to classify from byte-identical data.
		if ! err=$($g fetch --quiet origin "+refs/heads/*:refs/remotes/origin/*" 2>&1 >/dev/null); then
			msg=$(printf '%s\n' $err | grep -m1 -E '^(fatal|error):')
			printf '%s\n' "${red}fetch failed: ${msg:-${err##*$'\n'}}${off}"; (( failed++ )); continue
		fi

		before=$($g rev-parse --quiet --verify refs/heads/$branch 2>/dev/null)
		remote_sha=$($g rev-parse --quiet --verify refs/remotes/origin/$branch 2>/dev/null)
		if [[ -z $remote_sha ]]; then
			printf '%s\n' "${yellow}skip: origin/$branch missing after fetch${off}"; (( skipped++ )); continue
		fi

		# Nothing to do beats every other outcome: a repo that is already current
		# is reported as such even if its tree is dirty, because no update is
		# being withheld.
		ahead=0 behind=0
		if [[ -n $before ]]; then
			# left = commits only we have, right = commits only origin has.
			counts=$($g rev-list --left-right --count refs/heads/$branch...refs/remotes/origin/$branch 2>/dev/null)
			ahead=${counts%%[[:space:]]*}
			behind=${counts##*[[:space:]]}
			if (( ahead > 0 )); then
				printf '%s\n' "${yellow}skip: $branch diverged (ahead $ahead, behind $behind)${off}"; (( skipped++ )); continue
			fi
			if (( behind == 0 )); then
				printf '%s\n' "${dim}up to date${off}"; (( uptodate++ )); continue
			fi
		fi

		# An update is due. Rule out the cases where it cannot be applied before
		# attempting it, so that a dry run reaches the same verdict a live run
		# would rather than inferring it from a failure message afterwards.
		cur_branch=$($g symbolic-ref --quiet --short HEAD 2>/dev/null)
		if [[ $cur_branch == $branch ]]; then
			# $branch is checked out here, so the branch update is refused by
			# design and this falls back to a merge. Untracked files are not
			# checked because merge aborts itself rather than overwrite them.
			if [[ -n $($g status --porcelain --untracked-files=no 2>/dev/null) ]]; then
				printf '%s\n' "${yellow}skip: $branch checked out with uncommitted changes${off}"; (( skipped++ )); continue
			fi
		elif $g worktree list --porcelain 2>/dev/null | grep -qxF "branch refs/heads/$branch"; then
			printf '%s\n' "${yellow}skip: $branch checked out in another worktree${off}"; (( skipped++ )); continue
		fi

		if (( dry_run )); then
			if [[ -z $before ]]; then
				printf '%s\n' "${green}would create $branch${off}"
			else
				printf '%s\n' "${green}would fast-forward $branch by $behind${off}"
			fi
			(( updated++ )); continue
		fi

		if [[ $cur_branch == $branch ]]; then
			if ! err=$($g merge --ff-only --quiet origin/$branch 2>&1 >/dev/null); then
				printf '%s\n' "${yellow}skip: $branch not fast-forwardable${off}"; (( skipped++ )); continue
			fi
		elif ! err=$($g fetch . "refs/remotes/origin/$branch:$branch" 2>&1 >/dev/null); then
			# Purely local, and every expected refusal was ruled out above, so a
			# failure here is genuinely unexpected rather than a known skip.
			msg=$(printf '%s\n' $err | grep -m1 -E '^(fatal|error):')
			printf '%s\n' "${red}update failed: ${msg:-${err##*$'\n'}}${off}"; (( failed++ )); continue
		fi

		after=$($g rev-parse --quiet --verify refs/heads/$branch 2>/dev/null)
		if [[ -z $before ]]; then
			printf '%s\n' "${green}created $branch @ ${after:0:7}${off}"
		else
			printf '%s\n' "${green}$branch ${before:0:7} → ${after:0:7} (+$behind)${off}"
		fi
		(( updated++ ))
	done

	printf '\n%d updated, %d up to date, %d skipped, %d failed\n' $updated $uptodate $skipped $failed
	(( failed == 0 ))
}

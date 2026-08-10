#!/usr/bin/env zsh
#
# Behaviour tests for repos_update (.config/zsh/functions.zsh).
#
# Builds a throwaway tree of git repos -- one per branch of the function's
# logic, with bare repos standing in for origins so nothing touches the network
# -- runs repos_update over it, and compares the normalised output against the
# golden transcript at the bottom of this file.
#
# Run with `make test`. On failure a unified diff is printed: left is expected,
# right is what the function actually did.
emulate -L zsh
# Strict while building fixtures: a silently broken fixture would make the
# assertions meaningless.
setopt err_exit no_unset pipe_fail

SRC=${1:-${0:A:h}/../.config/zsh/functions.zsh}
WS=${TMPDIR:-/tmp}/repos_update_test.$$
trap 'rm -rf $WS' EXIT

# Sourcing functions.zsh outright has side effects (it will try to brew install
# pcre2), so lift out just the function under test.
FN=$WS.fn.zsh
mkdir -p $WS
awk '/^function repos_update \{/,/^\}$/' $SRC > $FN
[[ -s $FN ]] || { print -u2 "FAIL: could not extract repos_update from $SRC"; exit 1 }
source $FN

# Keep every git invocation below hermetic: no user config, no signing, no
# reliance on whatever init.defaultBranch happens to be set to.
export GIT_CONFIG_GLOBAL=$WS/gitconfig GIT_CONFIG_SYSTEM=/dev/null
git config --global user.email test@example.com
git config --global user.name  Test
git config --global init.defaultBranch main
git config --global commit.gpgsign false
git config --global advice.detachedHead false

mkdir -p $WS/root $WS/origins $WS/wt

# origin <name> [branch] -- a bare origin holding one commit on <branch>.
origin() {
	local n=$1 br=${2:-main} seed=$WS/seed-$1
	git init -q -b $br $seed
	print one > $seed/f; git -C $seed add -A; git -C $seed commit -qm one
	git init -q --bare $WS/origins/$n.git
	git -C $seed symbolic-ref HEAD refs/heads/$br
	git -C $WS/origins/$n.git symbolic-ref HEAD refs/heads/$br
	git -C $seed remote add origin $WS/origins/$n.git
	git -C $seed push -q origin $br
}
# advance <name> [branch] -- move the origin one commit ahead of its clones.
advance() {
	local n=$1 br=${2:-main} seed=$WS/seed-$1
	print two >> $seed/f; git -C $seed commit -qam two
	git -C $seed push -q origin $br
}

# 1. behind, default branch not checked out -> fast-forwarded via refs only
origin behind;  git clone -q $WS/origins/behind.git  $WS/root/behind
git -C $WS/root/behind checkout -q -b feature
advance behind

# 2. already current -> untouched
origin current; git clone -q $WS/origins/current.git $WS/root/current
git -C $WS/root/current checkout -q -b feature

# 3. default branch checked out, tree clean, behind -> merge --ff-only
origin onmain;  git clone -q $WS/origins/onmain.git  $WS/root/onmain
advance onmain

# 4. default branch checked out, tree dirty, behind -> skipped, tree preserved
origin dirty;   git clone -q $WS/origins/dirty.git   $WS/root/dirty
advance dirty
print scratch >> $WS/root/dirty/f

# 5. default branch checked out and dirty but already current -> nothing is
#    being withheld, so this reports up to date rather than a skip
origin dirtycurrent; git clone -q $WS/origins/dirtycurrent.git $WS/root/dirtycurrent
print scratch >> $WS/root/dirtycurrent/f

# 6. local default branch has commits origin lacks -> never force-updated
origin diverged; git clone -q $WS/origins/diverged.git $WS/root/diverged
print local > $WS/root/diverged/g
git -C $WS/root/diverged add -A; git -C $WS/root/diverged commit -qm local
git -C $WS/root/diverged checkout -q -b feature
advance diverged

# 7. no origin remote -> skipped
git init -q $WS/root/noremote
print x > $WS/root/noremote/f
git -C $WS/root/noremote add -A; git -C $WS/root/noremote commit -qm x

# 8. rebase in progress -> skipped, replay left alone
origin rebasing; git clone -q $WS/origins/rebasing.git $WS/root/rebasing
git -C $WS/root/rebasing checkout -q -b side
print side > $WS/root/rebasing/f; git -C $WS/root/rebasing commit -qam side
git -C $WS/root/rebasing checkout -q main
print trunk > $WS/root/rebasing/f; git -C $WS/root/rebasing commit -qam trunk
git -C $WS/root/rebasing checkout -q side
git -C $WS/root/rebasing rebase main >/dev/null 2>&1 || true

# 9. default branch checked out in a linked worktree -> skipped
origin worktree; git clone -q $WS/origins/worktree.git $WS/root/worktree
git -C $WS/root/worktree checkout -q -b feature
git -C $WS/root/worktree worktree add -q $WS/wt/worktree main
advance worktree

# 10. default branch is master, not main
origin legacy master; git clone -q $WS/origins/legacy.git $WS/root/legacy
git -C $WS/root/legacy checkout -q -b feature
advance legacy master

# 11. local default branch absent -> created
origin missing; git clone -q $WS/origins/missing.git $WS/root/missing
git -C $WS/root/missing checkout -q -b feature
git -C $WS/root/missing branch -q -D main

# 12. a plain directory that is not a repo -> ignored silently
mkdir -p $WS/root/notarepo/sub

# 13. unreachable origin -> reported as failed, run continues
origin broken; git clone -q $WS/origins/broken.git $WS/root/broken
git -C $WS/root/broken checkout -q -b feature
git -C $WS/root/broken remote set-url origin $WS/origins/does-not-exist.git

# Strip colour, abbreviate SHAs, collapse the name padding and hide the
# workspace path so the transcript is stable across runs and machines.
# Order matters: the workspace path is erased before SHAs are, because the
# path itself contains hex runs long enough to look like one. $'...' is
# required for the tab -- BSD sed reads a literal \t in a bracket expression
# as the letter t and would eat every t in the output.
norm() {
	sed -E $'s/\033\\[[0-9;]*m//g' | sed -E "s#$WS#WS#g" |
		sed -E $'s/[0-9a-f]{7,40}/SHA/g; s/[ \t]+/ /g; s/ $//'
}

actual() {
	local out rc
	out=$(repos_update "$@" 2>&1); rc=$?
	{ print -r -- "=== repos_update $*"; print -r -- $out } | norm
	print -r -- "--- exit=$rc"
}

# repos_update deliberately runs commands that fail (rev-parse on a
# non-repo, fetch against a dead remote) and handles the failure itself, so
# the strict options have to come off before it is exercised.
unsetopt err_exit no_unset pipe_fail

# The golden transcript records what the function *says*. This records what it
# *does*: every local branch tip, plus the contents of the two working trees
# that carry uncommitted work. A preview that moved either would be a serious
# bug that matching output alone would not catch.
snapshot() {
	local r
	for r in $WS/root/*(N-/); do
		git -C $r show-ref --heads 2>/dev/null | sed "s#^#${r:t} #"
	done
	shasum $WS/root/dirty/f $WS/root/dirtycurrent/f 2>/dev/null | sed "s#$WS#WS#g"
}

before_dry=$(snapshot)
repos_update --dry-run $WS/root >/dev/null 2>&1
if [[ $(snapshot) != $before_dry ]]; then
	print -u2 "FAIL  --dry-run modified local state (left=before, right=after)"
	diff -u =(print -r -- $before_dry) =(snapshot) >&2
	exit 1
fi
print "PASS  --dry-run leaves local branches and working trees untouched"

# Recorded here, checked after the transcript below has performed its live
# runs: a live run may move branches, but must never touch a tree holding
# uncommitted work.
before_trees=$(shasum $WS/root/dirty/f $WS/root/dirtycurrent/f 2>/dev/null)

got=$(
	print -r -- "########## DRY RUN leaves every repo untouched"
	actual --dry-run $WS/root
	print -r -- "########## LIVE"
	actual $WS/root
	print -r -- "########## LIVE is idempotent"
	actual $WS/root
	print -r -- "########## a repo root acts on itself, not its subdirectories"
	actual $WS/root/onmain
	print -r -- "########## argument handling"
	actual --bogus $WS/root
	actual $WS/root extra-arg
	actual $WS/nope
)

if [[ $(shasum $WS/root/dirty/f $WS/root/dirtycurrent/f 2>/dev/null) != $before_trees ]]; then
	print -u2 "FAIL  a live run modified a dirty working tree"
	exit 1
fi
print "PASS  a live run leaves dirty working trees untouched"

want=${0:A:h}/repos_update.expected
# Bootstrap or deliberately re-record the transcript. Regenerating is a
# behaviour change by definition, so the diff wants reading before it lands.
if [[ ${UPDATE_GOLDEN:-0} == 1 || ! -f $want ]]; then
	print -r -- $got > $want
	print "WROTE $want -- review the diff before committing it"
	exit 0
fi
if diff -u $want =(print -r -- $got); then
	print "PASS  repos_update"
else
	print -u2 "FAIL  repos_update (left=expected, right=actual)"
	exit 1
fi

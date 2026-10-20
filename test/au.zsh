#!/usr/bin/env zsh
# Behaviour tests for au (.config/zsh/functions.zsh).
emulate -L zsh
setopt err_exit no_unset pipe_fail

SRC=${1:-${0:A:h}/../.config/zsh/functions.zsh}
WS=${TMPDIR:-/tmp}/au_test.$$
trap 'rm -rf "$WS"' EXIT
mkdir -p "$WS"
FN=$WS/au.fn.zsh
awk '/^au\(\) \{/,/^}/' "$SRC" > "$FN"
[[ -s $FN ]] || { print -u2 "FAIL: could not extract au from $SRC"; exit 1 }
source "$FN"

AU_LOG=$WS/calls
: > "$AU_LOG"
date() {
	case "$1" in
		+%F) print -r -- 2026-10-20 ;;
		+%Y-%m-01) print -r -- 2026-10-01 ;;
		*) return 1 ;;
	esac
}
ccusage() {
	print -r -- "$*" >> "$AU_LOG"
	if [[ ${AU_FAIL:-} == all && "$*" != *claude* && "$*" != *copilot* ]]; then
		return 1
	fi
	if [[ ( ${AU_FAIL:-} == claude || ${AU_FAIL:-} == enterprise-claude ) && "$*" == *claude\ daily* ]]; then
		return 1
	fi
	if [[ ( ${AU_FAIL:-} == copilot || ${AU_FAIL:-} == copilot-pi ) && "$*" == *copilot\ daily* ]]; then
		return 1
	fi
	if [[ "$*" == *claude\ daily* ]]; then
		print -r -- '{"daily":[{"period":"2026-10-20","totalCost":2}],"totals":{"totalCost":2}}'
	elif [[ "$*" == *copilot\ daily* ]]; then
		print -r -- '{"daily":[{"date":"2026-10-20","totalCost":1.25}],"totals":{"totalCost":1.25}}'
	else
		print -r -- '{"daily":[{"period":"2026-10-01","totalCost":10},{"period":"2026-10-20","totalCost":5.25}],"totals":{"totalCost":15.25}}'
	fi
}
claude-usage() {
	[[ ${AU_FAIL:-} != enterprise && ${AU_FAIL:-} != enterprise-claude ]] || return 1
	print -r -- '$3.50 of $10.00 spent'
}
node() {
	[[ ${AU_FAIL:-} != pi && ${AU_FAIL:-} != copilot-pi ]] || return 1
	print -r -- 2.10847918
}

output=$(au)
first_line=${output%%$'\n'*}
[[ $first_line == 'Total AI costs to date: $16.75' ]] || {
	print -u2 "FAIL: unexpected first line: $first_line"
	exit 1
}
[[ $output == *' GitHub Copilot'* && $output == *'󰚩 Claude Code (Enterprise)'* && $output == *'π Copilot via Pi'* && $output == *'∑ Other AI'* && $output == *' One-day usage total'* ]] || {
	print -u2 'FAIL: missing Nerd Font and Pi icons'
	exit 1
}
[[ $output == *$'Total AI costs to date: $16.75\n\n GitHub Copilot'* && $output == *$'Copilot via Pi: $2.11\n\n󰚩 Claude Code'* && $output == *$'Claude Code (Enterprise): $3.50 of $10.00 spent\n\n∑ Other AI'* && $output == *$'∑ Other AI (ccusage remainder): $9.89\n\n One-day'* ]] || {
	print -u2 'FAIL: cost sections need breathing room'
	exit 1
}
[[ $output == *'GitHub Copilot month-to-date: $3.36'* ]] || {
	print -u2 'FAIL: missing combined Copilot month-to-date cost'
	exit 1
}
[[ $output == *'Copilot CLI: $1.25'* && $output == *'Copilot via Pi: $2.11'* ]] || {
	print -u2 'FAIL: missing Copilot source breakdown'
	exit 1
}
[[ $output == *'Claude Code (Enterprise): $3.50 of $10.00 spent'* ]] || {
	print -u2 'FAIL: missing Claude Enterprise usage'
	exit 1
}
[[ $output == *'One-day usage total (2026-10-20, included in MTD): $5.25'* ]] || {
	print -u2 'FAIL: missing one-day total'
	exit 1
}
[[ $(wc -l < "$AU_LOG" | tr -d ' ') == 3 ]] || {
	print -u2 'FAIL: expected one invocation per ccusage report'
	exit 1
}
print 'PASS  au calculates all four sections from month-to-date reports'

assert_unavailable() {
	local failure=$1 expected=$2 output rc
	AU_FAIL=$failure
	unsetopt err_exit
	output=$(au 2>&1); rc=$?
	setopt err_exit
	[[ $rc != 0 && $output == *"$expected"* ]] || {
		print -u2 "FAIL: $failure failure did not report $expected"
		exit 1
	}
	print "PASS  au handles $failure report failure"
}
assert_unavailable all 'Total AI costs to date: unavailable'
assert_unavailable claude 'Total AI costs to date: unavailable'

assert_copilot_partial() {
	local failure=$1 expected=$2 output rc
	AU_FAIL=$failure
	unsetopt err_exit
	output=$(au 2>&1); rc=$?
	setopt err_exit
	[[ $rc != 0 && $output == *"$expected"* ]] || {
		print -u2 "FAIL: $failure did not report $expected"
		exit 1
	}
	print "PASS  au reports partial Copilot usage when $failure fails"
}
assert_copilot_partial copilot 'GitHub Copilot month-to-date: $2.11 (Pi only)'
assert_copilot_partial pi 'GitHub Copilot month-to-date: $1.25 (CLI only)'
assert_unavailable copilot-pi 'GitHub Copilot month-to-date: unavailable'

AU_FAIL=enterprise
unsetopt err_exit
output=$(au 2>&1); rc=$?
setopt err_exit
first_line=${output%%$'\n'*}
[[ $rc == 0 && $first_line == 'Total AI costs to date: $15.25' ]] || {
	print -u2 'FAIL: Enterprise failure should fall back to the all-agent ccusage total'
	exit 1
}
[[ $output == *'⚠️ Claude Enterprise costs unavailable; total includes ccusage Claude costs instead.'* ]] || {
	print -u2 'FAIL: missing Claude Enterprise fallback warning'
	exit 1
}
[[ $output == *'Claude Code (Enterprise): unavailable; ccusage Claude fallback: $2.00'* && $output == *'∑ Other AI (ccusage remainder): $9.89'* ]] || {
	print -u2 'FAIL: missing Claude fallback or Other AI residual'
	exit 1
}
print 'PASS  au falls back to ccusage Claude costs when Enterprise usage fails'

AU_FAIL=enterprise-claude
unsetopt err_exit
output=$(au 2>&1); rc=$?
setopt err_exit
first_line=${output%%$'\n'*}
[[ $rc == 0 && $first_line == 'Total AI costs to date: $15.25' ]] || {
	print -u2 'FAIL: aggregate fallback should work without the Claude-only report'
	exit 1
}
[[ $output == *'Claude costs remain included in ccusage total'* && $output == *'∑ Other AI (includes unseparated Claude): $11.89'* ]] || {
	print -u2 'FAIL: missing aggregate-only Claude fallback breakdown'
	exit 1
}
print 'PASS  au falls back to all-agent totals if Claude details also fail'

# Exercise interactive job control and spinner redraws in a pseudo-terminal.
TTY_SCRIPT=$WS/terminal.zsh
TTY_LOG=$WS/terminal.log
print -r -- "source ${(q)FN}" > "$TTY_SCRIPT"
cat >> "$TTY_SCRIPT" <<'EOF'
date() {
	case "$1" in
		+%F) print -r -- 2026-10-20 ;;
		+%Y-%m-01) print -r -- 2026-10-01 ;;
	esac
}
ccusage() {
	if [[ "$*" == *claude\ daily* ]]; then
		sleep "${AU_CLAUDE_DELAY:-0.85}"
	elif [[ "$*" == *copilot\ daily* ]]; then
		sleep "${AU_COPILOT_DELAY:-1.35}"
	else
		sleep "${AU_ALL_DELAY:-0.35}"
	fi
	if [[ "$*" == *claude\ daily* ]]; then
		print -r -- '{"daily":[],"totals":{"totalCost":2}}'
	elif [[ "$*" == *copilot\ daily* ]]; then
		print -r -- '{"daily":[],"totals":{"totalCost":1.25}}'
	else
		print -r -- '{"daily":[{"period":"2026-10-20","totalCost":5.25}],"totals":{"totalCost":15.25}}'
	fi
}
claude-usage() {
	sleep "${AU_ENTERPRISE_DELAY:-2.35}"
	print -r -- '$3.50 of $10.00 spent'
}
node() {
	sleep "${AU_PI_DELAY:-1.85}"
	print -r -- 2.10847918
}
au
EOF
env -u NO_COLOR AU_ALL_DELAY=0.35 AU_CLAUDE_DELAY=0.85 AU_COPILOT_DELAY=1.35 AU_PI_DELAY=1.85 AU_ENTERPRISE_DELAY=2.35 script -q "$TTY_LOG" zsh -f -i -c "source ${(q)TTY_SCRIPT}" >/dev/null 2>&1 || {
	print -u2 'FAIL: interactive au test failed to run'
	exit 1
}
if grep -Eq '\[[0-9]+\] [0-9]+' "$TTY_LOG"; then
	print -u2 'FAIL: interactive au leaked background job PIDs'
	exit 1
fi
if grep -Fq $'\e[4A' "$TTY_LOG" || ! grep -Fq $'\r\e[K' "$TTY_LOG"; then
	print -u2 'FAIL: spinner should redraw one line with carriage return'
	exit 1
fi
grep -Fq 'Calculating costs...' "$TTY_LOG" || {
	print -u2 'FAIL: missing generic calculation status'
	exit 1
}
for percent in 0 20 40 60 80 100; do
	grep -Fq "Calculating costs... $percent%" "$TTY_LOG" || {
		print -u2 "FAIL: progress did not reach $percent percent"
		exit 1
	}
done
zero_frames=$(tr '\r' '\n' < "$TTY_LOG" | grep -cF 'Calculating costs... 0%' || true)
(( zero_frames >= 4 )) || {
	print -u2 'FAIL: spinner frame should update faster than progress polling'
	exit 1
}
grep -Eq $'\\e\\[[0-9;]*m' "$TTY_LOG" || {
	print -u2 'FAIL: interactive output should use color'
	exit 1
}
NO_COLOR=1 AU_ALL_DELAY=0.05 AU_CLAUDE_DELAY=0.05 AU_COPILOT_DELAY=0.05 AU_PI_DELAY=0.05 AU_ENTERPRISE_DELAY=0.05 script -q "$WS/no-color.log" zsh -f -i -c "source ${(q)TTY_SCRIPT}" >/dev/null 2>&1 || {
	print -u2 'FAIL: NO_COLOR au test failed to run'
	exit 1
}
grep -Eq $'\\e\\[[0-9;]*m' "$WS/no-color.log" && {
	print -u2 'FAIL: NO_COLOR should disable output colors'
	exit 1
}
print 'PASS  au keeps the interactive spinner readable and styles output safely'

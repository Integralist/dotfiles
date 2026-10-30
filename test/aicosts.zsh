#!/usr/bin/env zsh
# Behaviour tests for aicosts (.config/zsh/functions.zsh).
emulate -L zsh
setopt err_exit no_unset pipe_fail

SRC=${1:-${0:A:h}/../.config/zsh/functions.zsh}
WS=${TMPDIR:-/tmp}/aicosts_test.$$
trap 'rm -rf "$WS"' EXIT
mkdir -p "$WS"
FN=$WS/aicosts.fn.zsh
awk '/^aicosts\(\) \{/,/^}/' "$SRC" > "$FN"
[[ -s $FN ]] || { print -u2 "FAIL: could not extract aicosts from $SRC"; exit 1 }
source "$FN"

CALLS=$WS/calls
: > "$CALLS"
date() {
	if [[ $1 == +%Y-%m-%d && $# == 1 ]]; then
		print -r -- 2026-10-30
	elif [[ $1 == -v-1d && $2 == +%Y-%m-%d ]]; then
		print -r -- 2026-10-29
	else
		return 1
	fi
}
ccusage() {
	print -r -- "$*" >> "$CALLS"
	if [[ "$*" == *--json* ]]; then
		[[ ${AICOSTS_FAIL_JSON:-0} != 1 ]] || return 1
		print -r -- '{"daily":[{"period":"2026-10-29","modelBreakdowns":[{"modelName":"[pi] gemini-4-argon","inputTokens":100,"outputTokens":20,"cacheCreationTokens":3,"cacheReadTokens":5,"cost":0.1234},{"modelName":"[pi] gpt-6.1-sol","inputTokens":200,"outputTokens":30,"cacheCreationTokens":4,"cacheReadTokens":6,"cost":1.2345}]},{"period":"2026-10-30","modelBreakdowns":[{"modelName":"[pi] gpt-6.1-sol","inputTokens":10,"outputTokens":20,"cacheCreationTokens":0,"cacheReadTokens":0,"cost":2.34},{"modelName":"[pi] gemini-4-argon","inputTokens":15,"outputTokens":25,"cacheCreationTokens":0,"cacheReadTokens":0,"cost":0.66}]}]}'
	else
		print -r -- 'Daily totals for 2026-10-29: $1.36'
	fi
}

output=$(aicosts 1)
[[ $output != *$'\033['* ]] || {
	print -u2 'FAIL: non-interactive output should not contain ANSI colors'
	exit 1
}
[[ $output == *'Per-model breakdown:'* && $output != *'Daily totals for'* && $output != *'┌'* ]] || {
	print -u2 'FAIL: output should contain only the per-model breakdown'
	exit 1
}
model_table=${output#*'Per-model breakdown:'}
[[ $output == $'📊 Per-model breakdown:\n\nDate'* ]] || {
	print -u2 'FAIL: expected a blank line after the heading'
	exit 1
}
[[ $model_table == *'Date'* && $model_table == *'Model'* && $model_table == *'Cost (USD)'* ]] || {
	print -u2 'FAIL: missing per-model table headers'
	exit 1
}
[[ $model_table != *'Input'* && $model_table != *'Output'* && $model_table != *'Cache Create'* && $model_table != *'Total Tokens'* ]] || {
	print -u2 'FAIL: per-model table includes unrequested columns'
	exit 1
}
[[ $model_table == *'[pi] gemini-4-argon'* && $model_table == *'[pi] gpt-6.1-sol'* && $model_table == *'$0.12'* && $model_table == *'$1.23'* ]] || {
	print -u2 'FAIL: missing model rows or rounded costs'
	exit 1
}
[[ $model_table == *'$1.36 (daily subtotal)'* && $model_table == *'$3.00 (daily subtotal)'* && $model_table == *'$4.36 (grand total)'* ]] || {
	print -u2 'FAIL: missing daily subtotals or grand total in the cost column'
	exit 1
}
model_cost_col=$(print -r -- "$model_table" | awk 'index($0, "$0.12") { print index($0, "$0.12"); exit }')
daily_total_col=$(print -r -- "$model_table" | awk 'index($0, "$1.36 (daily subtotal)") { print index($0, "$1.36 (daily subtotal)"); exit }')
grand_total_col=$(print -r -- "$model_table" | awk 'index($0, "$4.36 (grand total)") { print index($0, "$4.36 (grand total)"); exit }')
[[ -n $model_cost_col && $model_cost_col == $daily_total_col && $model_cost_col == $grand_total_col ]] || {
	print -u2 'FAIL: totals are not aligned in the Cost column'
	exit 1
}
separator_count=$(print -r -- "$model_table" | grep -c '^----------' || true)
[[ $separator_count == 2 ]] || {
	print -u2 "FAIL: expected separators between days and before the grand total, got $separator_count"
	exit 1
}
[[ $(grep -Fxc 'daily --json --since 2026-10-29 --until 2026-10-30' "$CALLS") == 1 && $(wc -l < "$CALLS" | tr -d ' ') == 1 ]] || {
	print -u2 'FAIL: expected one JSON report for the requested date range'
	exit 1
}

AICOSTS_FAIL_JSON=1
if output=$(aicosts 1 2>/dev/null); then
	print -u2 'FAIL: returned success when the JSON breakdown report failed'
	exit 1
fi

ccusage() {
	print -r -- '{"daily":[{"period":"2026-10-30","modelBreakdowns":[{"modelName":"[pi] gpt-6.1-sol","cost":2.34}]}]}'
}
single_day_output=$(aicosts 1)
[[ $single_day_output == *'(daily subtotal)'* && $single_day_output != *'(grand total)'* ]] || {
	print -u2 'FAIL: single-day output should show the subtotal and omit the grand total'
	exit 1
}
single_day_separators=$(print -r -- "$single_day_output" | grep -c '^----------' || true)
[[ $single_day_separators == 0 ]] || {
	print -u2 "FAIL: single-day output should have no separators, got $single_day_separators"
	exit 1
}

setopt err_exit

TTY_SCRIPT=$WS/tty-aicosts.zsh
TTY_LOG=$WS/tty.log
cat > "$TTY_SCRIPT" <<'EOF'
emulate -L zsh
source "$AICOSTS_FN"
date() {
	if [[ $1 == +%Y-%m-%d ]]; then
		print -r -- 2026-10-30
	else
		print -r -- 2026-10-29
	fi
}
ccusage() {
	sleep 0.3
	print -r -- '{"daily":[{"period":"2026-10-29","modelBreakdowns":[{"modelName":"[pi] gemini-4-argon","cost":1.25}]}]}'
}
aicosts 1
EOF
AICOSTS_FN=$FN script -q "$TTY_LOG" zsh -f -i -c "source ${(q)TTY_SCRIPT}" >/dev/null 2>&1 || {
	print -u2 'FAIL: interactive aicosts test failed to run'
	exit 1
}
if grep -Eq '\[[0-9]+\]([[:space:]]+[0-9]+|[[:space:]]+[-+][[:space:]]+done)' "$TTY_LOG"; then
	print -u2 'FAIL: interactive aicosts leaked background job notices'
	exit 1
fi
grep -Fq 'Calculating AI costs...' "$TTY_LOG" || {
	print -u2 'FAIL: interactive aicosts did not show a spinner'
	exit 1
}
grep -Fq $'\033[1m\033[38;5;81mDate' "$TTY_LOG" || {
	print -u2 'FAIL: interactive table header is not bold cyan'
	exit 1
}
grep -Fq $'\033[1m\033[38;5;220m' "$TTY_LOG" && grep -Fq '$1.25 (daily subtotal)' "$TTY_LOG" || {
	print -u2 'FAIL: interactive daily subtotal is not bold yellow'
	exit 1
}
grep -Fq '$1.25 (grand total)' "$TTY_LOG" && {
	print -u2 'FAIL: single-day interactive output should not show a grand total'
	exit 1
}
NO_COLOR=1 AICOSTS_FN=$FN script -q "$WS/no-color.log" zsh -f -i -c "source ${(q)TTY_SCRIPT}" >/dev/null 2>&1 || {
	print -u2 'FAIL: NO_COLOR aicosts test failed to run'
	exit 1
}
grep -Eq $'\033\\[[0-9;]*m' "$WS/no-color.log" && {
	print -u2 'FAIL: NO_COLOR should disable table colors'
	exit 1
}
print 'PASS  aicosts colors TTY tables and respects NO_COLOR'

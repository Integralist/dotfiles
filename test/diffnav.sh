#!/bin/bash
# Behaviour tests for the highlight-only Delta wrapper and Git pager wiring.
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
wrapper="$root/.config/diffnav/bin/delta"
real_delta=/opt/homebrew/bin/delta

settings() {
  "$@" --show-config </dev/null | perl -pe 's/\e\[[0-9;]*m//g'
}

assert_setting() {
  local actual
  actual=$(printf '%s\n' "$1" | awk -v key="$2" '
    $1 == key { sub(/^[^=]*=[[:space:]]*/, ""); print; exit }
  ')
  if [ "$actual" != "$3" ]; then
    printf 'FAIL: %s: expected [%s], got [%s]\n' "$2" "$3" "$actual" >&2
    exit 1
  fi
}

# Mirror Diffnav's equals-form arguments, including literal quotes and spaces.
options=(
  --no-gitconfig --true-color=always --syntax-theme=Dracula
  "--plus-style='syntax \"#113311\"'"
  "--minus-style='syntax \"#331111\"'"
  "--plus-emph-style='syntax \"#288028\"'"
  "--minus-emph-style='syntax \"#802828\"'"
  --tabs=7 '--line-numbers-right-format={np:>4} '
)
original=$(settings "$real_delta" "${options[@]}")
wrapped=$(settings "$wrapper" "${options[@]}")
assert_setting "$wrapped" plus-emph-style '"#ffffff" "#285c3e"'
assert_setting "$wrapped" minus-emph-style '"#ffffff" "#642b36"'

diff -u \
  <(printf '%s\n' "$original" | grep -Ev '^[[:space:]]*(plus|minus)-emph-style[[:space:]]*=') \
  <(printf '%s\n' "$wrapped" | grep -Ev '^[[:space:]]*(plus|minus)-emph-style[[:space:]]*=')
printf 'PASS: only word-highlight settings change; other arguments survive\n'

# With no highlight flags to replace, the wrapper must behave exactly like Delta.
diff -u \
  <(settings "$real_delta" --no-gitconfig) \
  <(settings "$wrapper" --no-gitconfig)
printf 'PASS: invocations without highlight overrides remain unchanged\n'

# Exercise stdin rendering with real Delta, not just its configuration display.
input='diff --git a/main.go b/main.go
index 1111111..2222222 100644
--- a/main.go
+++ b/main.go
@@ -1 +1 @@
-// (users.info) and Publisher
+// (users.info plus cached log metadata) and Publisher'
rendered=$(printf '%s\n' "$input" | "$wrapper" "${options[@]}")
case "$rendered" in
  *$'\033[48;2;40;92;62;38;2;255;255;255m plus cached log metadata'*) ;;
  *) printf 'FAIL: added words are not white on the custom green background\n' >&2; exit 1 ;;
esac
case "$rendered" in
  *$'\033[48;2;17;51;17;38;2;98;114;164m) and Publisher'*) ;;
  *) printf 'FAIL: surrounding comments lost their syntax colors\n' >&2; exit 1 ;;
esac
removed_input='diff --git a/main.go b/main.go
index 1111111..2222222 100644
--- a/main.go
+++ b/main.go
@@ -1 +1 @@
-// (users.info plus stale log metadata) and Publisher
+// (users.info) and Publisher'
removed=$(printf '%s\n' "$removed_input" | "$wrapper" "${options[@]}")
case "$removed" in
  *$'\033[48;2;100;43;54;38;2;255;255;255m plus stale log metadata'*) ;;
  *) printf 'FAIL: removed words are not white on the custom red background\n' >&2; exit 1 ;;
esac
printf 'PASS: added/removed words are readable; surrounding syntax stays intact\n'

# Preserve Delta's errors and exit status, including arguments containing spaces.
set +e
expected_error=$("$real_delta" '--diffnav-test-invalid=two words' 2>&1)
expected_status=$?
actual_error=$("$wrapper" '--diffnav-test-invalid=two words' 2>&1)
actual_status=$?
set -e
if [ "$expected_status" -eq 0 ] || [ "$actual_status" -ne "$expected_status" ] ||
   [ "$actual_error" != "$expected_error" ]; then
  printf 'FAIL: Delta error output or exit status was not preserved\n' >&2
  exit 1
fi
printf 'PASS: Delta error output and exit status pass through\n'

# Run Git's parsed pager command with a mock Diffnav that delegates to Delta.
workspace=$(mktemp -d)
trap 'rm -rf "$workspace"' EXIT
mkdir -p "$workspace/home/.config" "$workspace/bin"
ln -s "$root/.config/diffnav" "$workspace/home/.config/diffnav"
cat >"$workspace/bin/diffnav" <<'MOCK'
#!/bin/sh
[ "$#" -eq 1 ] && [ "$1" = --unified ] || exit 64
exec delta --no-gitconfig --show-config --syntax-theme=Dracula \
  '--plus-emph-style=syntax "#288028"' \
  '--minus-emph-style=syntax "#802828"'
MOCK
chmod +x "$workspace/bin/diffnav"
pager=$(git config --file "$root/.gitconfig" --get pager.diff)
pager_settings=$(HOME="$workspace/home" PATH="$workspace/bin:$PATH" \
  /bin/sh -c "$pager" </dev/null | perl -pe 's/\e\[[0-9;]*m//g')
assert_setting "$pager_settings" plus-emph-style '"#ffffff" "#285c3e"'
assert_setting "$pager_settings" minus-emph-style '"#ffffff" "#642b36"'
# The private PATH must not affect a subsequent standalone Delta invocation.
diff -u \
  <(settings "$real_delta" --no-gitconfig) \
  <(HOME="$workspace/home" PATH="$workspace/bin:$PATH" \
    /bin/sh -c 'delta --no-gitconfig --show-config' </dev/null | perl -pe 's/\e\[[0-9;]*m//g')
printf 'PASS: Git pager uses the wrapper; standalone Delta remains unchanged\n'

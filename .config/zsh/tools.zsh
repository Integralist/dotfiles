#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Otherwise tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# NOTE: Some tools are installed from within earlier loaded script files.
# An example of this is fzf which is needed for ./autocomplete.zsh

# WARNING: We have to add .cargo/bin directory into $PATH before installing.
# This helps avoid https://github.com/rust-analyzer/rust-analyzer/issues/4172
#
# TODO: Validate this is still necessary.
#
if ! command -v rustc &> /dev/null
then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

if ! command -v shellcheck &> /dev/null
then
  brew install shellcheck
fi

# Rust environment
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
# rust_update updates/installs necessary Rust tools.
function rust_update {
  rustup self update
  rustup update stable
  rustup component add rustfmt
  rustup component add clippy
  cargo install cargo-audit --features=fix
  cargo install cargo-nextest
  cargo install cargo-edit
  rustup update
}

# Golang environment
#
# NOTE: We install Go manually (not via Homebrew).
# We then rely on the Go toolchain behaviours added in go1.21
# Which are, in the go.mod file, the `go` directive controls language rules.
# While the `toolchain` directive controls which Go binary actually runs.
# Go then handles automatically installing that `toolchain` binary for you.
#
# For complete list of all go versions:
# https://go.dev/dl/
#
# Example:
# https://go.dev/dl/go1.23.5.darwin-arm64.tar.gz
#
# We install the Go programming language's runtime, compiler,
# and standard library into GOROOT.
#
# Installing alternative versions is done like so:
# $ go install golang.org/dl/go1.21.13@latest
#
# It will install the binary into the GOPATH:
# $GOPATH/bin/go1.21.13
#
# But you'll need to download first, after the install:
# $ go1.21.13 download
# $ go1.21.13 version
#
# Once downloaded the GOROOT/associated SDK files (api, bin, doc, etc...) are stored in:
# ~/sdk/go1.21.13/
#
# Use `go env GOROOT` to print the relevant root files for the current Go
# version that is running/switched to.
#
# When installing a tool (like revive) it is installed into the $GOPATH/bin:
# go install github.com/mgechev/revive@latest
#
# IMPORTANT: We modify the PATH hence we have to re-assign MODIFIED_PATH below.
#
export GOPATH="$HOME/go"
export GOROOT="$HOME/.go"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH";

# go_install_latest installs the latest go version.
#
function go_install_latest {
	mkdir -p "$GOPATH"
	mkdir -p "$GOROOT"

	local GO_VERSION=$(golatest)
	local OS=$(uname | tr '[:upper:]' '[:lower:]')
	local ARCH=$(uname -m)
	local URL="https://go.dev/dl/go${GO_VERSION}.${OS}-${ARCH}.tar.gz"
	local TMP_DL="/tmp/go.tar.gz"

	echo "Downloading latest Go archive from $URL"
	curl -Lo "$TMP_DL" "$URL"

	# Extract the tar.gz file to the installation directory
	# The --strip-components=1 skips the go/ directory within the archive.
	# This ensures the ~/.go directory contains bin/ rather than ~/.go/go/bin
	echo "Extracting Go archive to $GOROOT"
	tar -C "$GOROOT" --strip-components=1 -xzf "$TMP_DL"

	# Cleanup the downloaded archive
	echo "Cleaning up Go archive from $TMP_DL"
	rm "$TMP_DL"
}
# go_tools installs/updates necessary Go tools.
#
function go_tools {
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
	go install github.com/davecheney/httpstat@latest
	go install github.com/segmentio/golines@latest
	go install github.com/rhysd/actionlint/cmd/actionlint@latest
	go install fillmore-labs.com/scopeguard@latest
	go install github.com/fastly/mcp/cmd/fastly-mcp@latest
}
# go_list lists all installed tools
#
function go_list() {
	echo "GOPATH: $GOPATH/bin"
	ls $GOPATH/bin
}
# go_clean deletes the Go installation completely.
#
function go_clean() {
	sudo rm -rf ~/go ~/.go ~/sdk
}

if [ ! -f $GOROOT/bin/go ]; then
	go_install_latest
	go_tools
else
	# Check for updates
	# WARNING: This runs a network call on every shell startup which can be slow.
	#
	CURRENT_GO_VERSION=$($GOROOT/bin/go version 2>/dev/null | cut -d ' ' -f 3 | sed 's/go//')
	LATEST_GO_VERSION=$(golatest)

	if [ -n "$LATEST_GO_VERSION" ] && [ "$CURRENT_GO_VERSION" != "$LATEST_GO_VERSION" ]; then
		echo "Updating Go from $CURRENT_GO_VERSION to $LATEST_GO_VERSION..."
		go_clean
		go_install_latest
		go_tools
	fi
fi
# # go_install installs the specified version into ~/go/...
# function go_install() {
#   if [ -z "$1" ]; then
# 		echo "Pass a Go version (e.g. 1.21.13)"
#     return
#   fi
# 	local v="$1"
# 	go install "golang.org/dl/go$v@latest"
# 	"$GOPATH/bin/go$v" download
# 	"$GOPATH/bin/go$v" version
# }

# chpwd overrides the cd command to call ls when changing directories as it's
# nice to see what's in each directory. We do this using a Zsh hook function.
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
#
function chpwd() {
	ls

	# clean out any .DS_Store files
	#
	if [[ $PWD != $HOME ]]; then
		# find . -type f -name '.DS_Store' -delete
		fd '.DS_Store' --type f --hidden --absolute-path | xargs -I {} rm {}
	fi

	# the Starship prompt can sometimes be misleading as it truncates the path
	pwd
}

# zoxide is a directory switcher
#
# z <pattern>
# zoxide query -ls
#
eval "$(zoxide init zsh)"

# Starship prompt
# https://starship.rs/
#
eval "$(starship init zsh)"

# Configure fnm node version manager.
# https://github.com/Schniz/fnm/blob/master/docs/configuration.md
#
# IMPORTANT: This modifies PATH hence we have to re-assign MODIFIED_PATH below.
#
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# IMPORTANT: We MUST assign the modified path to a new environment variable.
# The parent scope (~/.zshrc) will then prefix it to its current path value.
export MODIFIED_PATH="$PATH"

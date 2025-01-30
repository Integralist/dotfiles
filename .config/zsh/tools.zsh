#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Also, other tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

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

# Golang environment
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
# Once downloaded the associated SDK files (api, bin, doc, etc...) are stored in:
# ~/sdk/go1.21.13/
#
# When installing a tool (like revive) it is installed into the $GOPATH/bin:
# go install github.com/mgechev/revive@latest
#
# NOTE: Installing the same tool using a different Go version overwrites the tool.
# e.g. the tool will be downloaded into the global $GOPATH/bin directory.
# go1.22.10 install github.com/mgechev/revive@latest
#
# WARNING: Don't run the non-mainline binary in a go.mod directory!
# It'll attempt to download/use the version defined by the module.
#
# IMPORTANT: We modify the PATH hence we have to re-assign MODIFIED_PATH below.
#
# Auto-switching Go versions is done using .go-version file.
# See chpwd() function further down below.
#
export GOPATH="$HOME/go"
export GOROOT="$HOME/.go"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH";
export PATH="$HOME/.humanlog/bin:$PATH" # https://github.com/humanlogio/humanlog (installed via `go install` then upgrade via the installed binary which installs the upgrade in a different path)
if [ ! -f $GOROOT/bin/go ]; then
	mkdir -p "$GOPATH"
	mkdir -p "$GOROOT"

	GO_VERSION=$(golatest)
	OS=$(uname | tr '[:upper:]' '[:lower:]')
	ARCH=$(uname -m)
	URL="https://go.dev/dl/go${GO_VERSION}.${OS}-${ARCH}.tar.gz"
	TMP_DL="/tmp/go.tar.gz"

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
fi
# go_update updates/installs necessary Go tools.
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
}
# go_install installs the specified version
function go_install() {
  if [ -z "$1" ]; then
		echo "Please pass the Go version to install (e.g. 1.21.13)"
    return
  fi
	local v="$1"
	go install "golang.org/dl/go$v@latest"
	"$GOPATH/bin/go$v" download
	"$GOPATH/bin/go$v" version
	go_alias $v
}
# go_alias creates an alias for the specified version
function go_alias() {
	local v="$1"
	alias go="$GOPATH/bin/go$v"
}
# go_list lists all installed tools
function go_list() {
	ls $GOPATH/bin
}
# go_clean deletes the Go installation completely.
function go_clean() {
	sudo rm -rf ~/go ~/.go
}

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
# rust_update updates Homebrew and updates/installs necessary Rust tools.
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

# chpwd overrides the cd command to call ls when changing directories as it's
# nice to see what's in each directory. We do this using a Zsh hook function.
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
#
# IMPORTANT: We need chpwd to be defined AFTER the go_* functions above.
# As we need to call them from this function.
#
function chpwd() {
    ls
    if [ -e .go-version ]; then
			go_install $(cat .go-version)
    fi

    # clean out any .DS_Store files
    #
    if [[ $PWD != $HOME ]]; then
			# find . -type f -name '.DS_Store' -delete
			fd '.DS_Store' --type f --hidden --absolute-path | xargs -I {} rm {}
    fi
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

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
# https://github.com/stefanmaric/g
# curl -sSL https://git.io/g-install | sh -s
#
# auto-switching of go versions is done using .go-version file (see chpwd() function)
#
# Example version install location:
# /Users/integralist/.go/.versions/1.21.0
#
# The $GOROOT/bin/go executable is either the latest go version or .go-version
#
# Running `go install` will install binaries into ~/go/bin
#
# IMPORTANT: We modify the PATH hence we have to re-assign MODIFIED_PATH below.
#
export GOROOT="$HOME/.go"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.humanlog/bin:$PATH" # https://github.com/humanlogio/humanlog (installed via `go install` then upgrade via the installed binary which installs the upgrade in a different path)
alias gov="$GOPATH/bin/g"
if [ -e .go-version ]; then
  "$GOPATH"/bin/g install $(cat .go-version)
else
  "$GOPATH"/bin/g install $(golatest)
fi
if [ ! -f "$HOME/go/bin/gopls" ]; then
  go install golang.org/x/tools/gopls@latest
fi
if [ ! -f "$HOME/go/bin/gofumpt" ]; then
  go install mvdan.cc/gofumpt@latest
fi
if [ ! -f "$HOME/go/bin/revive" ]; then
  go install github.com/mgechev/revive@latest
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
if [ ! -f "$HOME/.config/rustlang/autocomplete/rustup" ]; then
  mkdir -p ~/.config/rustlang/autocomplete
  rustup completions zsh rustup >> ~/.config/rustlang/autocomplete/rustup
fi
source "$HOME/.config/rustlang/autocomplete/rustup"
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

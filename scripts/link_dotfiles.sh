#!/usr/bin/env sh
set -eu

DOTFILES_DIR="${1:-$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

link_entry() {
  src="$1"
  dest="$2"
  [ -e "$src" ] || return 0
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    backup="${dest}.bak.${TIMESTAMP}"
    mv "$dest" "$backup"
    printf 'WARNING: %s already exists; backed up to %s\n' "$dest" "$backup" >&2
  fi
  ln -s "$src" "$dest"
  printf 'Linked %s -> %s\n' "$dest" "$src"
}

for name in .editorconfig .gitattributes .gitcommit .gitconfig .gitignore .gitmodules \
  .gnupg .golangci.yml .ignore .localrc .pip .shellcheckrc .snippets .spectral.yaml .zshrc; do
  link_entry "$DOTFILES_DIR/$name" "$HOME/$name"
done

for src in "$DOTFILES_DIR/.config"/*; do
  name="$(basename "$src")"
  case "$name" in README.md|hunk) continue ;; esac
  link_entry "$src" "$HOME/.config/$name"
done

link_entry "$DOTFILES_DIR/.config/hunk/config.toml" "$HOME/.config/hunk/config.toml"

for src in "$DOTFILES_DIR/.local/bin"/*; do
  link_entry "$src" "$HOME/.local/bin/$(basename "$src")"
done

# Shell Configuration

This repository contains personal dotfiles and configuration for various command-line tools and applications. Below is a breakdown of what each directory is for.

## Directory Structure

### `bat`

Configuration for [bat](https://github.com/sharkdp/bat), a `cat` clone with syntax highlighting. It includes custom syntax definitions, such as for `tmux.conf` files.

### `flameshot`

Configuration for [Flameshot](https://flameshot.org/), a powerful and easy-to-use screenshot software.

### `ghostty`

Configuration for [Ghostty](https://github.com/ghostty-org/ghostty), a GPU-accelerated terminal emulator. The `config` file defines settings like font, keybindings, and theme.

### `htop`

Configuration for [htop](https://htop.dev/), an interactive process viewer. The `htoprc` file saves the setup and display options.

### `humanlog`

Configuration for [humanlog](https://github.com/humanlogio/humanlog), a tool for parsing and viewing structured logs in a human-readable format.

### `nvim`

Configuration for [Neovim](https://neovim.io/), a highly extensible, Vim-based text editor. This is the main editor configuration, managed with Lua and the `lazy.nvim` plugin manager.

### `procs`

Configuration for [procs](https://github.com/dalance/procs), a modern replacement for `ps` with more readable output.

### `rio`

Configuration for [Rio](https://raphamorim.io/rio/), a GPU-accelerated terminal emulator, including themes and startup settings.

### `safari`

Contains custom CSS stylesheets for modifying the appearance of websites in Safari.

### `zellij`

Configuration for [Zellij](https://zellij.dev/), a terminal multiplexer and workspace. The `config.kdl` file defines keybindings, themes, and layout behavior.

### `zsh`

Configuration for the [Zsh shell](https://www.zsh.org/), including aliases, functions, environment variables, and autocomplete settings.

## Root Configuration Files

- `checkmake.ini`: Configuration for [checkmake](https://github.com/mrtazz/checkmake), a linter for Makefiles.
- `flake8`: Configuration for [Flake8](https://flake8.pycqa.org/en/latest/), a Python code linter.
- `starship.toml`: Configuration for [Starship](https://starship.rs/), a cross-shell prompt.

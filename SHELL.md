# Shell Configuration

This document outlines the structure and functionality of the Zsh shell configuration. The setup is modular, with the main `.zshrc` file acting as an entry point that sources various configuration files from the `~/.config/zsh/` directory.

## `.zshrc` - The Entry Point

The `~/.zshrc` file is the primary configuration file loaded by Zsh for interactive shells. Its main responsibilities are:

1.  **Define a Script Loader**: It defines a `load_script` helper function to source other configuration files, checking for their existence first.
2.  **Manage `$PATH`**: It uses a special variable `MODIFIED_PATH` to allow sourced scripts to modify the system's `$PATH` in a controlled and cumulative way.
3.  **Load Modular Configuration**: It sequentially loads various scripts from `~/.config/zsh/`, each responsible for a specific aspect of the shell's configuration.
4.  **Load Local Overrides**: It sources an optional `~/.localrc` file for user-specific configurations that should not be committed to version control.

### `MODIFIED_PATH` Strategy

The `$PATH` management is designed to be modular and avoid issues with sourced scripts having a limited `PATH`. The process is as follows:

1.  **Initialization**: `.zshrc` saves the initial `$PATH` into a new variable: `export MODIFIED_PATH="$PATH"`.
2.  **Script Execution**: Each sourced script that needs to modify the path first sets its local `PATH` to the current `MODIFIED_PATH` (`export PATH="$MODIFIED_PATH"`). This ensures it has access to all previously added paths.
3.  **Path Modification**: The script then prepends or appends new directories to its local `PATH`.
4.  **Update**: At the end, the script exports its modified `PATH` back to `MODIFIED_PATH` (`export MODIFIED_PATH="$PATH"`), making the changes available to subsequent scripts.
5.  **Finalization**: After all scripts are loaded, `.zshrc` constructs the final, global `$PATH` by combining `MODIFIED_PATH` with the original `$PATH` and then deduplicates it using `typeset -U path`.

This strategy ensures that each script builds upon the `PATH` modifications of the previous ones in a clean, sequential manner.

## Configuration Files

All shell configuration is broken down into the following files located in `~/.config/zsh/`.

### `options.zsh`

This file configures Zsh's behavior by setting and unsetting various shell options using `setopt` and `unsetopt`. This includes things like command history behavior, globbing patterns, and prompt settings.

### `exports.zsh`

Responsible for setting and exporting environment variables that should be available to all processes started from the shell. This is where variables like `EDITOR`, `PAGER`, or language-specific paths (e.g., `GOPATH`) are defined.

### `alias.zsh`

Contains all shell alias definitions. Aliases are used to create shortcuts for longer or frequently used commands.

### `tools.zsh`

Manages the installation, configuration, and runtime integration of development toolchains and shell enhancement tools. This includes the Go and Rust environments, the `zoxide` directory switcher, the `starship` prompt, and the `fnm` Node.js version manager.

### `autocomplete.zsh`

Configures Zsh's powerful autocompletion system. This includes initializing the completion system (`compinit`) and setting up completions for specific commands.

### `functions.zsh`

Defines custom shell functions that can be used as commands in the shell. These are more powerful than aliases and can accept arguments.

### `bindings.zsh`

Manages custom key bindings using the `bindkey` command. This allows for customizing keyboard shortcuts for editing commands on the command line.

### `shell.zsh`

Handles the shell session's runtime environment. This includes initializing services like `ssh-agent` and `gpg-agent`, setting resource limits (`ulimit`), and running periodic background tasks like dependency updates for Homebrew and Rust.

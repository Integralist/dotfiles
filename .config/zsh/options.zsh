#!/usr/bin/zsh
#
# https://zsh.sourceforge.io/Doc/Release/Options.html
#
# If you want to share history across terminal instances:
#   setopt SHARE_HISTORY
#
# But be warned this can be annoying when you want to⬆️the history and find your
# recent command is no longer the most recent.
#

setopt AUTO_CD # Automatically changes to a directory if a command matches a directory name, without requiring the cd command.
setopt CDABLE_VARS # Allows variable names to be used with cd. If the argument to cd matches a variable name, Zsh changes to the directory stored in the variable.
setopt CD_SILENT # Suppresses output when changing directories with cd.
setopt CHASE_DOTS # Resolves . and .. in pathnames when navigating directories, even if symbolic links are present.
setopt CHASE_LINKS # Resolves symbolic links to their target directory when changing directories.
setopt ALWAYS_LAST_PROMPT # Ensures the prompt is always displayed after executing a command, even if the terminal output is redirected.
setopt ALWAYS_TO_END # Moves the cursor to the end of the line when a history entry is modified during editing.
setopt AUTO_LIST # Automatically lists completions when the tab key is pressed, and there is more than one possible match.
setopt AUTO_MENU # Displays a menu of completion options after a partial match is typed and tab is pressed multiple times.
setopt AUTO_NAME_DIRS # Automatically creates named directory aliases for directories specified in the cdpath.
setopt AUTO_PARAM_KEYS # When completing associative array keys, Zsh will add a closing ] automatically.
setopt AUTO_PARAM_SLASH # Automatically adds a trailing slash when completing directory names.
setopt AUTO_REMOVE_SLASH # Removes an unnecessary trailing slash from pathnames when not needed.
setopt COMPLETE_IN_WORD # Allows completion to occur in the middle of a word rather than just at the cursor’s end.
setopt GLOB_COMPLETE # Enables completion that treats globs (e.g., *.txt) as potential matches to complete filenames.
setopt HASH_LIST_ALL # Lists all executables in the hash table when hashing is enabled (used for command lookup).
setopt LIST_AMBIGUOUS # Lists possible completions for ambiguous inputs instead of waiting for more typing.
setopt LIST_PACKED # Displays completion options in a compact, multi-column format.
setopt LIST_TYPES # Adds a file type indicator (e.g., / for directories, * for executables) when listing completions.
setopt MENU_COMPLETE # Cycles through completion options by repeatedly pressing the tab key.
setopt EXTENDED_GLOB # Enables advanced globbing features like negation (^), matching ranges, etc.
setopt REMATCH_PCRE # Enables Perl-compatible regular expressions (PCRE) for pattern matching in Zsh.
setopt INC_APPEND_HISTORY # Appends commands to the history file incrementally as they are executed.
setopt HIST_EXPIRE_DUPS_FIRST # Removes the oldest duplicate entries from history when the history size limit is reached.
setopt HIST_FCNTL_LOCK # Uses file locking to prevent simultaneous access issues with the history file.
setopt HIST_FIND_NO_DUPS # Avoids showing duplicate history entries when searching interactively.
setopt HIST_IGNORE_ALL_DUPS # Removes all duplicate entries from history when a new duplicate command is added.
setopt HIST_REDUCE_BLANKS # Removes extra whitespace from commands saved to history.
setopt ALIASES # Enables alias expansion for command lines.
setopt VI # Enable vi-style keybindings for command-line editing.
setopt NOCORRECT NOCORRECTALL # Disables spell checking for the current command or for all commands.

unsetopt BEEP # Disables the terminal bell or audible beep when an error or alert occurs.
unsetopt CASE_GLOB # Makes globbing case-insensitive (disabled here, so globbing is case-sensitive).
unsetopt CASE_MATCH # Requires case-sensitive pattern matching (disabled here, so matching is case-insensitive).

# http://zsh.sourceforge.net/Doc/Release/Options.html#Expansion-and-Globbing
# By default, if a command line contains a globbing expression which doesn't
# match anything, Zsh will print the error message you're seeing, and not run
# the command at all. You can disable this using the following...
setopt +o nomatch

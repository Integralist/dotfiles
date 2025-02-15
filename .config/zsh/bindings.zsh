#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Also, other tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# NOTE: For a complete list of shell bindings, run: `zle -l`.
# TIP: To see what "escape sequence" your terminal uses, run `cat` and type.

# Support deleting word to the right.
# Ctrl + Fn + Backspace
#
bindkey '^[[3;5~' kill-word

# Configure a shortcut for the `vf` alias
bindkey -s '^f' 'nvim $(fzf)\n'

# Allow yanking command input to system clipboard.
#
# It works like this:
# echo $BUFFER prints the command you're currently typing.
# Piping (|) it into pbcopy sends that text to the macOS system clipboard.
# We use Zsh's zle (Zsh Line Editor) to intercept the buffer before execution and copy it to the clipboard.
#
# NOTE: This only works when you've typed a command but not run.
copy-buffer-to-clipboard() {
  echo $BUFFER | pbcopy
  zle reset-prompt  # refresh the prompt to avoid command overlap
}
zle -N copy-buffer-to-clipboard
bindkey '^Y' copy-buffer-to-clipboard

# WARNING: ghostty doesn't yet support advanced key binding selections.
# https://github.com/ghostty-org/ghostty/discussions/3142
#
# But I stumbled into a partial work-around that helps partially support it:
# https://stackoverflow.com/questions/5407916/zsh-zle-shift-selection
# I've modified the original code to fit my own requirements.
#
# | BINDING                  | ACTION                 | SUPPORTED | WORK-AROUND
# | Cmd + x                  | Cut selection          | ❌        | Fn + Ctrl + x
# | Cmd + c                  | Copy selection         | ✅        |
# | Cmd + v                  | Paste selection        | ✅        |
# | Shift + LeftArrow        | Select left character  | ✅        |
# | Shift + RightArrow       | Select right character | ✅        |
# | Shift + Opt + LeftArrow  | Select word to left    | ✅        |
# | Shift + Opt + RightArrow | Select word to right   | ✅        |
# | Cmd + Shift + LeftArrow  | Select to line start   | ✅        |
# | Cmd + Shift + RightArrow | Select to line end     | ✅        |
# | Cmd + LeftArrow          | Move to line start     | ✅        |
# | Cmd + RightArrow         | Move to line end       | ✅        |
# | Opt + LeftArrow          | Move word to left      | ✅        |
# | Opt + RightArrow         | Move word to right     | ✅        |
# | Opt + Backspace          | Delete word to left    | ✅        |
# | Opt + Fn + Backspace     | Delete word to right   | ❌        | Fn + Ctrl + Backspace

export KEY_BACKSPACE='^?'
export KEY_CMD_C='^[[27;6;67~'
export KEY_CMD_LEFT='^A'
export KEY_CMD_RIGHT='^E'
export KEY_DELETE='^[[3~'
export KEY_FN_CTRL_X='^X'
export KEY_LEFT='^[[D'
export KEY_RIGHT='^[[C'
export KEY_SHIFT_CMD_LEFT='^[[1;10D'
export KEY_SHIFT_CMD_RIGHT='^[[1;10C'
export KEY_SHIFT_LEFT='^[[1;2D'
export KEY_SHIFT_OPT_LEFT='^[[1;4D'
export KEY_SHIFT_OPT_RIGHT='^[[1;4C'
export KEY_SHIFT_RIGHT='^[[1;2C'

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# copy selected terminal text to clipboard
zle -N widget::copy-selection
function widget::copy-selection {
    if ((REGION_ACTIVE)); then
        zle copy-region-as-kill
				printf "%s" $CUTBUFFER | pbcopy
    fi
}

# cut selected terminal text to clipboard
zle -N widget::cut-selection
function widget::cut-selection() {
    if ((REGION_ACTIVE)) then
        zle kill-region
				printf "%s" $CUTBUFFER | pbcopy
    fi
}

# paste clipboard contents
zle -N widget::paste
function widget::paste() {
    ((REGION_ACTIVE)) && zle kill-region
		RBUFFER="$(wl-paste)${RBUFFER}"
		CURSOR=$(( CURSOR + $(echo -n "$(pbpaste)" | wc -m | bc) ))
}

# select entire prompt
zle -N widget::select-all
function widget::select-all() {
    local buflen=$(echo -n "$BUFFER" | wc -m | bc)
    CURSOR=$buflen   # if this is messing up try: CURSOR=9999999
    zle set-mark-command
    while [[ $CURSOR > 0 ]]; do
        zle beginning-of-line
    done
}

# scrolls the screen up, in effect clearing it
zle -N widget::scroll-and-clear-screen
function widget::scroll-and-clear-screen() {
    printf "\n%.0s" {1..$LINES}
    zle clear-screen
}

function widget::util-select() {
    ((REGION_ACTIVE)) || zle set-mark-command
    local widget_name=$1
    shift
    zle $widget_name -- $@
    zle copy-region-as-kill
		printf "%s" $CUTBUFFER | pbcopy
}

function widget::util-unselect() {
    REGION_ACTIVE=0
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

function widget::util-delselect() {
    if ((REGION_ACTIVE)) then
        zle kill-region
    else
        local widget_name=$1
        shift
        zle $widget_name -- $@
    fi
}

function widget::util-insertchar() {
    ((REGION_ACTIVE)) && zle kill-region
    RBUFFER="${1}${RBUFFER}"
    zle forward-char
}

bindkey $KEY_CMD_C widget::copy-selection
bindkey $KEY_FN_CTRL_X widget::cut-selection

# NOTE: "keyname" column is arbitrarily descriptive.
#
for keyname           kcap   seq                   mode       widget (
    # LEFT/RIGHT seems pointless but they specifically UNSELECT text.
    left              kcub1  $KEY_LEFT             unselect   backward-char
    right             kcuf1  $KEY_RIGHT            unselect   forward-char

		# DELETE/BACKSPACE seems pointless but they specifically delete selected text.
    del               x      $KEY_DELETE           delselect  delete-char
    backspace         x      $KEY_BACKSPACE        delselect  backward-delete-char

    cmd-left          x      $KEY_CMD_RIGHT        unselect   end-of-line
    cmd-right         x      $KEY_CMD_LEFT         unselect   beginning-of-line
    shift-cmd-left    x      $KEY_SHIFT_CMD_LEFT   select     beginning-of-line
    shift-cmd-right   x      $KEY_SHIFT_CMD_RIGHT  select     end-of-line
    shift-ctrl-left   x      $KEY_SHIFT_OPT_LEFT   select     backward-word
    shift-ctrl-right  x      $KEY_SHIFT_OPT_RIGHT  select     forward-word
    shift-left        kLFT   $KEY_SHIFT_LEFT       select     backward-char
    shift-right       kRIT   $KEY_SHIFT_RIGHT      select     forward-char
) {
    eval "function widget::key-$keyname() {
        widget::util-$mode $widget \$@
    }"
    zle -N widget::key-$keyname
    bindkey $seq widget::key-$keyname
}

# Fixes autosuggest completion being overriden by keybindings:
# to have [zsh] autosuggest [plugin feature] complete visible
# suggestions, you can assign an array of shell functions to
# the `ZSH_AUTOSUGGEST_ACCEPT_WIDGETS` variable. When these
# functions are triggered, they will also complete any visible
# suggestion. Example:
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
    widget::key-right
    widget::key-shift-right
    widget::key-cmd-right
    widget::key-shift-cmd-right
)

###############################################################################
# DISABLED STUFF
###############################################################################

# Support backward searching auto-complete entries
# Shift-Tab
#
# DISABLED: Not necessary when using https://github.com/Aloxaf/fzf-tab
#
# bindkey '^[[Z' reverse-menu-complete

#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Also, other tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# NOTE: For a complete list of shell bindings, run: `zle -l`.
# TIP: To see what "escape sequence" your terminal uses, run `cat` and type.

# Shift-Tab for backward searching auto-complete entries
#
# DISABLED: Not necessary when using https://github.com/Aloxaf/fzf-tab
#
# bindkey '^[[Z' reverse-menu-complete

# Explicitly override VI-MODE set because of EDITOR value.
#
# DISABLED:
# See `setopt VI` earlier in the file.
# We went back to using vi-mode as ghostty doesn't support text selection.
#
# bindkey -e .

# In zsh's vi-mode, ensure pressing the Delete/Backspace key deletes the character before the cursor.
# ^? == backspace (i.e. allow deleting backwards)
#
bindkey -v '^?' backward-delete-char

# In zsh's vi-mode support moving backwards and forwards by word.
#
# DISABLED: Doesn't appear to work with ghostty without breaking vi-mode.
#
# bindkey -v '^[b' backward-word
# bindkey -v '^[f' forward-word

# Support forward deletion
# ^[[3~ == fn+backspace
#
bindkey '^[[3~' delete-char

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
# But I stumbled into a partial work-around:
# https://stackoverflow.com/questions/5407916/zsh-zle-shift-selection
#
# IMPORTANT: I've modified the following to use pbcopy and pbpaste.
#
# - `Shift+LeftArrow` and `Shift+RightArrow` to select by character.
# - `Shift+Ctrl+LeftArrow` and `Shift+Ctrl+RightArrow` to select by word.
# - `Shift+Fn+LeftArrow` and `Shift+Fn+RightArrow` to select to start/end of line.
# - `Cmd+c` to copy the selection
# - `Cmd+v` to paste the selection
# - `Ctrl+Backspace` deletes the word to the left.
# - `Ctrl+Fn+Backspace` deletes the word to the right.
#
###############
# Keybindings #
###############

# Bind Alt + Delete for forward deleting a word
bindkey -M emacs '^[[3;3~' kill-word

# Bind Delete to delete a letter to the right
bindkey "^[[3~" delete-char

# Ctrl binds
# Bind Ctrl + Delete to delete word to the right
bindkey '^[[3;5~' kill-word

# Bind Ctrl + Backspace to delete word to the left
bindkey '^H' backward-kill-word

# Bind Ctrl + Right Arrow to move to the next word
bindkey '^[[1;5C' forward-word

################
# Shift Select #
################

# for my own convenience I explicitly set the signals
#   that my terminal sends to the shell as variables.
#   you might have different signals. you can see what
#   signal each of your keys sends by running `cat`
#   and pressing keys (you'll be able to see most keys)
#   also some of the signals sent might be set in your
#   terminal emulator application/program
#   configurations/preferences. finally some terminals
#   have a feature that shows you what signals are sent
#   per key press.
#
# for context, at the time of writing these variables are
#   set for the kitty terminal program, i.e these signals
#   are mostly ones sent by default by this terminal.
export KEY_ALT_B='^[b'
export KEY_ALT_D='^[d'
export KEY_ALT_F='^[f'

export KEY_CTRL_A='^A'
export KEY_CTRL_E='^E'
export KEY_CTRL_L='^L'
export KEY_CTRL_R='^R'
export KEY_CTRL_U='^U'
export KEY_CTRL_Z='^Z'

export KEY_SHIFT_CTRL_A='^[[27;6;65~'
export KEY_SHIFT_CTRL_C='^[[27;6;67~'
export KEY_SHIFT_CTRL_E='^[[27;6;69~'
export KEY_SHIFT_CTRL_V='^[[27;6;86~'
export KEY_SHIFT_CTRL_X='^[[27;6;88~'
export KEY_SHIFT_CTRL_Z='^[[27;6;90~'

export KEY_LEFT='^[[D'
export KEY_RIGHT='^[[C'
export KEY_SHIFT_UP='^[[1;2A'
export KEY_SHIFT_DOWN='^[[1;2B'
export KEY_SHIFT_RIGHT='^[[1;2C'
export KEY_SHIFT_LEFT='^[[1;2D'
export KEY_ALT_LEFT='^[[1;3D'
export KEY_ALT_RIGHT='^[[1;3C'
export KEY_SHIFT_ALT_LEFT='^[[1;4D'
export KEY_SHIFT_ALT_RIGHT='^[[1;6C'
export KEY_CTRL_LEFT='^[[1;5D'
export KEY_CTRL_RIGHT='^[[1;5C'
export KEY_SHIFT_CTRL_LEFT='^[[1;6D'
export KEY_SHIFT_CTRL_RIGHT='^[[1;6C'

export KEY_END='^[[F;'
export KEY_HOME='^[[H'
export KEY_SHIFT_END='^[[1;2F'
export KEY_SHIFT_HOME='^[[1;2H'

export KEY_DELETE='^[[3~'
export KEY_BACKSPACE='^?'
export KEY_CTRL_BACKSPACE='^H'

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


#                       |  key sequence                   | command
# --------------------- | ------------------------------- | -------------

bindkey                   $KEY_ALT_F                        forward-word
bindkey                   $KEY_ALT_B                        backward-word
bindkey                   $KEY_ALT_D                        kill-word
bindkey                   $KEY_CTRL_U                       backward-kill-line
bindkey                   $KEY_CTRL_BACKSPACE               backward-kill-word
bindkey                   $KEY_CTRL_Z                       undo
bindkey                   $KEY_SHIFT_CTRL_Z                 redo
bindkey                   $KEY_CTRL_R                       history-incremental-search-backward
bindkey                   $KEY_SHIFT_CTRL_C                 widget::copy-selection
bindkey                   $KEY_SHIFT_CTRL_X                 widget::cut-selection
bindkey                   $KEY_SHIFT_CTRL_V                 widget::paste
bindkey                   $KEY_SHIFT_CTRL_A                 widget::select-all
bindkey                   $KEY_CTRL_L                       widget::scroll-and-clear-screen

for keyname        kcap   seq                   mode        widget (

    left           kcub1  $KEY_LEFT             unselect    backward-char
    right          kcuf1  $KEY_RIGHT            unselect    forward-char

    shift-up       kri    $KEY_SHIFT_UP         select      up-line-or-history
    shift-down     kind   $KEY_SHIFT_DOWN       select      down-line-or-history
    shift-right    kRIT   $KEY_SHIFT_RIGHT      select      forward-char
    shift-left     kLFT   $KEY_SHIFT_LEFT       select      backward-char

    alt-right         x   $KEY_ALT_RIGHT        unselect    forward-word
    alt-left          x   $KEY_ALT_LEFT         unselect    backward-word
    shift-alt-right   x   $KEY_SHIFT_ALT_RIGHT  select      forward-word
    shift-alt-left    x   $KEY_SHIFT_ALT_LEFT   select      backward-word

    ctrl-right        x   $KEY_CTRL_RIGHT       unselect    forward-word
    ctrl-left         x   $KEY_CTRL_LEFT        unselect    backward-word
    shift-cmd-right   x   $KEY_SHIFT_CTRL_RIGHT select      end-of-line
    shift-cmd-left    x   $KEY_SHIFT_CTRL_LEFT  select      beginning-of-line

    ctrl-e            x   $KEY_CTRL_E           unselect    end-of-line
    ctrl-a            x   $KEY_CTRL_A           unselect    beginning-of-line
    shift-ctrl-e      x   $KEY_SHIFT_CTRL_E     select      end-of-line
    shift-ctrl-a      x   $KEY_SHIFT_CTRL_A     select      beginning-of-line
    shift-ctrl-right  x   $KEY_SHIFT_CTRL_RIGHT select      forward-word
    shift-ctrl-left   x   $KEY_SHIFT_CTRL_LEFT  select      backward-word

    end            kend   $KEY_END              unselect    end-of-line
    shift-end      kEND   $KEY_SHIFT_END        select      end-of-line

    home           khome  $KEY_HOME             unselect    beginning-of-line
    shift-home     kHOM   $KEY_SHIFT_HOME       select      beginning-of-line

    del               x   $KEY_DELETE           delselect   delete-char
    backspace         x   $KEY_BACKSPACE        delselect   backward-delete-char

    a                 x       'a'               insertchar  'a'
        b                 x       'b'               insertchar  'b'
    c                 x       'c'               insertchar  'c'
    d                 x       'd'               insertchar  'd'
    e                 x       'e'               insertchar  'e'
    f                 x       'f'               insertchar  'f'
    g                 x       'g'               insertchar  'g'
    h                 x       'h'               insertchar  'h'
    i                 x       'i'               insertchar  'i'
    j                 x       'j'               insertchar  'j'
    k                 x       'k'               insertchar  'k'
    l                 x       'l'               insertchar  'l'
    m                 x       'm'               insertchar  'm'
    n                 x       'n'               insertchar  'n'
    o                 x       'o'               insertchar  'o'
    p                 x       'p'               insertchar  'p'
    q                 x       'q'               insertchar  'q'
    r                 x       'r'               insertchar  'r'
    s                 x       's'               insertchar  's'
    t                 x       't'               insertchar  't'
    u                 x       'u'               insertchar  'u'
    v                 x       'v'               insertchar  'v'
    w                 x       'w'               insertchar  'w'
    x                 x       'x'               insertchar  'x'
    y                 x       'y'               insertchar  'y'
    z                 x       'z'               insertchar  'z'
    A                 x       'A'               insertchar  'A'
    B                 x       'B'               insertchar  'B'
    C                 x       'C'               insertchar  'C'
    D                 x       'D'               insertchar  'D'
    E                 x       'E'               insertchar  'E'
    F                 x       'F'               insertchar  'F'
    G                 x       'G'               insertchar  'G'
    H                 x       'H'               insertchar  'H'
    I                 x       'I'               insertchar  'I'
    J                 x       'J'               insertchar  'J'
    K                 x       'K'               insertchar  'K'
    L                 x       'L'               insertchar  'L'
    M                 x       'M'               insertchar  'M'
    N                 x       'N'               insertchar  'N'
    O                 x       'O'               insertchar  'O'
    P                 x       'P'               insertchar  'P'
    Q                 x       'Q'               insertchar  'Q'
    R                 x       'R'               insertchar  'R'
    S                 x       'S'               insertchar  'S'
    T                 x       'T'               insertchar  'T'
    U                 x       'U'               insertchar  'U'
    V                 x       'V'               insertchar  'V'
    W                 x       'W'               insertchar  'W'
    X                 x       'X'               insertchar  'X'
    Y                 x       'Y'               insertchar  'Y'
    Z                 x       'Z'               insertchar  'Z'
    0                 x       '0'               insertchar  '0'
    1                 x       '1'               insertchar  '1'
    2                 x       '2'               insertchar  '2'
    3                 x       '3'               insertchar  '3'
    4                 x       '4'               insertchar  '4'
    5                 x       '5'               insertchar  '5'
    6                 x       '6'               insertchar  '6'
    7                 x       '7'               insertchar  '7'
    8                 x       '8'               insertchar  '8'
    9                 x       '9'               insertchar  '9'

    exclamation-mark      x  '!'                insertchar  '!'
    hash-sign             x  '\#'               insertchar  '\#'
    dollar-sign           x  '$'                insertchar  '$'
    percent-sign          x  '%'                insertchar  '%'
    ampersand-sign        x  '\&'               insertchar  '\&'
    star                  x  '\*'               insertchar  '\*'
    plus                  x  '+'                insertchar  '+'
    comma                 x  ','                insertchar  ','
    dot                   x  '.'                insertchar  '.'
    forwardslash          x  '\\'               insertchar  '\\'
    backslash             x  '/'                insertchar  '/'
    colon                 x  ':'                insertchar  ':'
    semi-colon            x  '\;'               insertchar  '\;'
    left-angle-bracket    x  '\<'               insertchar  '\<'
    right-angle-bracket   x  '\>'               insertchar  '\>'
    equal-sign            x  '='                insertchar  '='
    question-mark         x  '\?'               insertchar  '\?'
    left-square-bracket   x  '['                insertchar  '['
    right-square-bracket  x  ']'                insertchar  ']'
    hat-sign              x  '^'                insertchar  '^'
    underscore            x  '_'                insertchar  '_'
    left-brace            x  '{'                insertchar  '{'
    right-brace           x  '\}'               insertchar  '\}'
    left-parenthesis      x  '\('               insertchar  '\('
    right-parenthesis     x  '\)'               insertchar  '\)'
    pipe                  x  '\|'               insertchar  '\|'
    tilde                 x  '\~'               insertchar  '\~'
    at-sign               x  '@'                insertchar  '@'
    dash                  x  '\-'               insertchar  '\-'
    double-quote          x  '\"'               insertchar  '\"'
    single-quote          x  "\'"               insertchar  "\'"
    backtick              x  '\`'               insertchar  '\`'
    whitespace            x  '\ '               insertchar  '\ '
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

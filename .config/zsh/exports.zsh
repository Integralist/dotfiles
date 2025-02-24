#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Otherwise tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# Homebrew
#
eval "$(/opt/homebrew/bin/brew shellenv)"

# NOTE:
# LSCOLOR is for BSD (i.e. macOS).
# LS_COLOR is for Linux.
#
# There are 11 attributes:
#
# directory
# symlink
# socket
# pipe
# executable
# special block
# special character
# executable setuid
# executable setgid
# dir_writeothers_sticky
# dir_writeothers_NOsticky
#
# Each attribute has a foreground/background colour.
#
# DOCUMENTATION:
#   - http://geoff.greer.fm/lscolors/
#   - https://www.cyberciti.biz/faq/apple-mac-osx-terminal-color-ls-output-option/
#
# COLOURS:
#   - directory: blue/white (eh)
#   - symlink: black/yellow (aD)
#   - executable: white/red (Hb)
#
# NOTE: The `tree` command requires an underscore version of LSCOLOR(S).
#
export LSCOLORS="ehaDxxxxHbxxxxxxxxxxxx"
export LS_COLORS="rs=0:di=36:ln=32:mh=00:pi=33:so=33:do=33:bd=00:cd=00:or=05;36:mi=04;93:su=31:sg=31:ca=00:tw=36:ow=36:st=36:ex=031:*.tar=00:*.tgz=00:*.arc=00:*.arj=00:*.taz=00:*.lha=00:*.lz4=00:*.lzh=00:*.lzma=00:*.tlz=00:*.txz=00:*.tzo=00:*.t7z=00:*.zip=00:*.z=00:*.dz=00:*.gz=00:*.lrz=00:*.lz=00:*.lzo=00:*.xz=00:*.zst=00:*.tzst=00:*.bz2=00:*.bz=00:*.tbz=00:*.tbz2=00:*.tz=00:*.deb=00:*.rpm=00:*.jar=00:*.war=00:*.ear=00:*.sar=00:*.rar=00:*.alz=00:*.ace=00:*.zoo=00:*.cpio=00:*.7z=00:*.rz=00:*.cab=00:*.wim=00:*.swm=00:*.dwm=00:*.esd=00:*.jpg=00:*.jpeg=00:*.mjpg=00:*.mjpeg=00:*.gif=00:*.bmp=00:*.pbm=00:*.pgm=00:*.ppm=00:*.tga=00:*.xbm=00:*.xpm=00:*.tif=00:*.tiff=00:*.png=00:*.svg=00:*.svgz=00:*.mng=00:*.pcx=00:*.mov=00:*.mpg=00:*.mpeg=00:*.m2v=00:*.mkv=00:*.webm=00:*.ogm=00:*.mp4=00:*.m4v=00:*.mp4v=00:*.vob=00:*.qt=00:*.nuv=00:*.wmv=00:*.asf=00:*.rm=00:*.rmvb=00:*.flc=00:*.avi=00:*.fli=00:*.flv=00:*.gl=00:*.dl=00:*.xcf=00:*.xwd=00:*.yuv=00:*.cgm=00:*.emf=00:*.ogv=00:*.ogx=00:*.aac=00:*.au=00:*.flac=00:*.m4a=00:*.mid=00:*.midi=00:*.mka=00:*.mp3=00:*.mpc=00:*.ogg=00:*.ra=00:*.wav=00:*.oga=00:*.opus=00:*.spx=00:*.xspf=00:";

# Application Configuration
#
export EDITOR="nvim"
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_DEFAULT_COMMAND="rg --hidden --no-ignore --files"
export FZF_DEFAULT_OPTS='--style="full" --multi --ansi --preview="bat --color=always {}" --preview-window=right:50%:wrap'
export GPG_TTY=$tty_instance # tell gpg which terminal to use when prompting for a passphrase (set in ~/.zshrc)
export GREP_COLOR="1;32"
export GREP_OPTIONS="--color=auto"
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page

# DISABLED: I'm using ghostty now with neovim and not vim or tmux anymore.
# export TERM="xterm-256color" # avoid "terminals database is inaccessible" and not being able to run `clear` command (also fixes tmux/vim colour issues).
# export TERMINFO=/usr/share/terminfo

export TIMEFORMAT="$(printf '\n\e[01;31m')elapsed:$(printf '\e[00m') %Rs, $(printf '\e[01;33m')user mode (cpu time):$(printf '\e[00m') %U, $(printf '\e[01;32m')system mode (cpu time):$(printf '\e[00m') %S"

# DISABLED:
# This tells pinentry to use a terminal-based interface (not the OS UI prompt).
# I disabled as I prefer the OS prompt, as it doesn't block my terminal.
# The OS prompt typically hovers above the terminal.
#
# export PINENTRY_USER_DATA="USE_CURSES=1"

# Git Specific Configurations
#
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true     # * for unstaged changes (+ staged but uncommitted changes)
export GIT_PS1_SHOWSTASHSTATE=true     # $ for stashed changes
export GIT_PS1_SHOWUNTRACKEDFILES=true # % for untracked files
export GIT_PS1_SHOWUPSTREAM="auto"     # > for local commits on HEAD not pushed to upstream
                                       # < for commits on upstream not merged with HEAD
                                       # = HEAD points to same commit as upstream

# History Configuration
#
# NOTE: This can partially be controlled by Readline directly using ~/.inputrc
#
export HISTSIZE=500000

# Man Pages Colour Configuration
# https://www.tuxarena.com/2012/04/tutorial-colored-man-pages-how-it-works/
#
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode – red
export LESS_TERMCAP_md=$(printf '\e[01;33m') # enter double-bright mode – bold, yellow
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode – yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;31m') # enter underline mode – red

# PATH Modifications
#
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"                                            # rust executables
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"                                  # ruby executables
export PATH="$HOME/bin:$PATH"                                                   # terraform executables (via tfswitch)
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH" # yarn executables

# IMPORTANT: We MUST assign the modified path to a new environment variable.
# The parent scope (~/.zshrc) will then prefix it to its current path value.
export MODIFIED_PATH="$PATH"

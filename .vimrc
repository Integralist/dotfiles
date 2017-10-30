" Included because loading inside of Linux caused error:
" E474: Invalid argument: listchars=tab:»·,trail:·
scriptencoding utf-8
set encoding=utf-8

" Use the system clipboard
set clipboard+=unnamed

" Switch syntax highlighting on
syntax on

" Don't worry about trying to support old school Vi features
set nocompatible

" Disable Mouse (this is something that only recently affected me within NeoVim)
" Seemed using the mouse to select some text would make NeoVim jump into VISUAL mode?
set mouse=

" No backup files
set nobackup

" No write backup
set nowritebackup

" No swap file
set noswapfile

" Command history
set history=100

" Always show cursor
set ruler

" Show incomplete commands
set showcmd

" Incremental searching (search as you type)
set incsearch

" Highlight search matches
set hlsearch

" Ignore case in search
set smartcase

" DISABLED: realised that case insensitive searches can return TOO MANY results
"           easier to be a case sensitive search and just use \c on the end if I didn't care
" Make sure any searches /searchPhrase doesn't need the \c escape character
" set ignorecase

" Try to intelligently indent when creating a newline
set smartindent

" A buffer is marked as ‘hidden’ if it has unsaved changes, and it is not currently loaded in a window
" If you try and quit Vim while there are hidden buffers, you will raise an error:
" E162: No write since last change for buffer “a.txt”
set hidden

" Turn word wrap off
set nowrap

" Allow backspace to delete end of line, indent and start of line characters
set backspace=indent,eol,start

" Convert tabs to spaces
set expandtab

" Set tab size in spaces (this is for manual indenting)
set tabstop=2

" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=2

" Turn on line numbers
set number

" Highlight tailing whitespace
set list listchars=tab:\ \ ,trail:·

" Get rid of the delay when pressing O (for example)
" http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
set timeout timeoutlen=1000 ttimeoutlen=100

" Always show status bar
set laststatus=2

" Set the status line to something useful
set statusline=%f\ %m\ %=L:%l/%L\ C:%c\ (%p%%)

" UTF encoding
set encoding=utf-8

" Autoload files that have changed outside of vim
set autoread

" Better splits (new windows appear below and to the right)
set splitbelow
set splitright

" Highlight the current line
set cursorline

" DISABLED: decided it was less noisy justlooking at line number highlighted
fun! SetCursorLine()
  " http://misc.flogisoft.com/_media/bash/colors_format/256_colors_bg.png
  highlight CursorLine cterm=NONE ctermbg=214 ctermfg=darkred
endfun
" autocmd VimEnter * call SetCursorLine() " We have to use a last minute event (VimEnter)
                                          " Otherwise the colourscheme overrides our CursorLine

" Ensure Vim doesn't beep at you every time you make a mistype
set visualbell

" Visual autocomplete for command menu (e.g. :e ~/path/to/file)
set wildmenu

" Redraw only when we need to (i.e. don't redraw when executing a macro)
set lazyredraw

" Highlight a matching [{()}] when cursor is placed on start/end character
set showmatch

" <C-x><C-k> for word autocomplete
set dictionary=/usr/share/dict/words

" Use Ag for :grep command (would use Sift but it doesn't work well)
set grepprg=ag\ --nogroup\ --nocolor

" Allow substitutions to dynamically be represented in the buffer
" https://asciinema.org/a/92207
:silent! set inccommand=nosplit

" Allow per-project configuration files
" See also `set secure` at the bottom of this file
" https://andrew.stwrt.ca/posts/project-specific-vimrc/
set exrc

" Use git alias inside ~/.gitconfig to open current file line in GitHub
nnoremap <leader>f :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>

" NetRW settings (see :NetrwSettings)
let g:netrw_winsize=-35 " Negative value is absolute; Positive is percentage (related to above mapping)
let g:netrw_localrmdir='rm -r' " Allow netrw to remove non-empty local directories
let g:netrw_fastbrowse=0 " Always re-evaluate directory listing
let g:netrw_hide=0 " Show ALL files
let g:netrw_list_hide= '^\.git,^\.DS_Store$' " Ignore certain files and directories
let g:netrw_sizestyle="h" " Human readable file sizes
let g:netrw_liststyle=3 " Set built-in file system explorer to use layout similar to the NERDTree plugin
                        " P opens file in previously focused window
                        " o opens file in new horizontal split window
                        " v opens file in new vertical split window
                        " t opens file in new tab split window

" Plugin Managment
" https://github.com/junegunn/vim-plug#example
"
" Reload .vimrc and :PlugInstall to install plugins.
" Use single quotes as requested by vim-plug.
"
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'chr4/nginx.vim'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'ekalinin/Dockerfile.vim'
Plug 'endel/vim-github-colorscheme'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go'
Plug 'fcpg/vim-fahrenheit'
Plug 'godlygeek/tabular'
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'integralist/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'jamessan/vim-gnupg'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'kana/vim-textobj-user'
Plug 'kien/rainbow_parentheses.vim', { 'for': 'clojure' }
Plug 'm-kat/aws-vim'
Plug 'matze/vim-move'
Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' }
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'nvie/vim-flake8', { 'for': 'python' }
Plug 'othree/html5.vim'
Plug 'plasticboy/vim-markdown'
Plug 'robertmeta/nofrils'
Plug 'sheerun/vim-polyglot'
Plug 'shougo/unite.vim'
Plug 'shougo/vimfiler.vim'
Plug 'smerrill/vcl-vim-plugin'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise', { 'for': 'ruby' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-leiningen', { 'for': 'clojure' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
Plug 'tpope/vim-surround'
Plug 'vim-scripts/Gist.vim'
Plug 'vim-scripts/camelcasemotion'
Plug 'w0rp/ale'

" Initialize plugin system
call plug#end()

" Colour Scheme
let g:default_theme="gruvbox"
set background=dark
execute 'colorscheme ' . g:default_theme

" ALE linting
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

" vim-go
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

" we use nsf/gocode & vim-go (which uses gocode) to handle autocomplete
" we setup insert mode to allow us to use a double forward slash for autocomplete
" opens a "preview" (i.e. scratch) window which can be closed using `pc`, `pclose`
autocmd FileType go imap // <C-x><C-o>

" tabular
map <Leader>e :Tabularize /=<CR>
map <Leader>c :Tabularize /:<CR>
map <Leader>es :Tabularize /=\zs<CR>
map <Leader>cs :Tabularize /:\zs<CR>

" FZF (search files)
"
" Shift-Tab to select multiple files
"
" Ctrl-t = tab
" Ctrl-x = split
" Ctrl-y = vertical
map <leader>t :FZF<CR>
map <leader>y :Buffers<CR>
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*.,*/.DS_Store " Files matched are ignored when expanding wildcards

" ack
let g:ackprg = 'ag --vimgrep --smart-case'

" vim-textobj-rubyblock
runtime macros/matchit.vim

" vim-commentary
xmap <leader><leader><leader> <Plug>Commentary
nmap <leader><leader><leader> <Plug>Commentary
omap <leader><leader><leader> <Plug>Commentary
nmap <leader><leader><leader> <Plug>CommentaryLine

" gist
let g:github_user = $GITHUB_USER
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" camelcase
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

" vim-move (<C-j>, <C-k> to move lines around more easily than :move)
let g:move_key_modifier = 'C'

" nofrils colorscheme
let g:nofrils_strbackgrounds=1 " enable highlighting of strings and mispellings

" shortcut for quick terminal exit
:silent! tnoremap <Esc> <C-\><C-n>

" Auto Commands
" :h autocommand-events

fun! StripTrailingWhitespace()
  " Don't strip on these filetypes
  if &ft =~ 'markdown'
    return
  endif
  %s/\s\+$//e
endfun
autocmd BufWritePre * call StripTrailingWhitespace()

autocmd FileType gitcommit setlocal spell textwidth=72
autocmd FileType markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
autocmd FileType sh,cucumber,ruby,yaml,zsh,vim setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType php,python setlocal shiftwidth=4 tabstop=4 expandtab

" See `:h fo-table` for details of formatoptions `t` to force wrapping of text
autocmd FileType python,ruby,go,sh,javascript setlocal textwidth=79 formatoptions+=t

" " DISABLED: it was causing status plugin styles to be destroyed
" " If you were to manually source the vimrc then the status styles would return
" " Tried to automate via execute command but didn't work
" "
" " Set different colorscheme for Bash and VimL scripts
" " autocmd BufEnter *.sh,*.vimrc,*.txt execute 'colorscheme github' | execute ':source $MYVIMRC'
" " autocmd BufLeave *.sh,*.vimrc,*.txt execute 'set background=dark' | execute 'colorscheme ' . g:default_theme

" Specify syntax highlighting for specific files
autocmd BufRead,BufNewFile *.spv set filetype=php
autocmd BufRead,BufNewFile *.md set filetype=markdown " Vim interprets .md as 'modula2' otherwise, see :set filetype?

" " DISABLED: Run Goyo plugin on Markdown files for when I'm writing blog posts
" autocmd BufRead,BufEnter *.md execute 'normal zR' | execute 'Goyo'
" autocmd BufLeave *.md execute 'Goyo!'

" " DISABLED: Automatically reload vimrc when it's saved
" " autocmd BufWritePost .vimrc so ~/.vimrc

" Rainbow parentheses always on for Clojure scripts
autocmd VimEnter *.clj if exists(':RainbowParenthesesToggle') | exe ":RainbowParenthesesToggleAll" | endif

" Change colourscheme when diffing
fun! SetDiffColours()
  highlight DiffAdd    cterm=bold ctermfg=white ctermbg=DarkGreen
  highlight DiffDelete cterm=bold ctermfg=white ctermbg=DarkGrey
  highlight DiffChange cterm=bold ctermfg=white ctermbg=DarkBlue
  highlight DiffText   cterm=bold ctermfg=white ctermbg=DarkRed
endfun
autocmd FilterWritePre * call SetDiffColours()

" Map § key to :nohlsearch (or :noh for short)
map § :nohlsearch<CR>

" Tell Vim how many colours are available
let &t_Co=256

" This will prevent :autocmd, shell and write commands from
" being run inside project-specific .vimrc files (unless they’re owned by you).
set secure

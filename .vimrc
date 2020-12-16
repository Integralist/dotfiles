scriptencoding utf-8

" character encoding
set encoding=utf-8
" stops odd issues like using arrow keys in insert mode will send key sequences that are misinterpreted by vi
set nocompatible
" stop Vim from beeping at you when you make a mistake
set visualbell
" use system clipboard (to enable copy/paste between vim and other applications)
set clipboard+=unnamed
" set tab size in spaces (this is for manual indenting)
set tabstop=2
" the number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=2
" turn on line numbers
set number
" highlight the current line
set cursorline
" convert tabs to spaces
set expandtab
" highlight all search matches
set hlsearch
" search as you type
set incsearch
" don't create backup files
set nobackup
" have swap files be stored out of site
set directory^=$HOME/.vim/tmp//
" indicate the line,column numbers in status
set ruler
" display incomplete commands
set showcmd
" case insensitive search (if turned off then append \c to search phrase instead)
set ignorecase
" use case sensitive search if uppercase character is in search phrase
set smartcase
" indent a newline based on current file type
set smartindent
" ensure hidden buffers that have unsaved changes aren't lost when closing vim
set hidden
" don't wrap lines
set nowrap
" enable backspace for deleting
set backspace=indent,eol,start
" convert tabs to spaces
set expandtab
" set tab size in spaces (this is for manual indenting)
set tabstop=2
" always display the statusline (default is 1 and only shows statusline when more than one window)
set laststatus=2
" tweak the statusline
set statusline=%f\ %m\ %=L:%l/%L\ C:%c\ (%p%%)
" auto-update files updated outside of vim
set autoread
" new split window will appear below current window
set splitbelow
" ensure vertical split windows appear on the right
set splitright
" visual autocomplete for command menu
set wildmenu
" only redraw when necessary
set lazyredraw
" highlight matching characters
set showmatch
" comma-separated list of paths for determining where to lookup words for autocomplete
set dictionary=/usr/share/dict/words
" use silver searcher for vim grep
set grepprg=ag\ --nogroup\ --nocolor
" activate spell checking
set spell

" dynamic substitutions (replace while typing) only works for neovim currently so use silent! until vim supports
:silent! set inccommand=nosplit

" recent update to Vim 8 broke gx command (that opens URL in web browser)
" it should use the `open` command (provided by macOS, not the shell builtin).
nmap gx yiW:!open <cWORD><CR> <C-r>" & <CR><CR>

" make disabling search highlights easier
map ± :nohlsearch<CR>

" Auto Commands
" :h autocommand-events
"
fun! StripTrailingWhitespace()
  " don't strip on these filetypes
  if &ft =~ 'markdown' || &ft =~ 'terraform' || &ft =~ 'go'
    return
  endif
  %s/\s\+$//e
endfun

fun! SetDiffColours()
  highlight DiffAdd    cterm=bold ctermfg=white ctermbg=DarkGreen
  highlight DiffDelete cterm=bold ctermfg=white ctermbg=DarkGrey
  highlight DiffChange cterm=bold ctermfg=white ctermbg=DarkBlue
  highlight DiffText   cterm=bold ctermfg=white ctermbg=DarkRed
endfun

autocmd BufWritePre * call StripTrailingWhitespace()
autocmd BufWritePost *.tf :!terraform fmt %
autocmd BufRead,BufNewFile *.md set filetype=markdown " vim interprets .md as 'modula2' otherwise, see :set filetype?
autocmd FilterWritePre * call SetDiffColours()
autocmd FileType gitcommit setlocal spell textwidth=72
autocmd FileType markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
autocmd FileType sh,ruby,yaml,vim setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType python setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType python,ruby,go,sh,javascript setlocal textwidth=79 formatoptions+=t " see `:h fo-table` for details of formatoptions `t` to force wrapping of text

" Plugin Managment
" https://github.com/junegunn/vim-plug#example
"
" Reload .vimrc and :PlugInstall to install plugins.
" Use single quotes as requested by vim-plug.
"
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'jelera/vim-javascript-syntax'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' " <Tab> to select multiple results
Plug 'matze/vim-move'
Plug 'mileszs/ack.vim'
Plug 'nvie/vim-flake8', { 'for': 'python' }
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'sheerun/vim-polyglot'
Plug 'smerrill/vcl-vim-plugin'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Colorschemes
Plug 'arcticicestudio/nord-vim'
Plug 'endel/vim-github-colorscheme'
Plug 'hzchirs/vim-material'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/edge'
call plug#end()

syntax enable

" Dark Theme
"
"
autocmd vimenter * colorscheme nord " NOTE: requires Nord terminal theme.
set background=dark

" Light Theme
"
" colorscheme github
" set background=light

" Plugin Configuration
"
" SuperTab
" have selection start at top of the list instead of the bottom
let g:SuperTabDefaultCompletionType = "<c-n>"

" ALE linting
"
" go vet options depends on installing extra command:
"
"   $ go install golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow
"
" ...just be sure to run that install outside of your projects directory,
" otherwise it'll add dependencies to your project go.mod accidentally.
"
let g:ale_go_govet_options = '-vettool=$(which shadow)'
let g:ale_linters = {'go': ['gopls']}
let g:ale_python_mypy_options = '--ignore-missing-imports --strict-equality'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '▲'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

nmap <silent> <leader>x :ALENext<cr>
nmap <silent> <leader>z :ALEPrevious<cr>

" vim-go
let g:go_fmt_command = 'goimports'
let g:go_gopls_complete_unimported = 1
let g:go_gopls_staticcheck = 1
let g:go_metalinter_command='gopls'
let g:go_metalinter_deadline = '20s'

" :h go-syntax
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

" vim-go: check if any expressions return an error type that aren't being handled
autocmd BufWritePost *.go :GoErrCheck! -ignoretests

" FZF (search files)
"
" Shift-Tab to select multiple files
"
" Ctrl-t = tab
" Ctrl-x = split
" Ctrl-v = vertical
"
" We can also set FZF_DEFAULT_COMMAND in ~/.bashrc
" Also we can use --ignore-dir multiple times
"
" Note use :map command to see current mappings (also :vmap, :nmap, :omap).
" Can also restrict to specific mapping `:map <Leader>w`
" https://vi.stackexchange.com/questions/7722/how-to-debug-a-mapping
map <leader>f :FZF!<CR>
map <leader>b :Buffers!<CR>
map <leader>g :GFiles!?<CR>
map <leader>w :Windows!<CR>
map <leader>t :AgC!<CR>
set wildignore+=*/.git/*,*/node_modules/*,*/.hg/*,*/.svn/*.,*/.DS_Store " Files matched are ignored when expanding wildcards
set wildmode=list:longest,list:full

" configure FZF text search command to have default flags included
autocmd VimEnter * command! -nargs=* -bang AgC call fzf#vim#ag(<q-args>, '--ignore "node_modules" --ignore-dir="vendor"', <bang>0)

" ack
let g:ackprg = 'ag --vimgrep --smart-case --ignore-dir=node_modules --ignore-dir=vendor'

" vim-commentary
xmap <leader><leader><leader> <Plug>Commentary
nmap <leader><leader><leader> <Plug>Commentary
omap <leader><leader><leader> <Plug>Commentary
nmap <leader><leader><leader> <Plug>CommentaryLine

" vim-move (<C-j>, <C-k> to move lines around more easily than :move)
let g:move_key_modifier = 'C'

" make closing a :terminal split easier (<Esc>+:q)
silent! tnoremap <Esc> <C-\><C-n>

" netrw
let g:netrw_list_hide= '.*\.swp$'

" NOTES:
"
" when browsing with built-in file explorer (netrw) the following keys are useful to remember:
" - P opens file in previously focused window
" - o opens file in new horizontal split window
" - v opens file in new vertical split window
" - t opens file in new tab split window
"

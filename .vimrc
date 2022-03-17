" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" NOTES
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"
" - Configuration
" - Auto Commands
" - Plugin Management
" - Color Schemes
" - Plugin Configuration
" - File Explorer Configuration
"
" To view all custom leader (\) mappings:
" :verbose map <leader>
"

" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" Configuration
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"
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
" don't use swap files
set noswapfile
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
" allow for extra context when scrolling (e.g. pad above/below current line)
set scrolloff=5
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
set grepprg=ag\ --nogroup\ --nocolor\ --skip-vcs-ignores
" activate spell checking
set spell
" display pipe character for any tabs
set list lcs=tab:\|-

" allow filtering of quickfix/location list window results
" :help cfilter-plugin
:packadd cfilter

" recent update to Vim 8 broke gx command (that opens URL in web browser)
" it should use the `open` command provided by macOS (not the shell builtin).
nmap gx yiW:!open <cWORD><CR> <C-r>" & <CR><CR>

" make disabling search highlights easier
map ± :nohlsearch<CR>

" quick jump to Ack command which I use all the time
map <leader>a :Ack! ''

" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" Auto Commands
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"
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

autocmd BufRead,BufNewFile *.md :MuttonToggle
autocmd BufRead,BufNewFile *.md set filetype=markdown " vim interprets .md as 'modula2' otherwise, see :set filetype?
autocmd BufWritePost *.tf :!terraform fmt %
autocmd BufWritePre * call StripTrailingWhitespace()
autocmd FileType gitcommit setlocal spell textwidth=72
autocmd FileType markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
autocmd FileType python setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType python,ruby,go,sh,javascript setlocal textwidth=79 formatoptions+=t " see `:h fo-table` for details of formatoptions `t` to force wrapping of text
autocmd FileType sh,ruby,yaml,vim setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FilterWritePre * call SetDiffColours()
autocmd! BufWritePost ~/.vimrc source ~/.vimrc " auto source vimrc changes

" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" Plugin Management
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"
" https://github.com/junegunn/vim-plug#example
"
" Reload .vimrc and :PlugInstall to install plugins.
" Use single quotes as requested by vim-plug.
"
call plug#begin('~/.vim/plugged')

" Code Linter
Plug 'dense-analysis/ale'

" Go Programming Language
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Markdown sidebars
Plug 'gabenespoli/vim-mutton'

" Text alignment
Plug 'godlygeek/tabular'

" Display number of search matches
Plug 'google/vim-searchindex'

" Status bar enhancement
Plug 'itchyny/lightline.vim'

" JavaScript Programming Language Syntax Highlighter
Plug 'jelera/vim-javascript-syntax'

" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' " <Tab> to select multiple results

" Run, view, and manage UNIX shell commands
Plug 'ledesmablt/vim-run'

" Highlight the yanked region
Plug 'machakann/vim-highlightedyank'

" Substitution live preview (until Vim supports inccommand=nosplit)
Plug 'markonm/traces.vim'

" Move lines and selections up and down
Plug 'matze/vim-move'

" Text search
Plug 'mileszs/ack.vim'

" Communicate with Language Servers
Plug 'natebosch/vim-lsc'

" Python Linter
Plug 'nvie/vim-flake8', { 'for': 'python' }

" Python requirements.txt Syntax Highlighter
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

" Search Dash.app
Plug 'rizzatti/dash.vim'

" Open GitHub links in web browser
Plug 'ruanyl/vim-gh-line'

" Rust Programming Language
Plug 'rust-lang/rust.vim'

" Go Debugging
Plug 'sebdah/vim-delve'

" Programming Languages Syntax Highlighter
Plug 'sheerun/vim-polyglot'

" VCL Syntax Highlighter
Plug 'smerrill/vcl-vim-plugin'

" Code Comments
Plug 'tpope/vim-commentary'

" Normalises repeat operator
Plug 'tpope/vim-repeat'

" Change surrounding characters
Plug 'tpope/vim-surround'

" Highlights matches for f/F and t/T operators
Plug 'unblevable/quick-scope'

" Display indentation levels
Plug 'Yggdroot/indentLine'

" Display git blame in status bar
Plug 'zivyangll/git-blame.vim'

" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" Color Schemes
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"
" NOTE: nord-vim requires Nord terminal theme.
"
Plug 'arcticicestudio/nord-vim'
Plug 'endel/vim-github-colorscheme'
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'
call plug#end()

syntax enable

autocmd VimEnter * colorscheme gruvbox
set background=dark

function DarkTheme()
  colorscheme gruvbox
  set background=dark
endfunction

function LightTheme()
  colorscheme github
  set background=light
endfunction

nmap <leader>cd :call DarkTheme()<CR>
nmap <leader>cl :call LightTheme()<CR>

" Configure the highlighted Vim tab
"
" NOTE: This must come after the colorscheme change otherwise we'll end up
" unsetting the tab highlighting.
"
autocmd VimEnter * hi TabLineSel ctermfg=Red ctermbg=Yellow

" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" Plugin Configuration
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

" ------------------------------------
" itchyny/lightline.vim
" ------------------------------------
"
" I turn off the 'mode' indicator as otherwise it'll be duplicated by the plugin.
" I also tweak the status colorscheme to fit my vim theme (see :h g:lightline.colorscheme).
"
" Lastly, I have to turn off the tabline configuration that comes with the
" plugin as I don't find it useful (it's almost impossible to see what tab is
" highlighted!) and so I set that myself using Vim's TabLineSel.
"
set noshowmode
let g:lightline = {'colorscheme': 'powerlineish'}
let g:lightline.enable = {'tabline': 0}

" ------------------------------------
" dense-analysis/ale
" ------------------------------------
"
" go vet options depends on installing extra command:
"
"   $ go install golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow
"
" ...just be sure to run that install outside of your projects directory,
" otherwise it'll add dependencies to your project go.mod accidentally.
"
let g:ale_go_govet_options = '-vettool=$(which shadow)'
let g:ale_linters = {'go': ['gopls'], 'rust': ['cargo', 'analyzer']} " disabled golang staticcheck because of false positives (e.g. it would show errors about references not being defined, when they exist in the same package but in a different file)
let g:ale_python_mypy_options = '--ignore-missing-imports --strict-equality'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '▲'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title
nmap <silent> <leader>x :ALENext<cr>
nmap <silent> <leader>z :ALEPrevious<cr>

" ------------------------------------
" ledesmablt/vim-run
" ------------------------------------
let g:run_use_loclist = 1

" ------------------------------------
" fatih/vim-go
" ------------------------------------
"
" :h go-syntax
"
let g:go_fmt_command = 'goimports'
let g:go_gopls_complete_unimported = 1
let g:go_gopls_staticcheck = 1
let g:go_metalinter_command='gopls'
let g:go_metalinter_deadline = '20s'
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1
autocmd FileType go map <buffer> <leader>p :call append(".", "fmt.Printf(\"\\n\\n%+v\\n\\n\", )")<CR> <bar> :norm $a<CR><esc>==
autocmd FileType go map <buffer> <leader>e :call append(".", "if err != nil {return err}")<CR> <bar> :w<CR>

" Check if any expressions return an error type that aren't being handled
"
" DISABLED (too noisy)
"
" autocmd BufWritePost *.go :GoErrCheck! -ignoretests

" ------------------------------------
" natebosch/vim-lsc
" ------------------------------------
let g:lsc_server_commands = {'rust': 'rust-analyzer', 'go': 'gopls'}
let g:lsc_auto_map = v:true
autocmd CompleteDone * silent! pclose

" ------------------------------------
" junegunn/fzf
" junegunn/fzf.vim
" ------------------------------------
"
" Shift-Tab to select multiple files
"
" Ctrl-t = tab
" Ctrl-x = split
" Ctrl-v = vertical
"
" We also set FZF_DEFAULT_COMMAND in ~/.bashrc to use `ag` (aka The Silver Searcher).
" As part of the configuartion we set --ignore-dir multiple times.
" We also set --hidden which enables searching hidden directories (like .github).
" The --hidden flag will still respect a .ignore file (which is where we typically ignore things like .git).
" NOTE: you need `--path-to-ignore ~/.ignore` otherwise ag only uses a local ignore file `./.ignore`.
"
" Use :map command to see current mappings (also :vmap, :nmap, :omap).
" Can also restrict to specific mapping `:map <Leader>w`
" https://vi.stackexchange.com/questions/7722/how-to-debug-a-mapping
"
" NOTE: append ! to command (e.g. :FZF vs :FZF! or place it just before the ?
" in the case of :GFiles!?) to have preview open full screen.
"
map <leader>f :FZF<CR>
map <leader>b :Buffers<CR>
map <leader>g :GFiles?<CR>
map <leader>w :Windows<CR>
map <leader>l :Lines<CR>
map <leader>t :AgC<CR>
set wildignore+=*/.git/*,*/node_modules/*,*/.hg/*,*/.svn/*.,*/.DS_Store " Files matched are ignored when expanding wildcards
set wildmode=list:longest,list:full

" configure FZF text search command to have default flags included
autocmd VimEnter * command! -nargs=* -bang AgC call fzf#vim#ag(<q-args>, '--path-to-ignore ~/.ignore --hidden --ignore "node_modules" --ignore-dir="vendor" --skip-vcs-ignores', <bang>0)

" ------------------------------------
" mileszs/ack.vim
" ------------------------------------
let g:ackprg = 'ag --vimgrep --smart-case --path-to-ignore ~/.ignore --hidden --ignore-dir=node_modules --ignore-dir=vendor --skip-vcs-ignores'

" help Ack mappings to respect my split settings
let g:ack_mappings = {
  \ "h": "<C-W><CR>:exe 'wincmd ' (&splitbelow ? 'J' : 'K')<CR><C-W>p<C-W>J<C-W>p",
  \ "v": "<C-W><CR>:exe 'wincmd ' (&splitright ? 'L' : 'H')<CR><C-W>p<C-W>J<C-W>p"}

" ------------------------------------
" tpope/vim-commentary
" ------------------------------------
xmap <leader><leader><leader> <Plug>Commentary
nmap <leader><leader><leader> <Plug>Commentary
omap <leader><leader><leader> <Plug>Commentary
nmap <leader><leader><leader> <Plug>CommentaryLine

" ------------------------------------
" zivyangll/git-blame.vim
" ------------------------------------
"
" <leader>gb will open in the browser,
" while the following mapping opens it
" in the status bar as a single line.
"
nnoremap <leader><leader>b :<C-u>call gitblame#echo()<CR>

" ------------------------------------
" matze/vim-move
" ------------------------------------
"
" <C-j>, <C-k> to move lines around more easily than :move
"
let g:move_key_modifier = 'C'

" ------------------------------------
" Yggdroot/indentLine
" ------------------------------------
"
" Prevent breaking markdown files.
"
let g:vim_markdown_conceal = 0
let g:indentLine_fileTypeExclude = ['markdown']
let g:indentLine_concealcursor = "nv"

" ------------------------------------
" rust-lang/rust.vim
" ------------------------------------
let g:rustfmt_autosave = 1
autocmd FileType rust map <buffer> <leader><leader>b :Cbuild<CR>
autocmd FileType rust map <buffer> <leader><leader>c :Ccheck<CR>
autocmd FileType rust map <buffer> <leader><leader>r :Crun<CR>

" ------------------------------------
" dash
" ------------------------------------
"
" https://kapeli.com/dash
"
:nmap <silent> <leader>d <Plug>DashSearch

" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" File Explorer Configuration
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"
" NOTES:
"
" when browsing with built-in file explorer (netrw) the following keys are useful to remember:
" - P opens file in previously focused window
" - o opens file in new horizontal split window
" - v opens file in new vertical split window
" - t opens file in new tab split window
"
let g:netrw_list_hide= '.*\.swp$,.*\.DS_Store'

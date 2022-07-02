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
set directory^=$HOME/.config/nvim/swap//
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
" determine how quickfix items are opened
set switchbuf=uselast
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
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c
" Substitution live preview
set inccommand=split
" Disables the following message:
" Streaming logs to an output buffer is not supported in Neovim. All commands will default to RunNoStream.
let g:run_nostream_default = 1

" allow filtering of quickfix/location list window results
" :help cfilter-plugin
:packadd cfilter

" make disabling search highlights easier
map ± :nohlsearch<CR>

" quick jump to Ack command which I use all the time
map <leader>a :Ack! ''

" Make closing terminal simple
"
" NOTE: We have to use <leader> before <Esc> otherwise Telescope's <Esc> will be overridden.
tnoremap <leader><Esc> <C-\><C-n>

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

autocmd! BufWritePost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim " auto source vimrc changes
autocmd BufRead,BufNewFile *.md set filetype=markdown " vim interprets .md as 'modula2' otherwise, see :set filetype?
autocmd BufWritePre * call StripTrailingWhitespace()
autocmd FileType gitcommit setlocal spell textwidth=72
autocmd FileType markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
autocmd FileType python setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType python,ruby,go,sh,javascript setlocal textwidth=79 formatoptions+=t " see `:h fo-table` for details of formatoptions `t` to force wrapping of text
autocmd FileType sh,ruby,yaml,vim setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FilterWritePre * call SetDiffColours()

" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" Plugin Management
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"
" https://github.com/junegunn/vim-plug#example
"
" Reload ~/.config/nvim/init.vim and :PlugInstall to install plugins.
" Use single quotes as requested by vim-plug.
"
call plug#begin()

" Better word motions for programming.
Plug 'bkad/CamelCaseMotion'

" Inactive Window Highlighter
Plug 'blueyed/vim-diminactive'

" Code Linter
Plug 'dense-analysis/ale'

" Markdown sidebars
Plug 'gabenespoli/vim-mutton'

" Text alignment
Plug 'godlygeek/tabular'

" Display number of search matches
Plug 'google/vim-searchindex'

" JavaScript Programming Language Syntax Highlighter
Plug 'jelera/vim-javascript-syntax'

" Run, view, and manage UNIX shell commands
Plug 'ledesmablt/vim-run'

" Highlight the yanked region
Plug 'machakann/vim-highlightedyank'

" Move lines and selections up and down
Plug 'matze/vim-move'

" Text search
Plug 'mileszs/ack.vim'

" Python Linter
Plug 'nvie/vim-flake8', { 'for': 'python' }

" Python requirements.txt Syntax Highlighter
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

" Open GitHub links in web browser
Plug 'ruanyl/vim-gh-line'

" Go Debugging
Plug 'sebdah/vim-delve'

" Programming Languages Syntax Highlighter
Plug 'sheerun/vim-polyglot'

" VCL Syntax Highlighter
Plug 'smerrill/vcl-vim-plugin'

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
" Neovim Specific Plugins
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

" Preconfigured snippets for multiple programming languages.
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

" Completion framework
Plug 'hrsh7th/nvim-cmp'

" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'

" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'

" Other useful completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'

" Complete for signature arguments
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'

" Better syntax highlighting with Treesitter and friends
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'm-demare/hlargs.nvim'

" File explorer
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Status bar
Plug 'nvim-lualine/lualine.nvim'

" Git integration for buffers
Plug 'lewis6991/gitsigns.nvim'

" Git Diff Viewer
Plug 'nvim-lua/plenary.nvim'
Plug 'sindrets/diffview.nvim'

function! UpdateRemotePlugins(...)
  " refresh runtime files
  let &rtp=&rtp
  UpdateRemotePlugins
endfunction

" A more adventurous wildmenu
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }

" Preview register content
Plug 'tversteeg/registers.nvim', { 'branch': 'main' }

" Standalone UI for nvim-lsp progress
Plug 'j-hui/fidget.nvim'

" Lightbulb indicator for LSP 'code actions'
Plug 'kosayoda/nvim-lightbulb'

" Pop-up menu for code actions
Plug 'weilbith/nvim-code-action-menu'

" Pretty diagnostics, references, quickfix and location list
Plug 'folke/trouble.nvim'

" Displays interactive vertical scrollbars
"
" DISABLED: As it breaks mksession (https://github.com/dstein64/nvim-scrollview/issues/71)
"
" Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }

" Improve spell checking based on file context
"
" Plug 'lewis6991/spellsitter.nvim'

" Displays popup window for available key bindings
Plug 'folke/which-key.nvim'

" Improve default vim.ui interfaces
Plug 'stevearc/dressing.nvim'

" Creates missing LSP diagnostics highlight groups for color schemes that don't yet support the Neovim 0.5 builtin LSP client
Plug 'folke/lsp-colors.nvim'

" Find, Filter, Preview, Pick
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Markdown header search
Plug 'crispgm/telescope-heading.nvim'

" Search Dash app from Telescope
" https://kapeli.com/dash
Plug 'mrjones2014/dash.nvim', { 'do': 'make install' }

" Search emojis from Telescope
Plug 'xiyaowong/telescope-emoji.nvim'

" Search windows from Telescope
Plug 'kyoh86/telescope-windows.nvim'

" Search changed files from Telescope
Plug 'axkirillov/telescope-changed-files'

" Code Comments
Plug 'b3nj5m1n/kommentary'

" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" Color Schemes
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"
" NOTE: nord-vim requires Nord terminal theme.
"
Plug 'NLKNguyen/papercolor-theme'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'EdenEast/nightfox.nvim'
Plug 'endel/vim-github-colorscheme'
Plug 'morhetz/gruvbox'
call plug#end()

" remove default vim colorschemes
"
silent !rm $VIMRUNTIME/colors/*.vim &> /dev/null

" enable 24bit true color
if (has("termguicolors"))
 set termguicolors
endif

syntax enable

" allow background terminal color to come through
highlight Normal guibg=NONE ctermbg=NONE
highlight nonText ctermbg=NONE

function TabAndSearchColors()
  highlight TabLineSel ctermfg=Red ctermbg=Yellow guifg=Red guibg=Yellow
  highlight Search guibg=red guifg=white
endfunction

call TabAndSearchColors()

" tweak quick-scope, tab and search highlight colors
" autocmd! removes any prior autocmd(s) for the ColorScheme change event.
augroup colours
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#5fffff' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#ff6700' gui=underline ctermfg=81 cterm=underline
  autocmd ColorScheme * call TabAndSearchColors()
  autocmd ColorScheme * call TabAndSearchColors()
augroup END

function DarkTheme()
  " tweak quick-scope highlight colors
  augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary guifg='#5fffff' gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg='#ff6700' gui=underline ctermfg=81 cterm=underline
  augroup END
  colorscheme nightfox
  set background=dark
endfunction

function LightTheme()
  " tweak quick-scope highlight colors
  augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary guifg='#ff6700' gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5b00d1' gui=underline ctermfg=81 cterm=underline
  augroup END
  colorscheme PaperColor
  set background=light
endfunction

function DefaultTheme()
  call DarkTheme()
  colorscheme gruvbox
endfunction

nmap <leader>cd :call DarkTheme()<CR>
nmap <leader>cl :call LightTheme()<CR>
nmap <leader>cgd :call DefaultTheme()<CR>
nmap <leader>cgl :call LightTheme() <bar> colorscheme gruvbox<CR>

colorscheme nightfox

" Configure the highlighted Vim tab
"
" NOTE: This must come after the colorscheme change otherwise we'll end up
" unsetting the tab highlighting.
"

" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" Plugin Configuration
" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

" ------------------------------------
" williamboman/nvim-lsp-installer
" ------------------------------------
"
lua require('nvim-lsp-installer').setup()

" ------------------------------------
" bkad/CamelCaseMotion
" ------------------------------------
"
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e

" ------------------------------------
" nvim-lualine/lualine.nvim
" ------------------------------------
"
lua require('lualine').setup()

" ------------------------------------
" sindrets/diffview.nvim
" ------------------------------------
"
lua require('diffview').setup()

nnoremap <leader><leader>dh :DiffviewFileHistory<CR>
nnoremap <leader><leader>do :DiffviewOpen<CR>
nnoremap <leader><leader>dc :DiffviewClose<CR>

" ------------------------------------
" kyazdani42/nvim-tree.lua
" ------------------------------------
"
lua require('nvim-web-devicons').setup()
lua require('nvim-tree').setup()
nnoremap <leader><Tab> :NvimTreeToggle<CR>

" ------------------------------------
" lewis6991/gitsigns.nvim
" ------------------------------------
"
lua require('gitsigns').setup()

" ------------------------------------
" dense-analysis/ale
" ------------------------------------
"
let g:ale_linters = {'go': ['gopls', 'staticcheck', 'revive', 'govet'], 'rust': ['cargo', 'analyzer']}
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
" mileszs/ack.vim
" ------------------------------------
let g:ackprg = 'rg --vimgrep --smart-case --hidden'

" help Ack mappings to respect my split settings
let g:ack_mappings = {
  \ "h": "<C-W><CR>:exe 'wincmd ' (&splitbelow ? 'J' : 'K')<CR><C-W>p<C-W>J<C-W>p",
  \ "v": "<C-W><CR>:exe 'wincmd ' (&splitright ? 'L' : 'H')<CR><C-W>p<C-W>J<C-W>p"}

" ------------------------------------
" b3nj5m1n/kommentary
" ------------------------------------
lua <<EOF
  require('kommentary.config').configure_language("rust", {
      single_line_comment_string = "//",
      multi_line_comment_strings = {"/*", "*/"},
  })
EOF
nmap <silent> <leader><leader><leader> :norm gcc<CR>

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
let g:vim_markdown_conceal_code_blocks = 0
let g:indentLine_fileTypeExclude = ['markdown']
let g:indentLine_concealcursor = "nv"

" ------------------------------------
" gelguy/wilder.nvim
" ------------------------------------
"
call wilder#setup({
      \ 'modes': ['/', '?', ':'],
      \ 'previous_key': '<S-Up>',
      \ 'next_key': '<S-Down>',
      \ })

call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
      \ 'apply_incsearch_fix': 0,
      \ 'highlights': {
      \   'border': 'Normal',
      \ },
      \ 'border': 'rounded',
      \ })))

" ------------------------------------
" j-hui/fidget.nvim
" ------------------------------------
"
lua require("fidget").setup()

" ------------------------------------
" kosayoda/nvim-lightbulb
" ------------------------------------
"
autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()

" ------------------------------------
" weilbith/nvim-code-action-menu
" ------------------------------------
"
let g:code_action_menu_window_border = 'single'

" ------------------------------------
" folke/trouble.nvim
" ------------------------------------
"
lua require("trouble").setup()

" ------------------------------------
" lewis6991/spellsitter.nvim
" ------------------------------------
"
" DISABLED: Broke with latest treesitter.
"
" lua require('spellsitter').setup()

" ------------------------------------
" folke/which-key.nvim
" ------------------------------------
"
lua require('which-key').setup()

" ------------------------------------
" stevearc/dressing.nvim
" ------------------------------------
"
lua require('dressing').setup()

" ------------------------------------
" nvim-treesitter/nvim-treesitter
" ------------------------------------
"
" NOTE: originally used `ensure_installed = "all"` but an experimental PHP
" parser was causing NPM lockfile errors.
"
lua <<EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = { "bash", "c", "cmake", "css", "dockerfile", "go", "gomod", "gowork", "hcl", "help", "html", "http", "javascript", "json", "lua", "make", "markdown", "python", "regex", "ruby", "rust", "toml", "vim", "yaml", "zig" },
  highlight = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
})
EOF

" ------------------------------------
" m-demare/hlargs.nvim
" ------------------------------------
"
lua require('hlargs').setup()

" ------------------------------------
" nvim-telescope/telescope.nvim
" ------------------------------------
"
" :help telescope.setup()
"
nnoremap <leader>f <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>t <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>c <cmd>Telescope colorscheme<cr>
nnoremap <leader>q <cmd>Telescope quickfix<cr>
nnoremap <leader>r <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>tr <cmd>Telescope lsp_references<cr>
nnoremap <leader>ts <cmd>Telescope lsp_document_symbols<cr>
lua <<EOF
  local actions = require("telescope.actions")

  require("telescope").setup({
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-o>"] = actions.send_selected_to_qflist,
        },
      },
    },
    extensions = {
      heading = {
        treesitter = true,
      },
    },
  })
EOF

" ------------------------------------
" nvim-telescope/telescope-fzf-native.nvim
" ------------------------------------
"
lua require('telescope').load_extension('fzf')

" ------------------------------------
" crispgm/telescope-heading.nvim
" ------------------------------------
"
lua require('telescope').load_extension('heading')

" ------------------------------------
" xiyaowong/telescope-emoji.nvim
" ------------------------------------
"
lua require('telescope').load_extension('emoji')

:nmap <silent> <leader>e :Telescope emoji<CR>

" ------------------------------------
" kyoh86/telescope-windows.nvim
" ------------------------------------
"
lua require('telescope').load_extension('windows')

:nmap <silent> <leader>w :Telescope windows<CR>

" ------------------------------------
" axkirillov/telescope-changed-files
" ------------------------------------
"
lua require('telescope').load_extension('changed_files')

lua <<EOF
  vim.g.telescope_changed_files_base_branch = 'main'
EOF
:nmap <silent> <leader>g :Telescope changed_files<CR>
:nmap <silent> <leader>gc :Telescope changed_files choose_base_branch<CR>

" ------------------------------------
" mrjones2014/dash.nvim
" ------------------------------------
"
:nmap <silent> <leader>do :DashWord<CR>

" ------------------------------------
" Neovim LSP
" ------------------------------------
"
" Configure Rust LSP.
"
" https://github.com/simrat39/rust-tools.nvim#configuration
"
lua <<EOF
local opts = {
  -- rust-tools options
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    inlay_hints = {
      show_variable_name = true,
      show_parameter_hints = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
      },
    },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
  -- https://rust-analyzer.github.io/manual.html#features
  server = {
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importEnforceGranularity = true,
          importPrefix = "crate"
          },
        cargo = {
          allFeatures = true
          },
        checkOnSave = {
          -- default: `cargo check`
          command = "clippy"
          },
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true
          },
        },
      }
    },
}
require('rust-tools').setup(opts)
EOF

" Configure Rust Environment
"
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync()
autocmd FileType rust map <buffer> <leader>rr :RustRunnables<CR>

" Configure Golang LSP.
"
" https://github.com/golang/tools/blob/master/gopls/doc/settings.md
" https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
" https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
" https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
" https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
" https://www.getman.io/posts/programming-go-in-neovim/
"
lua <<EOF
require('lspconfig').gopls.setup{
	cmd = {'gopls'},
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      experimentalPostfixCompletions = true,
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
    },
  },
}
EOF

" Configure Golang Environment.
"
fun! GoFumpt()
  :silent !gofumpt -w %
  :edit
endfun
autocmd FileType go map <buffer> <leader>p :call append(".", "fmt.Printf(\"%+v\\n\", )")<CR> <bar> :norm $a<CR><esc>j==$i
autocmd FileType go map <buffer> <leader>e :call append(".", "if err != nil {return err}")<CR> <bar> :w<CR>
autocmd BufWritePost *.go call GoFumpt()
autocmd BufWritePost *.go :cex system('revive '..expand('%:p')) | cwindow

" Order imports on save, like goimports does:
"
lua <<EOF
  function OrgImports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end
EOF
autocmd BufWritePre *.go lua OrgImports(1000)

" NOTE: When using :LspInstallInfo to install available LSPs, we need to still
" add calls to their setup here in our Vim configuration.

" Configure Terraform LSP.
"
lua require('lspconfig').terraformls.setup{}

autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync()

" Configure Terraform Linter LSP.
"
lua require('lspconfig').tflint.setup{}

" Configure JavaScript Linter LSP.
"
lua require('lspconfig').quick_lint_js.setup{}

" Configure TypeScript LSP.
"
lua require('lspconfig').tsserver.setup{}

" Configure LSP code navigation shortcuts
" as found in :help lsp
"
" Exclude the 'help' FileType as <c-]> is used for navigating help docs.
autocmd FileType *\(^help\)\@<! nnoremap <silent> <c-]>     <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>k   <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gc          <cmd>lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <silent> gd          <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gn          <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gs          <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gw          <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <silent> ga          <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> ga          <cmd>CodeActionMenu<CR>
nnoremap <silent> ]z          <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]x          <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>ds  <cmd>lua vim.diagnostic.show()<CR>
" nnoremap <silent> <leader>di  <cmd>lua vim.diagnostic.setloclist()<CR>
nnoremap <silent> <leader>dc  <cmd>TroubleClose<CR>
nnoremap <silent> <leader>di  <cmd>TroubleToggle document_diagnostics<CR>
nnoremap <silent> <leader>dw  <cmd>TroubleToggle workspace_diagnostics<CR>
nnoremap <silent> <leader>dr  <cmd>TroubleToggle lsp_references<CR>
nnoremap <silent> <leader>dq  <cmd>TroubleToggle quickfix<CR> <bar> :ccl<CR>
nnoremap <silent> <leader>dl  <cmd>TroubleToggle loclist<CR> <bar> :lcl<CR>

" Setup Completion
" https://github.com/hrsh7th/nvim-cmp#recommended-configuration
"
lua <<EOF
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Left>'] = cmp.mapping.select_prev_item(),
    ['<Right>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'nvim_lsp_signature_help' },
  },
})
EOF

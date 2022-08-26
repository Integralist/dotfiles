--[[
To see what an option is set to execute :lua = vim.o.<name>
--]]

vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.cursorline = true
vim.o.dictionary = "/usr/share/dict/words"
vim.o.expandtab = true
vim.o.grepprg = "rg --vimgrep"
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.lazyredraw = true
vim.o.number = true
vim.o.scrolloff = 5
vim.o.shiftwidth = 2
vim.o.shortmess = vim.o.shortmess .. "c" -- .. is equivalent to += in vimscript
vim.o.showmatch = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spell = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.updatetime = 1000 -- affects CursorHold and subsequently things like highlighting Code Actions.
vim.o.wrap = false

vim.cmd([[ set colorcolumn=80 ]])

--[[
https://www.reddit.com/r/neovim/comments/wy4pfo/how_to_set_colorcolumn_via_nvim_lua_api/

vim.api.nvim_set_option("colorcolumn", "80")

local opts = {}
opts["scope"] = "global"
vim.api.nvim_set_option_value("colorcolumn", "80", opts)
]]

if vim.fn.has("termguicolors") == 1 then
  vim.o.termguicolors = true
end

-- LSP configuration options
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = "rounded" }
)
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})

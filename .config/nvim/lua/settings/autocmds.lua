vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {
    "*.lua"
  },
  command = [[source ~/.config/nvim/init.lua]]
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "sh", "go", "rust"
  },
  command = [[setlocal textwidth=80]]
})

vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
  pattern = {
    "*.mdx"
  },
  command = [[set filetype=markdown]]
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = {
    "*"
  },
  callback = function()
    vim.cmd("highlight BufDimText guibg='NONE' guifg=darkgrey guisp=darkgrey gui='NONE'")
  end
})

vim.cmd([[
  augroup WrapLineInMarkdown
      autocmd!
      autocmd FileType markdown setlocal wrap
  augroup END
]])

local id = vim.api.nvim_create_augroup("DimInactiveBuffers", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = id,
  pattern = "*",
  callback = function()
    require("settings/shared").toggleDimWindows()
  end,
})

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

vim.cmd([[
  augroup WrapLineInMarkdown
      autocmd!
      autocmd FileType markdown setlocal wrap
  augroup END
]])

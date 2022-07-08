--[[
These are general purpose mappings and LSP mappings.
Mappings for plugins are inside ~/.config/nvim/plugin/<name>.lua

NOTE: ~/.config/nvim/lua/autocmds.lua contains one other LSP mapping.
--]]

vim.keymap.set("", "±", "<Cmd>nohlsearch<CR>", { desc = "turn off search highlight" })

-- We have to prefix with <leader> otherwise Telescope's <Esc> will be overridden.
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>", { 
  noremap = true, 
  desc = "escape terminal" 
})

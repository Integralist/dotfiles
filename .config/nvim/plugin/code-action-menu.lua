vim.keymap.set("n", "ga", "<Cmd>CodeActionMenu<CR>", { 
  noremap = true, 
  desc = "code action menu" 
})

vim.g.code_action_menu_window_border = "single"

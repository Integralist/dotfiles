local bufopts = { noremap = true, silent = true, buffer = bufnr }

vim.keymap.set("n", "<leader><leader>lc", "<Cmd>TroubleClose<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>li", "<Cmd>TroubleToggle document_diagnostics<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>lw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>lr", "<Cmd>TroubleToggle lsp_references<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>lq", "<Cmd>TroubleToggle quickfix<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>ll", "<Cmd>TroubleToggle loclist<CR>", bufopts)

local bufopts = { noremap=true, silent=true, buffer=bufnr }

vim.keymap.set("n", "<leader><leader>tc", "<Cmd>TroubleClose<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>ti", "<Cmd>TroubleToggle document_diagnostics<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>tw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>tr", "<Cmd>TroubleToggle lsp_references<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>tq", "<Cmd>TroubleToggle quickfix<CR>", bufopts)
vim.keymap.set("n", "<leader><leader>tl", "<Cmd>TroubleToggle loclist<CR>", bufopts)

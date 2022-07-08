local bufopts = { noremap=true, silent=true, buffer=bufnr }

vim.keymap.set("n", "<leader>dc", "<Cmd>TroubleClose<CR>", bufopts)
vim.keymap.set("n", "<leader>di", "<Cmd>TroubleToggle document_diagnostics<CR>", bufopts)
vim.keymap.set("n", "<leader>dw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", bufopts)
vim.keymap.set("n", "<leader>dr", "<Cmd>TroubleToggle lsp_references<CR>", bufopts)
vim.keymap.set("n", "<leader>dq", "<Cmd>TroubleToggle quickfix<CR>", bufopts)
vim.keymap.set("n", "<leader>dl", "<Cmd>TroubleToggle loclist<CR>", bufopts)

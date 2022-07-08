require("diffview").setup()

vim.keymap.set("n", "<leader><leader>dh", "<Cmd>DiffviewFileHistory<CR>", { desc = "diff history" })
vim.keymap.set("n", "<leader><leader>do", "<Cmd>DiffviewOpen<CR>", { desc = "diff open" })
vim.keymap.set("n", "<leader><leader>dc", "<Cmd>DiffviewClose<CR>", { desc = "diff close" })

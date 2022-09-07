require("diffview").setup()

vim.keymap.set("n", "<leader><leader>gh", "<Cmd>DiffviewFileHistory<CR>", { desc = "diff history" })
vim.keymap.set("n", "<leader><leader>go", "<Cmd>DiffviewOpen<CR>", { desc = "diff open" })
vim.keymap.set("n", "<leader><leader>gc", "<Cmd>DiffviewClose<CR>", { desc = "diff close" })

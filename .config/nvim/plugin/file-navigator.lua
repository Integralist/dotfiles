require("nvim-tree").setup()

vim.keymap.set("n", "<leader><Tab>", "<Cmd>NvimTreeToggle<CR>", { desc = "search files" })

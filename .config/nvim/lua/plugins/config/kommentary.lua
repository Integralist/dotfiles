require("kommentary.config").configure_language("rust", {
    single_line_comment_string = "//",
    multi_line_comment_strings = {"/*", "*/"},
})

vim.keymap.set("n", "<leader><leader><leader>", "<Cmd>norm gcc<CR>", { desc = "comment a single line" })

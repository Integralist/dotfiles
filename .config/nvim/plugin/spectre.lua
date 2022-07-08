require("spectre").setup({
  replace_engine={
    ["sed"]={
        cmd = "gsed",
    },
  },
})

vim.keymap.set("n", "<leader>S", "<Cmd>lua require('spectre').open()<CR>", { desc = "search and replace" })

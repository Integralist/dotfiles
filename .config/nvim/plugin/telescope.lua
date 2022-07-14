local actions = require("telescope.actions")
local ts = require("telescope")

ts.setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-o>"] = actions.send_selected_to_qflist,
      },
    },
  },
  extensions = {
    heading = {
      treesitter = true,
    },
  },
})

ts.load_extension("fzf")
ts.load_extension("heading")
ts.load_extension("emoji")
ts.load_extension("windows")
ts.load_extension("changed_files")

vim.g.telescope_changed_files_base_branch = "main"

vim.keymap.set("n", "<leader>b", "<Cmd>Telescope buffers<CR>", { desc = "search buffers" })
vim.keymap.set("n", "<leader>c", "<Cmd>Telescope colorscheme<CR>", { desc = "search colorschemes" })
vim.keymap.set("n", "<leader>do", "<Cmd>DashWord<CR>", { desc = "search dash app for word under cursor" })
vim.keymap.set("n", "<leader>ej", "<Cmd>Telescope emoji<CR>", { desc = "search emojis" })
vim.keymap.set("n", "<leader>ex", "<Cmd>Telescope commands<CR>", { desc = "search Ex commands" })
vim.keymap.set("n", "<leader>f", "<Cmd>Telescope find_files hidden=true<CR>", { desc = "search files" })
vim.keymap.set("n", "<leader>g", "<Cmd>Telescope changed_files<CR>", { desc = "search changed files" })
vim.keymap.set("n", "<leader>gc", "<Cmd>Telescope changed_files choose_base_branch<CR>", { desc = "search changed files and choose branch" })
vim.keymap.set("n", "<leader>h", "<Cmd>Telescope help_tags<CR>", { desc = "search help" })
vim.keymap.set("n", "<leader>i", "<Cmd>Telescope builtin<CR>", { desc = "search builtins" })
vim.keymap.set("n", "<leader>k", "<Cmd>Telescope keymaps<CR>", { desc = "search key mappings" })
vim.keymap.set("n", "<leader>ld", "<Cmd>Telescope diagnostics<CR>", { desc = "search incoming calls" })
vim.keymap.set("n", "<leader>li", "<Cmd>Telescope lsp_incoming_calls<CR>", { desc = "search incoming calls" })
vim.keymap.set("n", "<leader>lo", "<Cmd>Telescope lsp_outgoing_calls<CR>", { desc = "search outgoing calls" })
vim.keymap.set("n", "<leader>lr", "<Cmd>Telescope lsp_references<CR>", { desc = "search code reference" })
vim.keymap.set("n", "<leader>ls", "<Cmd>Telescope lsp_document_symbols<CR>", { desc = "search document tree" })
vim.keymap.set("n", "<leader>m", "<Cmd>Telescope heading<CR>", { desc = "search markdown headings" })
vim.keymap.set("n", "<leader>q", "<Cmd>Telescope quickfix<CR>", { desc = "search quickfix list" })
vim.keymap.set("n", "<leader>r", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "search current buffer text" })
vim.keymap.set("n", "<leader>t", "<Cmd>Telescope live_grep<CR>", { desc = "search text" })
vim.keymap.set("n", "<leader>w", "<Cmd>Telescope windows<CR>", { desc = "search windows" })

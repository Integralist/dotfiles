local lint = require("lint")

lint.linters.cargo = {
  cmd = "cargo check",
  stdin = false,
  args = {},
  stream = "both",
  ignore_exitcode = false,
  env = nil,
}

lint.linters_by_ft = {
  go = {"golangcilint", "revive"},
  rust = {"cargo"},
}

local golangcilint = require("lint.linters.golangcilint")
golangcilint.append_fname = true
golangcilint.args = {
  "run",
  "--out-format",
  "json",
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {
    "<buffer>"
  },
  command = [[lua require('lint').try_lint()]]
})

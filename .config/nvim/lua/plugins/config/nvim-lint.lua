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
  go = { "golangcilint" }, -- ~/.golangci.yml
  rust = { "cargo" },
}

-- see ./lsp-config.lua for calls to this plugin's try_lint() function.

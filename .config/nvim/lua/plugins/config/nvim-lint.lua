local lint = require("lint")

lint.linters_by_ft = {
  go = { "golangcilint" }, -- ~/.golangci.yml
}

-- see ./lsp-config.lua for calls to this plugin's try_lint() function.

-- TODO: can this use simpler vim.cmd("...") syntax?

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require("nvim-lightbulb").update_lightbulb()]]

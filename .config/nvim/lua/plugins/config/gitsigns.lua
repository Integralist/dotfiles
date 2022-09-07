require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { desc = "next change hunk", expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { desc = "prev change hunk", expr = true })

    map('n', '<leader><leader>gb', function()
      gs.blame_line { full = true }
    end, { desc = "git blame" })

    map('n', '<leader><leader>gs', function()
      gs.blame_line {}
    end, { desc = "git blame short" })

    map('n', '<leader><leader>gd', gs.diffthis, { desc = "git diff" })
  end
})

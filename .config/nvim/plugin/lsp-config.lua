--[[
NOTE: I currently manually attach my shared mappings for each LSP server.
      But, we can set a generic one using lspconfig:

      require("lspconfig").util.default_config.on_attach = function()
--]]

function OrgImports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

require("lspconfig").gopls.setup({
  on_attach = function(client, bufnr)
    require("shared").on_attach(client, bufnr)
    require("lsp-inlayhints").setup({
      inlay_hints = {
        type_hints = {
          prefix = "=> "
        },
      },
    })
    require("lsp-inlayhints").on_attach(client, bufnr)
    require("illuminate").on_attach(client)

    -- autocommands can overlap and consequently not run
    -- so for these we have a little duplication to ensure they run
    vim.cmd([[
      fun! GoLint()
       :lua vim.lsp.buf.formatting_sync()
       :lua OrgImports(1000)
       :lua require("lint").try_lint() -- golangci-lint configuration via ./lint.lua
     endfun
     autocmd! BufWritePre *.go call GoLint()
    ]])

    local bufopts = { noremap = true, silent = true, buffer = bufnr, desc = "lint code" }
    vim.keymap.set('n', '<leader><leader>lv', "<Cmd>cex system('revive -exclude vendor/... ./...') | cwindow<CR>",
      bufopts)
  end,
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      experimentalPostfixCompletions = true,
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      }
    },
  },
})

require("rust-tools").setup({
  -- rust-tools options
  tools = {
    autoSetHints = true,
    inlay_hints = {
      show_variable_name = true,
      show_parameter_hints = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  --
  -- REFERENCE:
  -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
  -- https://rust-analyzer.github.io/manual.html#configuration
  -- https://rust-analyzer.github.io/manual.html#features
  --
  -- NOTE: The configuration format is `rust-analyzer.<section>.<property>`.
  --       <section> should be an object.
  --       <property> should be a primitive.
  server = {
    on_attach = function(client, bufnr)
      require("shared").on_attach(client, bufnr)
      require("illuminate").on_attach(client)

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', '<leader><leader>rr', "<Cmd>RustRunnables<CR>", bufopts)
      vim.keymap.set('n', 'K', "<Cmd>RustHoverActions<CR>", bufopts)

      -- autocommands can overlap and consequently not run
      -- so for these we have a little duplication to ensure they run
      vim.cmd([[
        fun! RustPreLint()
         :lua vim.lsp.buf.formatting_sync()
         :lua require("lint").try_lint()
       endfun
       autocmd! BufWritePre *.rs call RustPreLint()
      ]])
    end,
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importEnforceGranularity = true,
          importPrefix = "crate"
        },
        cargo = {
          allFeatures = true
        },
        checkOnSave = {
          -- default: `cargo check`
          command = "clippy",
          allFeatures = true,
        },
      },
      inlayHints = {
        lifetimeElisionHints = {
          enable = true,
          useParameterNames = true
        },
      },
    }
  },
})

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

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = {
        "*.go"
      },
      command = [[lua OrgImports(1000)]]
    })
  end,
  cmd = { "gopls" },
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
      vim.keymap.set('n', '<leader><leader>rr', "<Cmd>RustRunnables<CR>",
        { noremap = true, silent = true, buffer = bufnr })
      vim.keymap.set('n', 'K', "<Cmd>RustHoverActions<CR>",
        { noremap = true, silent = true, buffer = bufnr })
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
          command = "clippy"
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

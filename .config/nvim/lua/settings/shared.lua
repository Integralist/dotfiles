local export = {}

function export.on_attach(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<c-]>', "<Cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
  vim.keymap.set('n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
  vim.keymap.set('n', 'gh', "<Cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
  vim.keymap.set('n', 'ga', "<Cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)
  vim.keymap.set('n', 'gm', "<Cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
  vim.keymap.set('n', 'gl', "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>", bufopts)
  vim.keymap.set('n', 'gd', "<Cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
  vim.keymap.set('n', 'gr', "<Cmd>lua vim.lsp.buf.references()<CR>", bufopts)
  vim.keymap.set('n', 'gn', "<Cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
  -- vim.keymap.set('n', 'gs', "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", bufopts)
  vim.keymap.set('n', 'gs', "<Cmd>SymbolsOutline<CR>", bufopts)
  vim.keymap.set('n', 'gw', "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", bufopts)
  vim.keymap.set('n', '[x', "<Cmd>lua vim.diagnostic.goto_prev()<CR>", bufopts)
  vim.keymap.set('n', ']x', "<Cmd>lua vim.diagnostic.goto_next()<CR>", bufopts)
  vim.keymap.set('n', ']r', "<Cmd>lua vim.diagnostic.open_float()<CR>", bufopts)
  vim.keymap.set('n', ']s', "<Cmd>lua vim.diagnostic.show()<CR>", bufopts)

  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("SharedLspFormatting", { clear = true }),
    pattern = "*",
    command = "lua vim.lsp.buf.format()",
  })

  if client.server_capabilities.documentSymbolProvider then
    -- require("nvim-navic").attach(client, bufnr)
  end
end

return export

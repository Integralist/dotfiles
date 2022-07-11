local export = {}

function export.on_attach(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<c-]>', "<Cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
  vim.keymap.set('n', '<leader>k', "<Cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
  vim.keymap.set('n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
  vim.keymap.set('n', 'gi', "<Cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
  vim.keymap.set('n', 'giC', "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>", bufopts)
  vim.keymap.set('n', 'gd', "<Cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
  vim.keymap.set('n', 'gr', "<Cmd>lua vim.lsp.buf.references()<CR>", bufopts)
  vim.keymap.set('n', 'gn', "<Cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
  vim.keymap.set('n', 'gs', "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", bufopts)
  vim.keymap.set('n', 'gw', "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", bufopts)
  vim.keymap.set('n', '<leader>z', "<Cmd>lua vim.diagnostic.goto_prev()<CR>", bufopts)
  vim.keymap.set('n', '<leader>x', "<Cmd>lua vim.diagnostic.goto_next()<CR>", bufopts)
  vim.keymap.set('n', '<leader>ds', "<Cmd>lua vim.diagnostic.show()<CR>", bufopts)

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {
      "*"
    },
    command = [[lua vim.lsp.buf.formatting_sync()]]
  })
end

return export

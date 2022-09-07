local export = {}

function export.on_attach(_, bufnr)
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

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {
      "*"
    },
    command = [[lua vim.lsp.buf.formatting_sync()]]
  })
end

-- The following implements dimming of inactive buffers
-- An autocommand group is setup in ../lua/autocmds.lua

local function windowIsRelative(windowId)
  return vim.api.nvim_win_get_config(windowId).relative ~= ''
end

local function windowIsCf(windowId)
  local buftype = vim.bo.buftype

  if windowId ~= nil then
    local bufferId = vim.api.nvim_win_get_buf(windowId)
    buftype = vim.api.nvim_buf_get_option(bufferId, 'buftype')
  end

  return buftype == 'quickfix'
end

function export.toggleDimWindows()
  local windowsIds = vim.api.nvim_list_wins()
  local currentWindowId = vim.api.nvim_get_current_win()

  if windowIsRelative(currentWindowId) then
    return
  end

  pcall(vim.fn.matchdelete, currentWindowId)

  if windowIsCf(currentWindowId) then
    return
  end

  for _, id in ipairs(windowsIds) do
    if id ~= currentWindowId and not windowIsRelative(id) then
      pcall(vim.fn.matchadd, 'BufDimText', '.', 200, id, { window = id })
    end
  end
end

return export

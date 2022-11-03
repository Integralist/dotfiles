-- print(require("utils").dump(<table>))
local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- TODO: Remove this temporary workaround.
-- https://github.com/folke/noice.nvim/issues/151#issuecomment-1301934607"
local function style_lsp_hover()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
  )
end

return {
  dump = dump,
  style_lsp_hover = style_lsp_hover
}

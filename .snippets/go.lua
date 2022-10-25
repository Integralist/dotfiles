-- DOCS:
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#snippets
--
-- GLOBAL VARS:
-- https://github.com/L3MON4D3/LuaSnip/blob/69cb81cf7490666890545fef905d31a414edc15b/lua/luasnip/config.lua#L82-L104§

return {
  s({ trig = "co", name = "Constant", dscr = "Insert a constant" }, {
    t "const ", i(1, "name"), t " = ", i(2, "value")
  }),

  parse("iferr", [[
  if err != nil {
    return err
  }
  ]]),

  parse("iferrwrap", [[
  if err != nil {
    return fmt.Errorf("error: %w", err)
  }
  ]]),

  parse("pfmt", "fmt.Printf(\"%+v\\n\", )"),
}

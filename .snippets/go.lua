-- DOCS:
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#snippets
--
-- GLOBAL VARS:
-- https://github.com/L3MON4D3/LuaSnip/blob/69cb81cf7490666890545fef905d31a414edc15b/lua/luasnip/config.lua#L82-L104§

local session = require("luasnip.session")

local env = session.config.snip_env
local s = env["s"]
local t = env["t"]
local i = env["i"]
local parse = env["parse"]

return {
  s({ trig = "co", name = "Constant", dscr = "Insert a constant" }, {
    t("const "), i(1, "name"), t(" = "), i(2, "value")
  }),

  s({ trig = "pf", name = "Formatted Print", dscr = "Insert a formatted print statement" }, {
    t("fmt.Printf(\"%+v\\n\", "), i(1, "value"), t(")")
  }),

  parse({ trig = "ife", name = "If Err", dscr = "Insert a basic if err not nil statement" }, [[
  if err != nil {
    return err
  }
  ]]),

  s({ trig = "ifew", name = "If Err Wrapped", dscr = "Insert a if err not nil statement with wrapped error" }, {
    t("if err != nil {"),
    t({ "", "  return fmt.Errorf(\"failed to " }),
    i(1, "message"),
    t(": %w\", err)"),
    t({ "", "}" })
  }),
}

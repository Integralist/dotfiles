-- DOCS:
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#snippets
--
-- GLOBAL VARS:
-- https://github.com/L3MON4D3/LuaSnip/blob/69cb81cf7490666890545fef905d31a414edc15b/lua/luasnip/config.lua#L82-L104§

local session = require("luasnip.session")

local env = session.config.snip_env
local parse = env["parse"]

return {
  parse({ trig = "ch", name = "Changelog entry", dscr = "Insert a static changelog entry" }, [[
  ## [v1.0.0](https://github.com/fastly/.../releases/tag/v1.0.0) (YYYY-MM-DD)
  
  [Full Changelog](https://github.com/fastly/.../compare/v0.0.0...v1.0.0)
  
  **Bug fixes:**
  
  * ... [#](https://github.com/fastly/.../pull/)
  
  **Dependencies:** 
  
  * ... [#](https://github.com/fastly/.../pull/)
  
  **Documentation:**
  
  * ... [#](https://github.com/fastly/.../pull/)
  
  **Enhancements:**
  
  * ... [#](https://github.com/fastly/.../pull/)

  ]]),
}

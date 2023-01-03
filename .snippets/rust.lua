-- DOCS:
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#snippets
--
-- GLOBAL VARS:
-- https://github.com/L3MON4D3/LuaSnip/blob/69cb81cf7490666890545fef905d31a414edc15b/lua/luasnip/config.lua#L82-L104§

local session = require("luasnip.session")
local env = session.config.snip_env
local parse = env["parse"]

return {
  parse("match", [[
  let result = match T {
      Ok(data) => data,
      Err(e) => return Err(e),
  };
  ]])
}

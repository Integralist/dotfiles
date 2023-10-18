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
  parse({
    trig = "tf",
    name = "Fastly VCL Boilerplate",
    dscr = "Simple HCL structure for a Fastly VCL Service"
  }, [[
  terraform {
    required_providers {
      fastly = {
        source  = "fastly/fastly"
        version = ">1.0.0"
      }
    }
  }

  resource "fastly_service_vcl" "test-XXXX" {
    force_destroy = true
    name          = "test-XXXX"

    backend {
      address = "127.0.0.1"
      name    = "test_backend"
      port    = 80
    }

    domain {
      name = "test-XXXX.fastly-terraform.com"
    }
  }
  ]])
}

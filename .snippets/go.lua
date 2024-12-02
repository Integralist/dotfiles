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
		t("fmt.Printf(\"%#v\\n\", "), i(1, "value"), t(")")
	}),

	s(
		{
			trig = "pfs",
			name = "Formatted Print with extra spacing",
			dscr =
			"Insert a formatted print statement with extra line breaks"
		}, {
			t("fmt.Printf(\"\\n\\n%#v\\n\\n\", "), i(1, "value"), t(")")
		}),

	parse({ trig = "ife", name = "If Err", dscr = "Insert a basic if err not nil statement" }, [[
  if err != nil {
    return err
  }
  ]]),

	parse({ trig = "ifel", name = "If Err Log Fatal", dscr = "Insert a basic if err not nil statement with log.Fatal" }, [[
  if err != nil {
    log.Fatal(err)
  }
  ]]),

	s({ trig = "ifew", name = "If Err Wrapped", dscr = "Insert a if err not nil statement with wrapped error" }, {
		t("if err != nil {"),
		t({ "", "  return fmt.Errorf(\"failed to " }),
		i(1, "message"),
		t(": %w\", err)"),
		t({ "", "}" })
	}),

	parse({ trig = "ma", name = "Main Package", dscr = "Basic main package structure" }, [[
  package main

  import "fmt"

  func main() {
    fmt.Printf("%+v\n", "...")
  }
  ]]),

	parse({ trig = "cli", name = "CLI", dscr = "CLI main package structure that honours defers" }, [[
	package main

	import (
		"flag"
		"os"
	)

	var (
		S = flag.String("a-string-flag", "", "Description")
		B = flag.Bool("a-bool-flag", false, "Description")
	)

	func main() {
		flag.Parse()

		// NOTE: Moving the logic to `run` allows us to honour `defer` calls.
		if err := run(); err != nil {
			os.Exit(1)
		}
	}

	func run() error {
		return nil
	}
  ]]),
}

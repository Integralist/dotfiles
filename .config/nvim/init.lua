--[[
Neovim knows to search:

* ~/.config/nvim/lua for our custom scripts when we call require().
* ~/.config/nvim/plugin for installed plugins (+ our own plugin configuration scripts).

:h runtimepath
--]]

require("plugin-manager")
require("options")
require("quickfix")
require("mappings")
require("autocmds")

require("settings/autocmds")
require("settings/mappings")
require("settings/netrw")
require("settings/options")
require("settings/quickfix")

require("plugins")

-- The following code loads any external plugin configuration settings.

local function ends_with(str, ending)
  return ending == "" or str:sub(- #ending) == ending
end

local files = vim.api.nvim_get_runtime_file("lua/plugins/config/*.lua", true)
for _, v in ipairs(files) do -- NOTE: ipairs() keeps key order, pairs() doesn't.
  for _, s in ipairs(vim.split(v, "/lua/")) do
    if ends_with(s, ".lua") then
      for _, p in ipairs(vim.split(s, "[.]lua")) do
        if (p ~= "") then
          require(p)
        end
      end
    end
  end
end

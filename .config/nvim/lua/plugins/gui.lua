local function init(use)
  -- status line
  use { "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup({})
    end
  }

  -- ui improvements
  use { "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup()
    end
  }

  -- NOTE: `:Noice` to open message history + `:Noice telescope` to open message history in Telescope.
  use({
    "folke/noice.nvim",
    event = "VimEnter",
    config = function()
      require("noice").setup({
        views = {
          cmdline_popup = {
            position = {
              row = "40%",
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
            win_options = {
              winhighlight = {
                Normal = "Normal",
                FloatBorder = "DiagnosticSignInfo",
                IncSearch = "",
                Search = "",
              },
            },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = 8,
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticSignInfo" },
            },
          },
        },
        routes = {
          -- skip displaying message that file was written to.
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        }
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  })

  -- tab ui improvments
  use { "akinsho/bufferline.nvim",
    tag = "v2.*",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs"
        }
      })
    end
  }

  -- quickfix improvements
  --
  -- <Tab> to select items.
  -- zn to keep selected items.
  -- zN to filter selected items.
  -- zf to fuzzy search items.
  use { "junegunn/fzf",
    run = function()
      vim.fn["fzf#install"]()
    end
  }
  use { "kevinhwang91/nvim-bqf", ft = "qf" }
end

return { init = init }

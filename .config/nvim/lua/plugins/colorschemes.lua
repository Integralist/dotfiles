local function init(use)
  use "EdenEast/nightfox.nvim"
  use { "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
      })

      -- We remove the Vim builtin colorschemes so they don't show in Telescope.
      vim.cmd("silent !rm $VIMRUNTIME/colors/*.vim &> /dev/null")

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("FixGruvboxForNoice", { clear = true }),
        pattern = "*",
        callback = function()
          if vim.g.colors_name == "gruvbox" then
            vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdline", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderFilter", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderHelp", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderInput", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderLua", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = "#fabd2f", bg = "NONE" })

            vim.api.nvim_set_hl(0, "NoiceCmdlineIconCmdline", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlineIconFilter", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlineIconHelp", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlineIconInput", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlineIconLua", { fg = "#83a598", bg = "NONE" })
            vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = "#fabd2f", bg = "NONE" })
          end
        end
      })

      vim.cmd("colorscheme gruvbox")

      -- EXAMPLE:
      -- ExtendHL('Comment', { italic = true })
      function ExtendHL(name, def)
        local current_def = vim.api.nvim_get_hl_by_name(name, true)
        local new_def = vim.tbl_extend("force", {}, current_def, def)
        vim.api.nvim_set_hl(0, name, new_def)
      end

      -- NOTE: If you want to quickly change the background colour of a theme, and
      -- also the default text colour (e.g. the Ex command line color) then the
      -- following highlight group will affect that.
      --
      -- :hi Normal guifg=#e0def4 guibg=#232136
      --
      -- :lua TweakTheme("white", "pink")
      -- :lua TweakTheme("#ffffff", "#000000")
      function TweakTheme(fg, bg)
        vim.cmd("hi Normal guifg=" .. fg .. " guibg=" .. bg)
      end
    end
  }
  use "fenetikm/falcon"
end

return { init = init }

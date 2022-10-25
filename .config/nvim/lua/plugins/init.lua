--[[
The configuration in this file should automatically install packer.nvim for you.

Then execute :PackerSync to install/update all configured plugins.

Plugins will be compiled into:
/Users/integralist/.local/share/nvim/site/pack/packer/start

The ~/.config/nvim/plugin directory contains my own configuration files + the compiled package plugin.

NOTE: The plugin mappings defined have the following convention:

* Single <leader> for search operations (inc. file explorer + search/replace)
* Double <leader> for all other mappings

This helps to avoid overlap in letters.
--]]

vim.keymap.set("", "<leader><leader>ps", "<Cmd>PackerSync<CR>", { desc = "update vim plugins" })

local id = vim.api.nvim_create_augroup("PackerCompiler", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = id,
  pattern = "*.lua",
  command = "source <afile> | PackerCompile",
})

-- The following configuration ensures that when we clone these dotfiles to a
-- new laptop, that they'll continue to work without any manual intervention.
-- Check the bottom of the .startup() function for our call to packer_bootstrap.
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

return require("packer").startup({
  function()
    -- plugin manager
    use "wbthomason/packer.nvim"

    -- optimizations
    use { "lewis6991/impatient.nvim",
      config = function()
        require("impatient")
      end
    }

    -- colorschemes
    use "EdenEast/nightfox.nvim"
    use "fenetikm/falcon"
    use { "ellisonleao/gruvbox.nvim",
      config = function()
        require("gruvbox").setup({
          contrast = "hard",
        })
      end
    }

    -- make dot operator work in a sensible way
    use "tpope/vim-repeat"

    -- syntax tree parsing for more intelligent syntax highlighting and code navigation
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use { "nvim-treesitter/nvim-treesitter-textobjects",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("nvim-treesitter.configs").setup({
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn", -- start treesitter selection process
              scope_incremental = "gnm", -- increment selection to surrounding scope
              node_incremental = ";", -- increment selection to next 'node'
              node_decremental = ",", -- decrement selection to prev 'node'
            },
          },
          indent = {
            enable = true
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              include_surrounding_whitespace = false,
              keymaps = {
                ["af"] = { query = "@function.outer", desc = "select around a function" },
                ["if"] = { query = "@function.inner", desc = "select inner part of a function" },
                ["ac"] = { query = "@class.outer", desc = "select around a class" },
                ["ic"] = { query = "@class.inner", desc = "select inner part of a class" },
              },
              selection_modes = {
                ['@parameter.outer'] = 'v',
                ['@function.outer'] = 'V',
                ['@class.outer'] = '<c-v>',
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]]"] = "@function.outer",
                ["]\\"] = "@class.outer",
              },
              goto_previous_start = {
                ["[["] = "@function.outer",
                ["[\\"] = "@class.outer",
              },
            },
          },
        })
      end
    }
    use { "lewis6991/spellsitter.nvim",
      config = function()
        require("spellsitter").setup()
      end
    }
    use { "m-demare/hlargs.nvim",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("hlargs").setup()
      end
    }

    -- searching
    use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "nvim-telescope/telescope-ui-select.nvim",
      config = function()
        require("telescope").setup({})
      end
    }
    use "kyoh86/telescope-windows.nvim"
    use "crispgm/telescope-heading.nvim"
    use "xiyaowong/telescope-emoji.nvim"
    use "axkirillov/telescope-changed-files"
    use { "LukasPietzschmann/telescope-tabs",
      config = function()
        vim.keymap.set("n", "<leader>t", "<Cmd>lua require('telescope-tabs').list_tabs()<CR>", { desc = "search tabs" })
      end
    }

    -- pattern searching
    use "mileszs/ack.vim"

    -- search indexer
    use { "kevinhwang91/nvim-hlslens",
      config = function()
        require("hlslens").setup()
      end
    }
    use { "haya14busa/vim-asterisk",
      config = function()
        vim.api.nvim_set_keymap('n', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
        vim.api.nvim_set_keymap('n', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
        vim.api.nvim_set_keymap('n', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
        vim.api.nvim_set_keymap('n', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})

        vim.api.nvim_set_keymap('x', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
        vim.api.nvim_set_keymap('x', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
        vim.api.nvim_set_keymap('x', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
        vim.api.nvim_set_keymap('x', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
      end
    }

    -- search and replace
    use { "nvim-pack/nvim-spectre", requires = { "nvim-lua/plenary.nvim" } }

    -- file system navigation
    use { "nvim-neo-tree/neo-tree.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      },
      config = function()
        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

        vim.fn.sign_define("DiagnosticSignError",
          { text = " ", texthl = "DiagnosticSignError" })
        vim.fn.sign_define("DiagnosticSignWarn",
          { text = " ", texthl = "DiagnosticSignWarn" })
        vim.fn.sign_define("DiagnosticSignInfo",
          { text = " ", texthl = "DiagnosticSignInfo" })
        vim.fn.sign_define("DiagnosticSignHint",
          { text = "", texthl = "DiagnosticSignHint" })

        vim.keymap.set("n", "<leader><Tab>", "<Cmd>Neotree toggle<CR>", { desc = "open file tree" })
        vim.keymap.set("n", "gp", "<Cmd>Neotree reveal_force_cwd<CR>",
          { desc = "change working directory to current file location" })

        -- Remap :Ex, :Sex to Neotree
        vim.cmd(":command! Ex Neotree toggle current reveal_force_cwd")
        vim.cmd(":command! Sex sp | Neotree toggle current reveal_force_cwd")

        require("neo-tree").setup({
          filesystem = {
            filtered_items = {
              hide_dotfiles = false,
              hide_gitignored = true,
              hide_by_name = {
                "node_modules"
              },
            },
            hijack_netrw_behavior = "open_current",
          },
        })
      end
    }

    -- status line
    use { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } }

    -- code comments
    use {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()

        vim.keymap.set("n", "<leader><leader><leader>", "<Cmd>norm gcc<CR>", { desc = "comment a single line" })
        vim.keymap.set("v", "<leader><leader><leader>", "<Plug>(comment_toggle_linewise_visual)",
          { desc = "comment multiple lines" })
      end
    }

    -- git change indicator
    use "lewis6991/gitsigns.nvim"

    -- git history
    use { "sindrets/diffview.nvim", requires = { "nvim-lua/plenary.nvim" } }

    -- indentation autopairing
    use { "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup {}
      end
    }

    -- highlighters and indicators
    use { "RRethy/vim-illuminate", -- word usage highlighter
      config = function()
        -- vim.cmd("highlight illuminatedWord guifg=red guibg=white")
        -- vim.api.nvim_command [[ highlight LspReferenceText guifg=red guibg=white ]]
        -- vim.api.nvim_command [[ highlight LspReferenceWrite guifg=red guibg=white ]]
        -- vim.api.nvim_command [[ highlight LspReferenceRead guifg=red guibg=white ]]
      end
    }
    use { "jinh0/eyeliner.nvim", -- jump to word indictors
      config = function()
        vim.api.nvim_set_hl(0, "EyelinerPrimary", { underline = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
          pattern = {
            "*"
          },
          callback = function()
            vim.api.nvim_set_hl(0, "EyelinerPrimary", { underline = true })
          end
        })
      end
    }
    use "DanilaMihailov/beacon.nvim" -- cursor movement highlighter

    -- modify surrounding characters
    use({
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup()
      end
    })

    -- camel case motion support
    -- NOTE: custom mappings (../plugins/config/camelcasemotion.lua) auto-loaded by ../../init.lua
    use "bkad/CamelCaseMotion"

    -- highlight yanked region
    use "machakann/vim-highlightedyank"

    -- move lines around
    use "matze/vim-move"

    -- open lines in github
    use { "ruanyl/vim-gh-line",
      config = function()
        vim.g.gh_line_map = "<leader><leader>gl"
      end
    }

    -- suggest mappings
    use { "folke/which-key.nvim",
      config = function()
        require("which-key").setup()
      end
    }

    -- display hex colours
    use { "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end
    }

    -- generate hex colours
    use { "uga-rosa/ccc.nvim" }

    -- gui improvements
    --
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
          },
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

    -- window picker
    use { "s1n7ax/nvim-window-picker", tag = "v1.*",
      config = function()
        local picker = require("window-picker")
        picker.setup({
          fg_color = "#000000",
        })

        vim.keymap.set("n", "<leader><leader>w", function()
          local picked_window_id = picker.pick_window() or vim.api.nvim_get_current_win()
          vim.api.nvim_set_current_win(picked_window_id)
        end, { desc = "Pick a window" })
      end,
    }

    -- window zoom (avoids layout reset from <Ctrl-w>=)
    -- Caveat: NeoZoom doesn't play well with workflows that use the quickfix window.
    use { "nyngwang/NeoZoom.lua",
      config = function()
        require('neo-zoom').setup({
          left_ratio = 0.2,
          top_ratio = 0,
          width_ratio = 0.6,
          height_ration = 1,
        })
        vim.keymap.set("", "<leader><leader>z", "<Cmd>NeoZoomToggle<CR>", { desc = "full screen active window" })
      end
    }
    -- windows.nvim is more like the traditional <Ctrl-w>_ and <Ctrl-w>|
    use { "anuvyklack/windows.nvim",
      requires = {
        "anuvyklack/middleclass",
      },
      config = function()
        vim.o.winwidth = 1
        vim.o.winminwidth = 0
        vim.o.equalalways = false
        require("windows").setup({
          autowidth = {
            enable = false, -- prevents messing up simrat39/symbols-outline.nvim (e.g. relative width of side-bar was being made larger)
          }
        })

        local function cmd(command)
          return table.concat({ "<Cmd>", command, "<CR>" })
        end

        vim.keymap.set("n", "<C-w>\\", cmd "WindowsMaximize")
        vim.keymap.set("n", "<C-w>_", cmd "WindowsMaximizeVertically")
        vim.keymap.set("n", "<C-w>|", cmd "WindowsMaximizeHorizontally")
        vim.keymap.set("n", "<C-w>=", cmd "WindowsEqualize")
      end
    }

    -- whitespace management
    use { "zakharykaplan/nvim-retrail",
      config = function()
        require("retrail").setup({
          filetype = {
            exclude = {
              "markdown",
              "neo-tree",
              -- following are defaults that need to be added or they'll be overridden
              "",
              "alpha",
              "checkhealth",
              "diff",
              "help",
              "lspinfo",
              "man",
              "mason",
              "TelescopePrompt",
              "Trouble",
              "WhichKey",
            }
          }
        })
      end
    }

    -- buffer scroll context
    use { "nvim-treesitter/nvim-treesitter-context", requires = "nvim-treesitter/nvim-treesitter",
      config = function()
        require("treesitter-context").setup({
          separator = "-",
        })
      end
    }

    -- lsp
    use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "Afourcat/treesitter-terraform-doc.nvim",
    }
    require("mason").setup()
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      ensure_installed = {
        "eslint",
        "sumneko_lua",
        "marksman",
        "terraformls",
        "tflint",
        "tsserver",
        "yamlls",
      }
    })
    mason_lspconfig.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          on_attach = function(client, bufnr)
            require("settings/shared").on_attach(client, bufnr)
            require("illuminate").on_attach(client)

            if server_name == "terraformls" then
              require("treesitter-terraform-doc").setup()
            end
          end
        })
      end
    })
    use { "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup()
      end
    }
    use { "folke/trouble.nvim",
      config = function()
        require("trouble").setup()
      end
    }
    use({
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim", -- See also: https://github.com/Maan2003/lsp_lines.nvim
      config = function()
        require("lsp_lines").setup()

        -- disable virtual_text since it's redundant due to lsp_lines.
        vim.diagnostic.config({
          virtual_text = false,
        })
      end,
    })
    use { "simrat39/symbols-outline.nvim",
      config = function()
        require("symbols-outline").setup({
          auto_close = true,
        })
      end
    }
    use { "kosayoda/nvim-lightbulb", requires = { "antoinemadec/FixCursorHold.nvim" } }
    use "folke/lsp-colors.nvim"
    use "mfussenegger/nvim-lint"
    use "weilbith/nvim-code-action-menu"
    use "simrat39/rust-tools.nvim"
    use { "saecki/crates.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("crates").setup()
      end,
    }
    use "lvimuser/lsp-inlayhints.nvim" -- rust-tools already provides this feature, but gopls doesn't

    -- null-ls
    use { "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("null-ls").setup({
          sources = {
            require("null-ls").builtins.diagnostics.checkmake, -- https://github.com/mrtazz/checkmake
          }
        })
      end
    }

    -- autocomplete
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "hrsh7th/cmp-path"
    use { "L3MON4D3/LuaSnip",
      requires = { "saadparwaiz1/cmp_luasnip" },
      config = function()
        require("luasnip.loaders.from_lua").load({ paths = "~/.snippets" })
      end
    }

    -- debugging
    use "mfussenegger/nvim-dap"
    use { "rcarriga/nvim-dap-ui",
      requires = { "mfussenegger/nvim-dap" },
      config = function()
        require("dapui").setup()
      end
    }
    use { "leoluz/nvim-dap-go",
      requires = { "mfussenegger/nvim-dap" },
      run = "go install github.com/go-delve/delve/cmd/dlv@latest",
      config = function()
        require("dap-go").setup()
      end
    }
    use { "theHamsta/nvim-dap-virtual-text",
      requires = { "mfussenegger/nvim-dap" },
      config = function()
        require("nvim-dap-virtual-text").setup()
      end
    }

    -- writing
    use { "marcelofern/vale.nvim",
      config = function()
        require("vale").setup({
          bin = "/usr/local/bin/vale",
          vale_config_path = "$HOME/.vale.ini",
        })
      end
    }

    -- swappable arguments and list elements
    use { "mizlan/iswap.nvim",
      config = function()
        require("iswap").setup()
      end
    }

    -- terminal management
    use { "akinsho/toggleterm.nvim",
      tag = "v2.*",
      config = function()
        require("toggleterm").setup()
      end
    }

    -- ui improvements
    use { "stevearc/dressing.nvim",
      config = function()
        require("dressing").setup()
      end
    }

    -- surface any TODO or NOTE code references
    use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup()
      end
    }

    -- block sorter
    use "chiedo/vim-sort-blocks-by"

    -- automatically set up your configuration after cloning packer.nvim
    -- put this at the end after all plugins
    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    git = {
      clone_timeout = 120
    }
  }
})

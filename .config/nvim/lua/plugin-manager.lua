--[[
Ensure https://github.com/wbthomason/packer.nvim is cloned inside of the ~/.config/nvim/pack directory.
.
└── pack
    └── packer
        └── start
            └── packer.nvim

Then execute :PackerSync

Plugins will be compiled into the ~/.config/nvim/plugin directory.
--]]

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost *.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup({
  function()
    -- plugin manager
    use "wbthomason/package.nvim"

    -- colorschemes
    use "gruvbox-community/gruvbox"
    use "EdenEast/nightfox.nvim"

    -- syntax tree parsing for more intelligent syntax highlighting and code navigation
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
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

    -- file system navigation
    use { "kyazdani42/nvim-tree.lua", 
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function()
        require("nvim-tree").setup({
          renderer = {
            indent_markers = {
              enable = true
            }
          },
        })
      end
    }

    -- status line
    use { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } }

    -- pattern searching
    use "mileszs/ack.vim"

    -- code comments
    use "b3nj5m1n/kommentary"

    -- git change indicator
    use { "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end
    }

    -- ui improvements
    use { "stevearc/dressing.nvim",
      config = function()
        require("dressing").setup()
      end
    }

    -- motion highlighter
    use "unblevable/quick-scope"

    -- modify surrounding characters
    use "tpope/vim-surround"

    -- camel case motion support
    use "bkad/CamelCaseMotion"

    -- search indexer
    use "google/vim-searchindex"

    -- highlight yanked region
    use "machakann/vim-highlightedyank"

    -- move lines around
    use "matze/vim-move"

    -- open lines in github
    use "ruanyl/vim-gh-line"

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

    -- tab ui improvments
    use { "kdheepak/tabline.nvim", 
      config = function()
        require("tabline").setup({
          options = {
            show_tabs_only = true
          }
        })
      end
    }

    -- git history
    use { "sindrets/diffview.nvim", requires = { "nvim-lua/plenary.nvim" } }

    -- search and replace
    use { "nvim-pack/nvim-spectre", requires = { "nvim-lua/plenary.nvim" } }

    -- lsp
    use "neovim/nvim-lspconfig"
    use { "williamboman/nvim-lsp-installer",
      config = function()
        require("nvim-lsp-installer").setup()

        -- NOTE: When using :LspInstallInfo to install available LSPs, we need to still
        -- add calls to their setup here in our Vim configuration.
        --
        -- These must be located here, as otherwise if placed inside 
        -- plugin/lsp-config.lua we would find that file is loaded first before 
        -- we have even setup nvim-lsp-installer.
        local lspcfg = require("lspconfig")
        lspcfg.quick_lint_js.setup{}
        lspcfg.terraformls.setup({
          on_attach = require("shared").on_attach,
        })
        lspcfg.tflint.setup{}
        lspcfg.tsserver.setup{}
      end
    }
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
    use { "kosayoda/nvim-lightbulb", requires = { "antoinemadec/FixCursorHold.nvim" } }
    use "folke/lsp-colors.nvim"
    use "mfussenegger/nvim-lint"
    use "weilbith/nvim-code-action-menu"
    use "simrat39/rust-tools.nvim"

    -- autocomplete
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
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
  end,
  config = {
    git = {
      clone_timeout = 120
    }
  }
})

--[[
The configuration in this file should automatically install packer.nvim for you.

To update the configured packages (see below), execute the :PackerSync command.

Plugins will be compiled into:
/Users/integralist/.local/share/nvim/site/pack/packer/start

The ~/.config/nvim/plugin directory contains my own configuration files + the compiled package plugin.

NOTE: The plugin mappings defined have the following convention:

* Single <leader> for search operations (inc. file explorer + search/replace)
* Double <leader> for all other mappings

This helps to avoid overlap in letters.
--]]

-- dump will return the contents of a table so it can be printed.
local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- ends_with returns a bool indicating if the str ends with the specified substring.
local function ends_with(str, ending)
  return ending == "" or str:sub(- #ending) == ending
end

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
    use "kvrohit/mellow.nvim"

    -- make dot operator work in a sensible way
    use "tpope/vim-repeat"

    -- syntax tree parsing for more intelligent syntax highlighting and code navigation
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "bash", "c", "cmake", "css", "dockerfile", "go", "gomod", "gowork", "hcl", "help", "html",
            "http", "javascript", "json", "lua", "make", "markdown", "python", "regex", "ruby", "rust", "toml", "vim",
            "yaml", "zig" },
          highlight = {
            enable = true,
          },
          rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = nil,
          }
        })
      end
    }
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
    use { "nvim-treesitter/nvim-treesitter-context", requires = "nvim-treesitter/nvim-treesitter",
      config = function()
        require("treesitter-context").setup({
          separator = "-",
        })
      end
    } -- buffer scroll context

    -- searching
    use {
      "nvim-telescope/telescope.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        --[[
          Opening mulitple files doesn't work by default.

          You can either following the implementation detailed here:
          https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1220846367

          Or you can have a more complex workflow:
          - Select multiple files using <Tab>
          - Send the selected files to the quickfix window using <C-o>
          - Search the quickfix window (using either :copen or <leader>q)

          NOTE: Scroll the preview window using <C-d> and <C-u>.
        ]]
        local actions = require("telescope.actions")
        local ts = require("telescope")

        ts.setup({
          defaults = {
            mappings = {
              i = {
                ["<esc>"] = actions.close,
                ["<C-o>"] = actions.send_selected_to_qflist,
              },
            },
          },
          extensions = {
            heading = {
              treesitter = true,
            },
          },
        })

        ts.load_extension("changed_files")
        ts.load_extension("emoji")
        ts.load_extension("fzf")
        ts.load_extension("heading")
        ts.load_extension("ui-select")
        ts.load_extension("windows")

        vim.g.telescope_changed_files_base_branch = "main"

        vim.keymap.set("n", "<leader>b", "<Cmd>Telescope buffers<CR>", { desc = "search buffers" })
        vim.keymap.set("n", "<leader>c", "<Cmd>Telescope colorscheme<CR>", { desc = "search colorschemes" })
        vim.keymap.set("n", "<leader>d", "<Cmd>TodoTelescope<CR>", { desc = "search TODOs" })
        vim.keymap.set("n", "<leader>ej", "<Cmd>Telescope emoji<CR>", { desc = "search emojis" })
        vim.keymap.set("n", "<leader>ex", "<Cmd>Telescope commands<CR>", { desc = "search Ex commands" })
        vim.keymap.set("n", "<leader>f", "<Cmd>Telescope find_files hidden=true<CR>", { desc = "search files" })
        vim.keymap.set("n", "<leader>g", "<Cmd>Telescope changed_files<CR>", { desc = "search changed files" })
        vim.keymap.set("n", "<leader>h", "<Cmd>Telescope help_tags<CR>", { desc = "search help" })
        vim.keymap.set("n", "<leader>i", "<Cmd>Telescope builtin<CR>", { desc = "search builtins" })
        vim.keymap.set("n", "<leader>k", "<Cmd>Telescope keymaps<CR>", { desc = "search key mappings" })
        vim.keymap.set("n", "<leader>ld", "<Cmd>Telescope diagnostics<CR>", { desc = "search lsp diagnostics" })
        vim.keymap.set("n", "<leader>li", "<Cmd>Telescope lsp_incoming_calls<CR>", { desc = "search lsp incoming calls" })
        vim.keymap.set("n", "<leader>lo", "<Cmd>Telescope lsp_outgoing_calls<CR>", { desc = "search lsp outgoing calls" })
        vim.keymap.set("n", "<leader>lr", "<Cmd>Telescope lsp_references<CR>", { desc = "search lsp code reference" })
        vim.keymap.set("n", "<leader>ls", "<Cmd>Telescope lsp_document_symbols<CR>",
          { desc = "search lsp document tree" })
        vim.keymap.set("n", "<leader>m", "<Cmd>Telescope heading<CR>", { desc = "search markdown headings" })
        vim.keymap.set("n", "<leader>n", "<Cmd>Noice telescope<CR>", { desc = "search messages handled by Noice plugin" })
        vim.keymap.set("n", "<leader>q", "<Cmd>Telescope quickfix<CR>", { desc = "search quickfix list" })
        vim.keymap.set("n", "<leader>r", "<Cmd>Telescope current_buffer_fuzzy_find<CR>",
          { desc = "search current buffer text" })
        vim.keymap.set("n", "<leader>s", "<Cmd>Telescope treesitter<CR>", { desc = "search symbols" })
        vim.keymap.set("n", "<leader>w", "<Cmd>Telescope windows<CR>", { desc = "search windows" })
        vim.keymap.set("n", "<leader>x", "<Cmd>Telescope live_grep<CR>", { desc = "search text" })
      end
    }
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

    -- surface any TODO or NOTE code references
    use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup()
      end
    }

    -- pattern searching
    use {
      "mileszs/ack.vim",
      config = function()
        vim.g.ackprg = "rg --vimgrep --smart-case --hidden"
      end
    }

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
    use {
      "nvim-pack/nvim-spectre",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("spectre").setup({
          replace_engine = {
            ["sed"] = {
              cmd = "gsed",
            },
          },
        })
        vim.keymap.set("n", "<leader>S", "<Cmd>lua require('spectre').open()<CR>", { desc = "search and replace" })
      end
    }

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
    use { "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
      config = function()
        require("lualine").setup({})
      end
    }

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
    use {
      "lewis6991/gitsigns.nvim",
      config = function()
        vim.api.nvim_set_hl(0, "GitSignsChange", { link = "GruvboxYellowSign" })

        require("gitsigns").setup({
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            map('n', ']c', function()
              if vim.wo.diff then return ']c' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end, { desc = "next change hunk", expr = true })

            map('n', '[c', function()
              if vim.wo.diff then return '[c' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, { desc = "prev change hunk", expr = true })

            map('n', '<leader><leader>gb', function()
              gs.blame_line { full = true }
            end, { desc = "git blame" })

            map('n', '<leader><leader>gs', function()
              gs.blame_line {}
            end, { desc = "git blame short" })

            map('n', '<leader><leader>gd', gs.diffthis, { desc = "git diff (:q to close)" })
          end
        })
      end
    }

    -- git history
    use {
      "sindrets/diffview.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("diffview").setup()
        vim.keymap.set("n", "<leader><leader>gh", "<Cmd>DiffviewFileHistory<CR>", { desc = "diff history" })
        vim.keymap.set("n", "<leader><leader>go", "<Cmd>DiffviewOpen<CR>", { desc = "diff open" })
        vim.keymap.set("n", "<leader><leader>gc", "<Cmd>DiffviewClose<CR>", { desc = "diff close" })
      end
    }

    -- open lines in github
    use { "ruanyl/vim-gh-line",
      config = function()
        vim.g.gh_line_map = "<leader><leader>gl"
      end
    }

    -- indentation autopairing
    use { "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup {}
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
    use "machakann/vim-highlightedyank" -- highlight yanked region
    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup()
      end
    } -- suggest mappings

    -- modify surrounding characters
    use({
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup()
      end
    })

    -- camel case motion support
    -- NOTE: custom mappings (../plugins/config/camelcasemotion.lua) auto-loaded by ../../init.lua
    use {
      "bkad/CamelCaseMotion",
      config = function()
        vim.keymap.set('', 'w', '<Plug>CamelCaseMotion_w', { silent = true })
        vim.keymap.set('', 'b', '<Plug>CamelCaseMotion_b', { silent = true })
        vim.keymap.set('', 'e', '<Plug>CamelCaseMotion_e', { silent = true })
        vim.keymap.set('', 'ge', '<Plug>CamelCaseMotion_ge', { silent = true })
      end
    }

    -- move lines around
    use { "matze/vim-move",
      config = function()
        vim.g.move_key_modifier = "C"
        vim.g.move_key_modifier_visualmode = "S" -- e.g. Shift-k to move up, Shift-j to move down
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
        "gopls", -- WARNING: This could be an issue with goenv switching.
        "marksman",
        "rust_analyzer",
        "sumneko_lua",
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

        local bufopts = { noremap = true, silent = true }
        vim.keymap.set("n", "<leader><leader>lc", "<Cmd>TroubleClose<CR>", bufopts)
        vim.keymap.set("n", "<leader><leader>li", "<Cmd>TroubleToggle document_diagnostics<CR>", bufopts)
        vim.keymap.set("n", "<leader><leader>lw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", bufopts)
        vim.keymap.set("n", "<leader><leader>lr", "<Cmd>TroubleToggle lsp_references<CR>", bufopts)
        vim.keymap.set("n", "<leader><leader>lq", "<Cmd>TroubleToggle quickfix<CR>", bufopts)
        vim.keymap.set("n", "<leader><leader>ll", "<Cmd>TroubleToggle loclist<CR>", bufopts)
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
          -- autofold_depth = 1, -- h: close, l: open, W: close all, E: open all
          auto_close = false,
          highlight_hovered_item = true,
          position = "left",
          width = 15,
          symbols = {
            File = { icon = "", hl = "GruvboxAqua" }, -- TSURI
            Module = { icon = "", hl = "GruvboxBlue" }, -- TSNamespace
            Namespace = { icon = "", hl = "GruvboxBlue" }, -- TSNamespace
            Package = { icon = "", hl = "GruvboxBlue" }, -- TSNamespace
            Class = { icon = "𝓒", hl = "GruvboxGreen" }, -- TSType
            Method = { icon = "ƒ", hl = "GruvboxOrange" }, -- TSMethod
            Property = { icon = "", hl = "GruvboxOrange" }, -- TSMethod
            Field = { icon = "", hl = "GruvboxRed" }, -- TSField
            Constructor = { icon = "", hl = "TSConstructor" },
            Enum = { icon = "ℰ", hl = "GruvboxGreen" }, -- TSType
            Interface = { icon = "ﰮ", hl = "GruvboxGreen" }, -- TSType
            Function = { icon = "", hl = "GruvboxYellow" }, -- TSFunction
            Variable = { icon = "", hl = "GruvboxPurple" }, -- TSConstant
            Constant = { icon = "", hl = "GruvboxPurple" }, -- TSConstant
            String = { icon = "𝓐", hl = "GruvboxGray" }, -- TSString
            Number = { icon = "#", hl = "TSNumber" },
            Boolean = { icon = "⊨", hl = "TSBoolean" },
            Array = { icon = "", hl = "GruvboxPurple" }, -- TSConstant
            Object = { icon = "⦿", hl = "GruvboxGreen" }, -- TSType
            Key = { icon = "🔐", hl = "GruvboxGreen" }, -- TSType
            Null = { icon = "NULL", hl = "GruvboxGreen" }, -- TSType
            EnumMember = { icon = "", hl = "GruvboxRed" }, -- TSField
            Struct = { icon = "𝓢", hl = "GruvboxGreen" }, -- TSType
            Event = { icon = "🗲", hl = "GruvboxGreen" }, -- TSType
            Operator = { icon = "+", hl = "TSOperator" },
            TypeParameter = { icon = "𝙏", hl = "GruvboxRed" } --TTSParameter
          },
        })
      end
    }
    use {
      "gorbit99/codewindow.nvim",
      config = function()
        require("codewindow").setup({
          auto_enable = true,
          use_treesitter = true, -- disable to lose colours
          exclude_filetypes = { "Outline", "neo-tree", "qf", "packer", "help", "noice" }
        })
        vim.api.nvim_set_keymap("n", "<leader><leader>m", "<cmd>lua require('codewindow').toggle_minimap()<CR>",
          { noremap = true, silent = true, desc = "Toggle minimap" })
      end,
    }
    use {
      "kosayoda/nvim-lightbulb",
      config = function()
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          pattern = "*",
          command = "lua require('nvim-lightbulb').update_lightbulb()"
        })
      end
    }
    use "folke/lsp-colors.nvim"
    use {
      "mfussenegger/nvim-lint",
      config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
          go = { "golangcilint" }, -- ~/.golangci.yml
        }
        -- see ./lsp.lua for calls to this plugin's try_lint() function.
      end
    }
    use {
      "weilbith/nvim-code-action-menu",
      config = function()
        vim.keymap.set("n", "<leader><leader>la", "<Cmd>CodeActionMenu<CR>", {
          noremap = true,
          desc = "code action menu"
        })
        vim.g.code_action_menu_window_border = "single"
      end
    }
    use "simrat39/rust-tools.nvim"
    use {
      "saecki/crates.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("crates").setup()
      end,
    }
    use "lvimuser/lsp-inlayhints.nvim" -- rust-tools already provides this feature, but gopls doesn't

    --[[
      NOTE: I currently manually attach my shared mappings for each LSP server.
      But, we can set a generic one using lspconfig:

      require("lspconfig").util.default_config.on_attach = function()
    --]]

    local function org_imports(wait_ms)
      local params = vim.lsp.util.make_range_params()
      params.context = { only = { "source.organizeImports" } }
      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
          else
            vim.lsp.buf.execute_command(r.command)
          end
        end
      end
    end

    require("lspconfig").gopls.setup({
      on_attach = function(client, bufnr)
        require("settings/shared").on_attach(client, bufnr)
        require("lsp-inlayhints").setup({
          inlay_hints = {
            type_hints = {
              prefix = "=> "
            },
          },
        })
        require("lsp-inlayhints").on_attach(client, bufnr)
        require("illuminate").on_attach(client)

        -- autocommands can overlap and consequently not run
        -- for example, a generic "*" wildcard pattern will override another autocmd even if it has a more specific pattern
        local id = vim.api.nvim_create_augroup("GoLint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          group = id,
          pattern = "*.go",
          callback = function()
            -- NOTE: ../../settings/shared.lua has a broader wildcard executing formatting.
            org_imports(1000)
            require("lint").try_lint() -- golangci-lint configuration via ./nvim-lint.lua
          end,
        })

        vim.keymap.set(
          "n", "<leader><leader>lv",
          "<Cmd>cex system('revive -exclude vendor/... ./...') | cwindow<CR>",
          {
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = "lint project code"
          }
        )
      end,
      settings = {
        gopls = {
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          experimentalPostfixCompletions = true,
          gofumpt = true,
          staticcheck = true,
          usePlaceholders = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          }
        },
      },
    })

    require("rust-tools").setup({
      -- rust-tools options
      tools = {
        autoSetHints = true,
        inlay_hints = {
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
        },
      },

      -- all the opts to send to nvim-lspconfig
      -- these override the defaults set by rust-tools.nvim
      --
      -- REFERENCE:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      -- https://rust-analyzer.github.io/manual.html#configuration
      -- https://rust-analyzer.github.io/manual.html#features
      --
      -- NOTE: The configuration format is `rust-analyzer.<section>.<property>`.
      --       <section> should be an object.
      --       <property> should be a primitive.
      server = {
        on_attach = function(client, bufnr)
          require("settings/shared").on_attach(client, bufnr)
          require("illuminate").on_attach(client)

          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', '<leader><leader>rr', "<Cmd>RustRunnables<CR>", bufopts)
          vim.keymap.set('n', 'K', "<Cmd>RustHoverActions<CR>", bufopts)
        end,
        ["rust-analyzer"] = {
          assist = {
            importEnforceGranularity = true,
            importPrefix = "crate"
          },
          cargo = {
            allFeatures = true
          },
          checkOnSave = {
            -- default: `cargo check`
            command = "clippy",
            allFeatures = true,
          },
        },
        inlayHints = { -- NOT SURE THIS IS VALID/WORKS 😬
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true
          },
        },
      }
    })

    -- null-ls
    use { "jose-elias-alvarez/null-ls.nvim",
      config = function()
        local null_ls = require("null-ls")
        local helpers = require("null-ls.helpers") -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/HELPERS.md

        local tfproviderlintx = {
          name = "tfproviderlintx",
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "go" },
          generator = helpers.generator_factory({
            args = { "-XAT001=false", "-R018=false", "$FILENAME" },
            check_exit_code = function(code, stderr)
              local success = code < 1
              if not success then
                print(stderr)
              end
              return success
            end,
            command = "tfproviderlintx",
            format = "line",
            from_stderr = true,
            on_output = helpers.diagnostics.from_patterns({
              {
                -- EXAMPLE:
                -- /Users/integralist/Code/EXAMPLE/example.go:123:456: an error code: whoops you did X wrong
                pattern = "([^:]+):(%d+):(%d+):%s([^:]+):%s(.+)", -- Lua patterns https://www.lua.org/pil/20.2.html
                groups = { "path", "row", "col", "code", "message" },
              },
            }),
            -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/6a98411e70fad6928f7311eeade4b1753cb83524/doc/BUILTIN_CONFIG.md#runtime_condition
            --
            -- We can improve performance by caching this operation:
            -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/6a98411e70fad6928f7311eeade4b1753cb83524/doc/HELPERS.md#cache
            --
            -- Example:
            -- helpers.cache.by_bufnr(function(params) ... end)
            runtime_condition = function(params)
              -- params spec can be found here:
              -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/1569ad4817492e0daefa4e1bcf55f8280cdc82db/doc/MAIN.md#generators
              return params.bufname:find("terraform%-provider%-") ~= nil -- % is a character escape
            end,
            to_stdin = true,
          }),
        }

        local revive = {
          name = "revive",
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "go" },
          generator = helpers.generator_factory({
            args = {
              "-set_exit_status",
              "-config=/Users/integralist/revive-single-file.toml",
              "-exclude=vendor/...",
              "$FILENAME"
            },
            check_exit_code = function(code)
              return code < 1
            end,
            command = "revive",
            format = "line",
            from_stderr = true,
            on_output = helpers.diagnostics.from_patterns({
              {
                -- EXAMPLE:
                -- /Users/integralist/Code/EXAMPLE/example.go:123:456: whoops you did X wrong
                pattern = "([^:]+):(%d+):(%d+):%s(.+)", -- Lua patterns https://www.lua.org/pil/20.2.html
                groups = { "path", "row", "col", "message" },
              },
            }),
            to_stdin = true,
          }),
        }

        null_ls.setup({
          sources = {
            tfproviderlintx,
            revive,
            require("null-ls").builtins.diagnostics.checkmake, -- https://github.com/mrtazz/checkmake
          }
        })
      end
    }

    -- autocomplete
    use {
      "hrsh7th/nvim-cmp",
      config = function()
        local cmp = require("cmp")

        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = {
            ["<Up>"] = cmp.mapping.select_prev_item(),
            ["<Down>"] = cmp.mapping.select_next_item(),
            ["<Left>"] = cmp.mapping.select_prev_item(),
            ["<Right>"] = cmp.mapping.select_next_item(),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            })
          },
          sources = cmp.config.sources({
            -- ordered by priority
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "path" },
            { name = "buffer" },
            { name = "luasnip" },
            { name = "nvim_lua" },
          }),
        })

        cmp.setup.cmdline({ "/", "?" }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer" }
          }
        })

        cmp.setup.cmdline({ ":" }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "cmdline" },
            { name = "path" }
          }
        })
      end
    }
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "hrsh7th/cmp-path"
    use {
      "L3MON4D3/LuaSnip",
      requires = { "saadparwaiz1/cmp_luasnip" },
      config = function()
        local keymap = vim.api.nvim_set_keymap
        local opts = { noremap = true, silent = true }
        keymap("i", "<leader><leader>'", "<cmd>lua require('luasnip').jump(1)<CR>", opts)
        keymap("i", "<leader><leader>;", "<cmd>lua require('luasnip').jump(-1)<CR>", opts)
        require("luasnip.loaders.from_lua").load({ paths = "~/.snippets" })
      end
    }

    -- debugging
    use {
      "mfussenegger/nvim-dap",
      config = function()
        vim.keymap.set("n", "<leader><leader>dc", "<Cmd>lua require('dap').continue()<CR>", { desc = "start debugging" })
        vim.keymap.set("n", "<leader><leader>do", "<Cmd>lua require('dap').step_over()<CR>", { desc = "step over" })
        vim.keymap.set("n", "<leader><leader>di", "<Cmd>lua require('dap').step_into()<CR>", { desc = "step into" })
        vim.keymap.set("n", "<leader><leader>dt", "<Cmd>lua require('dap').step_out()<CR>", { desc = "step out" })
        vim.keymap.set("n", "<leader><leader>db", "<Cmd>lua require('dap').toggle_breakpoint()<CR>",
          { desc = "toggle breakpoint" })
        vim.keymap.set("n", "<leader><leader>dv",
          "<Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
          { desc = "toggle breakpoint" })
        vim.keymap.set("n", "<leader><leader>dr", "<Cmd>lua require('dap').repl.open()<CR>", { desc = "open repl" })
        vim.keymap.set("n", "<leader><leader>du", "<Cmd>lua require('dapui').toggle()<CR>", { desc = "toggle dap ui" })
      end
    }
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

    -- block sorter
    use "chiedo/vim-sort-blocks-by"

    -- terminal management
    use {
      "akinsho/toggleterm.nvim",
      tag = "v2.*",
      config = function()
        require("toggleterm").setup()

        local Terminal = require('toggleterm.terminal').Terminal
        local htop     = Terminal:new({ cmd = "htop", hidden = true, direction = "float" })

        -- NOTE: This is a global function so it can be called from the below mapping.
        function Htop_toggle()
          htop:toggle()
        end

        vim.api.nvim_set_keymap("n", "<leader><leader>th", "<cmd>lua Htop_toggle()<CR>",
          { noremap = true, silent = true, desc = "toggle htop" })

        vim.keymap.set("n", "<leader><leader>tf", "<Cmd>ToggleTerm direction=float<CR>",
          { desc = "toggle floating terminal" })
      end
    }

    -- The following code loads our plugins based on their category group (e.g. autocomplete, lsp, search etc).
    local plugins = vim.api.nvim_get_runtime_file("lua/plugins/*.lua", true)
    for _, v in ipairs(plugins) do -- NOTE: ipairs() keeps key order, pairs() doesn't.
      for _, s in ipairs(vim.split(v, "/lua/")) do
        -- skip init.lua as that is this file and would cause an infinite loop!
        -- but ensure we don't accidentally try to load the directory itself (i.e. .config/nvim)
        if not ends_with(s, "/init.lua") and ends_with(s, ".lua") then
          for _, p in ipairs(vim.split(s, "[.]lua")) do
            if (p ~= "") then
              require(p).init(use)
            end
          end
        end
      end
    end

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

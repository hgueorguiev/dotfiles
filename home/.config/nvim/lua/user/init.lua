local telescope_actions = require("telescope.actions")
local gps = require("nvim-gps")

local config = {

  -- Set colorscheme
  colorscheme = "duskfox",

  -- Default theme configuration
  default_theme = {
    diagnostics_style = { italic = true, bold = true },
    -- Modify the color table
    colors = {
      fg = "#abb2bf",
    },
    -- Modify the highlight groups
    highlights = function(highlights)
      local C = require "default_theme.colors"

      highlights.Normal = { fg = C.fg, bg = C.bg }
      return highlights
    end,
  },

  -- Disable default plugins
  enabled = {
    bufferline = true,
    neo_tree = true,
    lualine = true,
    gitsigns = true,
    colorizer = true,
    toggle_term = true,
    comment = true,
    symbols_outline = true,
    indent_blankline = true,
    dashboard = true,
    which_key = true,
    neoscroll = true,
    ts_rainbow = true,
    ts_autotag = true,
  },

  -- Disable AstroNvim ui features
  ui = {
    nui_input = true,
    telescope_select = true,
  },

  -- Configure plugins
  plugins = {
    
    -- Add plugins, the packer syntax without the "use"
    init = {
      -- Themes 
      { "folke/tokyonight.nvim",
        config = function()
          -- vim.g.tokyonight_style = "storm"
          -- vim.cmd "colorscheme tokyonight"
        end,
      },
      { "EdenEast/nightfox.nvim",
        config = function()
          require("nightfox").setup({
            options = {
              dim_inactive = true,
              styles = {
                comments = "italic",
              },
            }
          })

          vim.cmd "colorscheme duskfox"
        end,
      },
      -- --
      { "tpope/vim-surround" },
      { "justinmk/vim-sneak" },
      { "bkad/CamelCaseMotion" },
      {
	      "SmiteshP/nvim-gps",
	      requires = "nvim-treesitter/nvim-treesitter",
	      config = function()
           require("nvim-gps").setup()
        end,
      },
      -- { "andweebopresence.nvim" },
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },
    },
    -- All other entries override the setup() call for default plugins
    telescope =  {
      defaults = {
        layout_config = {
          horizontal = {
            prompt_position = "bottom",
          },
        },
        mappings = {
          i = {
            -- ["<C-1>"] = telescope_actions.send_selected_to_qflist + telescope_actions.open_qflist,
          },
        },
      },
    },
    gitsigns = {
      current_line_blame = true,
    },
    treesitter = {
      ensure_installed = { "lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    },
    lualine = function(dt)
      local my_section = {
			  gps.get_location,
			  cond = gps.is_available
      }
      dt["options"]["theme"] = "duskfox"
      table.insert(dt["sections"]["lualine_c"], 3, my_section)
      return dt
    end,
    -- {
    --   sections = {
			 --  lualine_c = {
			 --    {
			 --      gps.get_location,
			 --      cond = gps.is_available
			 --    }
		-- },
	   --  },
    --   options = {
    --     theme = "duskfox"
    --   }
    -- }
  },
  -- Add paths for including more VS Code style snippets in luasnip
  luasnip = {
    vscode_snippet_paths = {},
  },

  -- Modify which-key registration
  ["which-key"] = {
    -- Add bindings to the normal mode <leader> mappings
    register_n_leader = {
      s = { 
        -- Quick telescope.live_grep search from whats in the buffer search register
        ["."] = { 
                  [[:lua require('telescope.builtin').live_grep({default_text=string.gsub(string.gsub(vim.fn.getreg('/'), '\\<', ''), '\\>', '')})<CR>]],
                  "Global search for /"
                },
        -- Resume last telescope search
        ["s"] = {":lua require('telescope.builtin').resume()<CR>", "Resume search"}
      }
      -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   server:setup(opts)
    -- end

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- null-ls configuration
  ["null-ls"] = function()
    -- Formatting and linting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim
    local status_ok, null_ls = pcall(require, "null-ls")
    if not status_ok then
      return
    end

    -- Check supported formatters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting

    -- Check supported linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup {
      debug = false,
      sources = {
        -- Set a formatter
        formatting.rufo,
        formatting.yapf.with({
          args = {"--style", vim.fn.expand('~/code/catalant/catalant/setup.cfg')}
        }),
        -- Set a linter
        diagnostics.rubocop,
        diagnostics.flake8.with({
          extra_args = {"--config", vim.fn.expand('~/code/catalant/catalant/setup.cfg')}
        }),
      },
      -- NOTE: You can remove this on attach function to disable format on save
      on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end,
    }
  end,

  -- This function is run last
  -- good place to configure mappings and vim options
  polish = function()
    local map = vim.keymap.set
    local set = vim.opt
    -- Set options
    set.guicursor=[[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait10-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait10-blinkoff150-blinkon175]]
    set.relativenumber = true
    set.clipboard = nil
    set.colorcolumn = "120"
    -- Set plugins global opts
    vim.g["sneak#label"] = true
    vim.g["sneak#prompt"] = "🔎"
    vim.g["camelcasemotion_key"] = "<leader><leader>"
    -- Set key bindings
    map("n", "<C-s>", ":w!<CR>")
    map("v", "*", "\"xy/<C-R>x<CR>") -- Remap * to search for selection when in visual mode, how is this not default behavior ?!

    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", {})
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

print('Personal config loaded !')
return config

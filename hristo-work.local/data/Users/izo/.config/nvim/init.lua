-- TODO:
-- -- Null.ls formatting and linting, update for python and JS configuration
-- -- Code clean up, fix fallbacks etc.

local return_code, utils = pcall(require, "user.utils")
local return_code, t_builtin = pcall(require, "telescope.builtin")
local return_code, gps = pcall(require, "nvim-gps")
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Setup editor options
--------------------------------------------------------------------------------
vim.go.viminfo = vim.go.viminfo .. ",n~/.cache/.viminfo"
vim.opt.mouse = "a"
vim.opt.colorcolumn = "120"
vim.opt.cmdwinheight=3
---- Splits
vim.opt.splitbelow = true
---- Spelling
vim.opt.spelllang = "en"
vim.opt.spellsuggest = "best,15"
vim.opt.spell = true
---- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
---- Case for find
vim.opt.ignorecase = true
vim.opt.smartcase = true
---- Wrap
vim.opt.wrap = true
vim.opt.breakindent = true
---- Tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
---- Colors
vim.opt.termguicolors = true
vim.cmd("colorscheme afterglow")
vim.cmd("hi Normal guibg=none") -- Remove background
---- Space as leader
vim.g.mapleader = " "

--------------------------------------------------------------------------------
-- Auto commands
--------------------------------------------------------------------------------
-- Ex
-- vim.api.nvim_create_autocmd({ event = "FileType",
--                               group = "MyGroupName",
--                               pattern = "*",
--                               callback = function
--                                print("Filetype autocmd")
--                               end,
--                               once = true})
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd( -- Enter insert mode when entering a Term buffer
	{
		"BufEnter",
		"TermOpen",
	},
	{
		command = [[if &buftype == "terminal" | :startinsert | endif]],
	}
)


--------------------------------------------------------------------------------
-- Custom commands
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {})
vim.api.nvim_create_user_command("ToggleTerminalSplit", utils.toggle_terminal_split, {})

--------------------------------------------------------------------------------
-- Plugin manager
--------------------------------------------------------------------------------
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local install_plugins = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	print("Installing packer...")
	local packer_url = "https://github.com/wbthomason/packer.nvim"
	vim.fn.system({ "git", "clone", "--depth", "1", packer_url, install_path })
	print("Done.")

	vim.cmd("packadd packer.nvim")
	install_plugins = true
end

require("packer").startup(function(use)
	---- List of plugins...
	------ Lib. plugins
	use("nvim-lua/plenary.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	------ Text search/ Fuzzy finding
	use({ -- Telescope finder
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		-- or , branch = '0.1.x',
		requires = {
			{ "nvim-lua/plenary.nvim" },
		},
	})
	use("duane9/nvim-rg") -- RipGrep
	------ Package manager
	use("wbthomason/packer.nvim")
	------ Status lines
	use("nvim-lualine/lualine.nvim")
	------ Code introspection
  use({ -- LSP Server configurations
    'neovim/nvim-lspconfig'
  }) 
	use({ -- Code parser
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use({ -- Code object insights
		"SmiteshP/nvim-gps",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use({ -- Smart comments
		"numToStr/Comment.nvim",
	})
	use({ -- GIT integration
		"lewis6991/gitsigns.nvim",
	})
	use({ -- Code symbol outline
		"simrat39/symbols-outline.nvim",
	})
	------ Objects & Motions
	use({ "tpope/vim-surround" }) -- Add suround objects
	use({ "bkad/CamelCaseMotion" }) -- Add word case objects
	use("ggandor/leap.nvim") -- Match jumps
	------ Colorschemes/ Style
	use("danilo-augusto/vim-afterglow")
	use("nvim-tree/nvim-web-devicons")
	------ Completion. Modified from LunarVim
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "folke/neodev.nvim" }) -- nvim API completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })
	-- snippets
	use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use
	use({ "L3MON4D3/LuaSnip" }) --snippet engine
	-- Formatting and Linting
	use({ "jose-elias-alvarez/null-ls.nvim" })
  ------ Help & Legends
  use({
    "folke/which-key.nvim",
    config = function()
    end
  })
  ------ File Navigation
  -- File tree
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  use {
    "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = { 
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      }
  }
  ------ Network utils
  -- HTTP requests 
  use {
    "rest-nvim/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- stay in current windows (.http file) or change to results window (default)
        stay_in_current_window_after_split = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          -- show the generated curl command in case you want to launch
          -- the same request via the terminal (can be verbose)
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          -- table of curl `--write-out` variables or false if disabled
          -- for more granular control see Statistics Spec
          show_statistics = false,
          -- executables or functions for formatting response body [optional]
          -- set them to false if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
            end
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = '.env',
        -- for telescope select
        env_pattern = "\\.env$",
        env_edit_command = "tabedit",
        custom_dynamic_variables = {},
        yank_dry_run = true,
        search_back = true,
      })
    end
  }
	---- List of plugins end
	if install_plugins then
		require("packer").sync()
	end
end)

---- Stop config init to allow plugin installation
---- TODO: this reload doesn't fully work as intended, probably need to use autocmd or something to fully solve
if install_plugins then
	print("Config init interupted to allow plugin installation. Reload")
	return
end

--------------------------------------------------------------------------------
-- Plugin Configuration
--------------------------------------------------------------------------------
---- Telescope
local t_actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		-- Default configuration for telescope goes here:
		mappings = {
			i = {
				-- map actions.which_key to <C-h> (default: <C-/>)
				-- actions.which_key shows the mappings for your picker,
				-- e.g. git_{create, delete, ...}_branch for the git_branches picker
				["<C-h>"] = "which_key",
				["<C-j>"] = t_actions.move_selection_next,
				["<C-k>"] = t_actions.move_selection_previous,
			},
		},
	},
})

require("telescope").load_extension("rest")

---- Lua Line
require("lualine").setup({
	options = {
		icons_enabled = true,
		section_separators = "",
		component_separators = "",
	},
  winbar = {
    lualine_a = { 
      {
        'require"nvim-web-devicons".get_icon( vim.fn.expand("%:t"), vim.fn.expand("%:e"), { default = true })',
        color = "lualine_a_replace",
        separator = { left = "%#Character#"},
        right_padding = 2 
      }
    },
    lualine_b = {
      { 
        "filename",
        path = 1,
        color = "lualine_a_replace",
      }, 
    },
		lualine_c = { 
      { 
        "require'nvim-gps'.get_location()",
        color = "lualine_a_replace",
      }
    },
    lualine_z = {
      { 
        "vim.fn.expand(' ')",
        separator = { right = "%#Character#" }, 
        color = "lualine_a_replace",
        draw_empty = true, 
        right_padding = 2 
      },
    },	
  },
	sections = {
    lualine_a = {
      { "mode", separator = { left = "%#NormalNC#" }, right_padding = 2 },
    },
    lualine_z = {
      { "mode", separator = { right = "%#NormalNC#" }, right_padding = 2 },
    },	
   },
})

---- Treesitter
require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

---- Leap
require("leap").add_default_mappings()

---- Comment
require("Comment").setup()

---- GPS
require("nvim-gps").setup()

---- GIT Signs
require("gitsigns").setup({
	current_line_blame = true,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { desc = "Git next hunk", expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { desc = "Git prev hunk", expr = true })

		-- Actions
		map({ "n", "v" }, "<LEADER>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
		map({ "n", "v" }, "<LEADER>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
		map("n", "<LEADER>gS", gs.stage_buffer, { desc = "Stage buffer" })
		map("n", "<LEADER>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
		map("n", "<LEADER>gR", gs.reset_buffer, { desc = "Reset buffer" })
		map("n", "<LEADER>gp", gs.preview_hunk, { desc = "Preview hunk" })
		map("n", "<LEADER>gb", function()
			gs.blame_line({ full = true })
		end, { desc = "Show blame for current line" })
		map("n", "<LEADER>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
		map("n", "<LEADER>gd", gs.diffthis, { desc = "Diff this" })
		map("n", "<LEADER>gD", function()
			gs.diffthis("~")
		end, { desc = "Diff ???" })
		map("n", "<LEADER>td", gs.toggle_deleted, { desc = "Toggle deleted lines" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select inside hunk" })
	end,
})

---- Dev icons
require("nvim-web-devicons").setup({
	-- your personnal icons can go here (to override)
	-- you can specify color or cterm_color instead of specifying both of them
	-- DevIcon will be appended to `name`
	override = {
		zsh = {
			icon = "",
			color = "#428850",
			cterm_color = "65",
			name = "Zsh",
		},
	},

	color_icons = true,
	-- globally enable default icons (default to false)
	default = true,
})

----Code symbol outline
require("symbols-outline").setup()

---- CamelCaseMotion
vim.g["camelcasemotion_key"] = "<LEADER><LEADER>"

---- Completion & Snippets
require("user.cmp")

---- Formatting and Linting
require("user.null-ls")

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
-- lspconfig.rust_analyzer.setup {
--   -- Server-specific settings. See `:help lspconfig-setup`
--   settings = {
--     ['rust-analyzer'] = {},
--   },
-- }



--------------------------------------------------------------------------------
-- Key bindings/ mappings
--------------------------------------------------------------------------------
---- WhichKey
local whichkey = require("which-key")
whichkey.setup()
whichkey.register({
  ["<leader>"] = {  
    f = {name = "Find"},
    r = {name = "Rip Grep"},
    t = {name = "Toggle options"},
    l = {name = "LSP"},
    [" "] = {name = "Camel Case Motions"},
  }
})

--------------------------------------------------------------------------------
-- Ex. Keymap
--
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffnr,
--                                               desc = "vim.lsp.buf.hover",
--                                               remap=false,
--                                               silent=false,
--                                               expr=false
--                                             })
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
--------------------------------------------------------------------------------
local def_opt = { remap = false }
local map = vim.keymap.set

map("n", "<C-s>", ":w<CR>", { desc="Save file", remap=false })
map("i", "<C-s>", "<ESC>:w<CR>a", { desc="Save file", remap=false })
map("i", "jk", "<ESC>", def_opt)
map("v", "jk", "<ESC>", def_opt)

-- Commands always in edit window
map("n", ":", "q:i", def_opt)
map("v", ":", "q:i", def_opt)
map("n", "q:", ":", def_opt)

-- Stay in indent mode
map("v", "<", "<gv", def_opt)
map("v", ">", ">gv", def_opt)

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==", def_opt)
map("v", "<A-k>", ":m .-2<CR>==", def_opt)
map("v", "p", '"_dP', def_opt)

-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", def_opt)
map("x", "K", ":move '<-2<CR>gv-gv", def_opt)
map("x", "<A-j>", ":move '>+1<CR>gv-gv", def_opt)
map("x", "<A-k>", ":move '<-2<CR>gv-gv", def_opt)

-- Remap * to search for selection when in visual mode, how is this not default behavior ?!
map("v", "*", '"xy/<C-R>x<CR>')

---- Window nav
map("n", "<C-j>", "<C-w>j", def_opt)
map("n", "<C-k>", "<C-w>k", def_opt)
map("n", "<C-l>", "<C-w>l", def_opt)
map("n", "<C-h>", "<C-w>h", def_opt)

map("t", "<C-j>", "<C-\\><C-n><C-w>j", def_opt)
map("t", "<C-k>", "<C-\\><C-n><C-w>k", def_opt)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", def_opt)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", def_opt)

---- Split term
map("n", "ttt", ":ToggleTerminalSplit<CR>", { desc="Toggle terminal split", remap=false })
map("t", "ttt", "<C-\\><C-n><C-w>:ToggleTerminalSplit<CR>", def_opt)

---- Fix C-j, C-k in drop downs
map("i", "<C-j>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map("i", "<C-k>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })

---- Spelling on/off
map("n", "<LEADER>ts", ":set spell!<CR>", { desc="Toggle spelling", noremap = true})
map("n", "<LEADER>th", ":noh<CR>", { desc="Clear search highlight", remap=false })

---- Buffer nav
map("n", "H", ":bp<CR>", def_op)
map("n", "L", ":bn<CR>", def_op)
map("n", "<LEADER>c", ":bd<CR>", { desc = "Close buffer", noremap = true })

---- Telescope
map("n", "<LEADER>ff", t_builtin.find_files, { desc = "Find file", noremap = true })
map("n", "<LEADER>fw", t_builtin.live_grep, { desc = "Grep string", noremap = true })
map("n", "<LEADER>fb", t_builtin.buffers, { desc = "Find open buffer", noremap = true })
map("n", "<LEADER>fh", t_builtin.help_tags, { desc = "Find help tags", noremap = true })
map("n", "<LEADER>fs", utils.grep_in_blob, { desc = "Grep string restricted to path blob", noremap = true })
map("n", "<LEADER>fr", t_builtin.resume, { desc = "Resume previous find", noremap = true })
map("n", "<LEADER>fo", t_builtin.oldfiles, { desc = "Find recently opened file", noremap = true })
-- Quick telescope.live_grep search from whats in the buffer search register
map("n", "<LEADER>f*", utils.grep_on_search_register, { desc = "Grep on value in search register", noremap = true})

---- Filetree
map("n", "<LEADER>e", ":Neotree<CR>", { desc="Open file tree", remap=false })

---- Grepping
map("n", "<LEADER>rg", ":Rg<CR>", { desc = "Grep ask for input", noremap = true })
map("n", "<LEADER>rw", ":Rg *<CR>", { desc = "Grep for word under cursor", noremap = true })


---- LSP Formatting and Diagnostics
map("n", "<LEADER>lf", function()
	vim.lsp.buf.format({ timeout_ms = 2000, async = true})
end, { desc = "Format buffer", noremap = true })
map("v", "<LEADER>lf", function()
	vim.lsp.buf.format({ timeout_ms = 2000, async = true })
end, { desc = "Format selection", noremap = true })

-- LSP Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map('n', '<space>le', vim.diagnostic.open_float, { desc = "Open diagnostic float" })
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Prev diagnostic message" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic message" })
map('n', '<space>lq', vim.diagnostic.setloclist, { desc = "Send diagnostic messages to location list" })

-- HTTP Requests
map('n', '<space>nr', require('rest-nvim').run, { desc = "HTTP request execute" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    opts["desc"] = "Goto declaration"
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    opts["desc"] = "Goto definition"
    map('n', 'gd', vim.lsp.buf.definition, opts)
    opts["desc"] = "Goto implementation"
    map('n', 'gi', vim.lsp.buf.implementation, opts)
    opts["desc"] = "Goto references"
    map('n', 'gr', vim.lsp.buf.references, opts)

    opts["desc"] = "Hover docs"
    map('n', 'K', vim.lsp.buf.hover, opts)
    opts["desc"] = "Signature help"
    map('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    opts["desc"] = "Add workspace folder"
    map('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, opts)
    opts["desc"] = "Remove workspace folder"
    map('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder, opts)
    opts["desc"] = "List workspace folders"
    map('n', '<space>lwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    opts["desc"] = "Type definition"
    map('n', '<space>lD', vim.lsp.buf.type_definition, opts)
    opts["desc"] = "Rename symbol"
    map('n', '<space>lr', vim.lsp.buf.rename, opts)
    opts["desc"] = "Code action"
    map('n', '<space>lc', vim.lsp.buf.code_action, opts)
    opts["desc"] = nil
  end,
})

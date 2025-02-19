-- -- Code clean up, fix fallbacks etc.
local return_code, utils = pcall(require, "user.utils")

--------------------------------------------------------------------------------
-- Setup editor options
--------------------------------------------------------------------------------
vim.go.viminfo = vim.go.viminfo .. ",n~/.cache/.viminfo"
vim.opt.mouse = "a"
vim.opt.colorcolumn = "120"
vim.opt.cmdwinheight = 3
---- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
---- Spelling
vim.opt.spelllang = "en"
vim.opt.spellsuggest = "best,15"
vim.opt.spell = true
---- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
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
vim.g.bg_color_override = "DarkOrchid4"
utils.toggle_bg()
---- Space as leader
vim.g.mapleader = " "
---- Code folding
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
---- Pseudo chars
local space = "·"
vim.opt.listchars:append({
	tab = "│─",
	multispace = space,
	lead = space,
	trail = space,
	nbsp = space,
	-- eol = "↵",
	extends = ">",
	precedes = "<",
})
vim.opt.list = true
---- CamelCaseMotion (Needs to be set before pulgin loads)
vim.g["camelcasemotion_key"] = "<LEADER><LEADER>"

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
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.env.LAZY_PATH and not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.api.nvim_echo({
		{
			"Cloning lazy.nvim\n\n",
			"DiagnosticInfo",
		},
	}, true, {})
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local ok, out = pcall(vim.fn.system, {
		"git",
		"clone",
		"--filter=blob:none",
		lazyrepo,
		lazypath,
	})
	if not ok or vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim\n", "ErrorMsg" },
			{ vim.trim(out or ""), "WarningMsg" },
			{ "\nPress any key to exit...", "MoreMsg" },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
local plugins = {
	---- List of plugins...
	------ Lib. plugins
	"nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
	------ Text search/ Fuzzy finding
	{ -- Telescope finder
		"nvim-telescope/telescope.nvim",
		-- tag = "0.1.8",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
	},
	"duane9/nvim-rg", -- RipGrep
	------ Status lines
	require("user.lualine"),
	------ Code introspection
	{ -- LSP Server configurations
		"neovim/nvim-lspconfig",
	},
	{ -- Code parser
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{ -- Code object insights
		"SmiteshP/nvim-navic",
		dependencies = "neovim/nvim-lspconfig",
	},
	{ -- Smart comments
		"numToStr/Comment.nvim",
	},
	-- GIT integration
	require("user.gitsigns"),
	{ -- Code symbol outline
		"simrat39/symbols-outline.nvim",
	},
	------ Objects & Motions
	{ "tpope/vim-surround" }, -- Add suround objects
	{ "bkad/CamelCaseMotion" }, -- Add word case objects
	"ggandor/leap.nvim", -- Match jumps
	------ Colorschemes/ Style
	"danilo-augusto/vim-afterglow",
	"nvim-tree/nvim-web-devicons",
	------ Completion. Modified from LunarVim
	{ "hrsh7th/nvim-cmp" }, -- The completion plugin
	{ "hrsh7th/cmp-buffer" }, -- buffer completions
	{ "hrsh7th/cmp-path" }, -- path completions
	{ "folke/neodev.nvim" }, -- nvim API completions
	{ "saadparwaiz1/cmp_luasnip" }, -- snippet completions
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },
	-- snippets
	{ "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use
	{ "L3MON4D3/LuaSnip" }, --snippet engine
	------ Help & Legends
	{
		"folke/which-key.nvim",
		config = function() end,
	},
	------ File Navigation
	-- File tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	},
	-- Formatting and Linting
	require("user.null-ls"),
	-- Harpooning for buffers
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	------ Network utils
	-- HTTP requests
	require("user.rest"),
	-- Web
	{
		"yuratomo/w3m.vim",
		event = "VeryLazy",
	},
}

require("lazy").setup({
	spec = plugins,
})

--------------------------------------------------------------------------------
local return_code, t_builtin = pcall(require, "telescope.builtin")
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

---- Treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"c",
		"comment",
		"css",
		"dockerfile",
		"html",
		"http",
		"javascript",
		"jinja",
		"jinja_inline",
		"jsdoc",
		"json",
		"jsonc",
		"lua",
		"make",
		"markdown",
		"python",
		"regex",
		"scss",
		"sql",
		"toml",
		"typescript",
		"vue",
		"yaml",
		"zig",
		-- "mojo",
	},
	highlight = { enable = true },
})

---- Leap
require("leap").add_default_mappings()

---- Comment
require("Comment").setup()

---- GPS
require("nvim-navic").setup({
	lsp = { auto_attach = true },
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

---- Completion & Snippets
require("user.cmp")

---- Formatting and Linting
-- require("user.null-ls")

-- Setup language servers.
local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})
lspconfig.ts_ls.setup({})
lspconfig.vuels.setup({})
lspconfig.mojo.setup({})
-- lspconfig.rust_analyzer.setup {
--   -- Server-specific settings. See `:help lspconfig-setup`
--   settings = {
--     ['rust-analyzer'] = {},
--   },
-- }

local harpoon = require("harpoon")
harpoon:setup()

--------------------------------------------------------------------------------
-- Key bindings/ mappings
--------------------------------------------------------------------------------
---- WhichKey
local whichkey = require("which-key")
whichkey.setup()
whichkey.add({
	{ "<leader> ", group = "Camel Case Motions" },
	{ "<leader>d", group = "Delete" },
	{ "<leader>e", group = "Tree" },
	{ "<leader>h", group = "Harpoon" },
	{ "<leader>f", group = "Find" },
	{ "<leader>g", group = "Git" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>n", group = "Network" },
	{ "<leader>r", group = "Rip Grep" },
	{ "<leader>t", group = "Toggle options" },
})

-- {
--   ["<leader>"] = {
--     f = {name = "Find"},
--     r = {name = "Rip Grep"},
--     t = {name = "Toggle options"},
--     l = {name = "LSP"},
--     n = {name = "Network"},
--     g = {name = "Git"},
--     [" "] = {name = "Camel Case Motions"},
--   }
-- }
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

---- Harpoon
map("n", "<leader>ha", function()
	harpoon:list():add()
end, def_opt)
map("n", "<leader>he", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, def_opt)
-- Toggle previous & next buffers stored within Harpoon list
map("n", "<leader>hh", function()
	harpoon:list():select(1)
end, def_opt)
map("n", "<leader>hj", function()
	harpoon:list():select(2)
end, def_opt)
map("n", "<leader>hk", function()
	harpoon:list():select(3)
end, def_opt)
map("n", "<leader>hl", function()
	harpoon:list():select(4)
end, def_opt)

-- Toggle previous & next buffers stored within Harpoon list
map("n", "<leader>hp", function()
	harpoon:list():prev()
end, def_opt)
map("n", "<leader>hn", function()
	harpoon:list():next()
end, def_opt)

map("n", "<C-s>", ":w<CR>", { desc = "Save file", remap = false })
map("i", "<C-s>", "<ESC>:w<CR>a", { desc = "Save file", remap = false })
map("i", "jk", "<ESC>", def_opt)
map("v", "jk", "<ESC>", def_opt)

-- Commands always in edit window
map("n", ":", "q:i", def_opt)
map("v", ":", "q:i", def_opt)
map("n", "q:", ":", def_opt)

-- Delete without mangling registers etc.
map("v", "p", '"_dP', def_opt)
map("n", "x", '"_x', def_opt)
map("n", "<LEADER>dd", '"_d', { desc = "Delete without mangling regs", noremap = true })
map("n", "<LEADER>dc", '"_d', { desc = "Change without mangling regs", noremap = true })
map("n", "<LEADER>dt", ":%s/\\s\\+$/<CR>", { desc = "Remove trailing spaces", noremap = true })

-- Stay in indent mode
map("v", "<", "<gv", def_opt)
map("v", ">", ">gv", def_opt)

-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", def_opt)
map("x", "K", ":move '<-2<CR>gv-gv", def_opt)
-- map("x", "<A-j>", ":move '>+1<CR>gv-gv", def_opt)
-- map("x", "<A-k>", ":move '<-2<CR>gv-gv", def_opt)

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

---- Fix C-j, C-k in drop downs
map("i", "<C-j>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map("i", "<C-k>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })

---- Toggle stuff
map("n", "<LEADER>ts", ":set spell!<CR>", { desc = "Toggle spelling", noremap = true })
map("n", "<LEADER>th", ":noh<CR>", { desc = "Clear search highlight", remap = false })
map("n", "<LEADER>tb", utils.toggle_bg, { desc = "Toggle BG", remap = false })
-- Split term
map("n", "tt", ":ToggleTerminalSplit<CR>", { desc = "Toggle terminal split", remap = false })
map("t", "tt", "<C-\\><C-n><C-w>:ToggleTerminalSplit<CR>", def_opt)

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
map("n", "<LEADER>fd", t_builtin.diagnostics, { desc = "Code diagnostics", noremap = true })
-- Quick telescope.live_grep search from whats in the buffer search register
map("n", "<LEADER>f*", utils.grep_on_search_register, { desc = "Grep on value in search register", noremap = true })

---- Filetree
map("n", "<LEADER>ee", ":Neotree toggle<CR>", { desc = "Open file tree", remap = false })
map("n", "<leader>er", "<Cmd>Neotree reveal<CR>")
---- Grepping
map("n", "<LEADER>rg", ":Rg<CR>", { desc = "Grep ask for input", noremap = true })
map("n", "<LEADER>rw", ":Rg *<CR>", { desc = "Grep for word under cursor", noremap = true })

---- LSP Formatting and Diagnostics
map("n", "<LEADER>lf", function()
	vim.lsp.buf.format({ timeout_ms = 2000, async = true })
end, { desc = "Format buffer", noremap = true })
map("v", "<LEADER>lf", function()
	vim.lsp.buf.format({ timeout_ms = 2000, async = true })
end, { desc = "Format selection", noremap = true })

-- LSP Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map("n", "<space>le", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic message" })
map("n", "<space>lq", vim.diagnostic.setloclist, { desc = "Send diagnostic messages to location list" })

-- HTTP Requests
map("n", "<space>nr", "<cmd>Rest run<CR>", { desc = "HTTP request execute" })
map("n", "<space>ne", "<cmd>Telescope rest select_env<CR>", { desc = "Select env. file for request" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf, noremap = true }
		opts["desc"] = "Goto declaration"
		map("n", "gD", vim.lsp.buf.declaration, opts)
		opts["desc"] = "Goto definition"
		map("n", "gd", vim.lsp.buf.definition, opts)
		opts["desc"] = "Goto implementation"
		map("n", "gi", vim.lsp.buf.implementation, opts)
		opts["desc"] = "Goto references"
		map("n", "gr", vim.lsp.buf.references, opts)

		opts["desc"] = "Hover docs"
		map("n", "K", vim.lsp.buf.hover, opts)
		opts["desc"] = "Signature help"
		map("n", "<C-k>", vim.lsp.buf.signature_help, opts)

		opts["desc"] = "Add workspace folder"
		map("n", "<space>lwa", vim.lsp.buf.add_workspace_folder, opts)
		opts["desc"] = "Remove workspace folder"
		map("n", "<space>lwr", vim.lsp.buf.remove_workspace_folder, opts)
		opts["desc"] = "List workspace folders"
		map("n", "<space>lwl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)

		opts["desc"] = "Type definition"
		map("n", "<space>lD", vim.lsp.buf.type_definition, opts)
		opts["desc"] = "Rename symbol"
		map("n", "<space>lr", vim.lsp.buf.rename, opts)
		opts["desc"] = "Code action"
		map("n", "<space>lc", vim.lsp.buf.code_action, opts)
		opts["desc"] = nil
	end,
})

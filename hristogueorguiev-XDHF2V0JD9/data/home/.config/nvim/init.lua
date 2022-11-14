-- TODO:
-- -- Null.ls formatting and linting, update for python and JS configuration
-- -- Maybe LSP

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
-- Key bindings/ mappings
--------------------------------------------------------------------------------
-- Ex.
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

map("n", "<C-s>", ":w<CR>", def_op)
map("i", "<C-s>", "<ESC>:w<CR>a", def_op)
map("n", "<LEADER>h", ":noh<CR>", def_op)
map("i", "jk", "<ESC>", def_opt)

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
map("n", "ttt", ":ToggleTerminalSplit<CR>", def_opt)
map("t", "ttt", "<C-\\><C-n><C-w>:ToggleTerminalSplit<CR>", def_opt)

---- Fix C-j, C-k in drop downs
map("i", "<C-j>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map("i", "<C-k>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })

---- Spelling on/off
map("n", "<LEADER>ts", ":set spell!<CR>", def_opt)

---- Buffer nav
map("n", "H", ":bp<CR>", def_op)
map("n", "L", ":bn<CR>", def_op)
map("n", "<LEADER>c", ":bd<CR>", def_op)

---- Telescope
map("n", "<LEADER>ff", t_builtin.find_files, def_opt)
map("n", "<LEADER>fw", t_builtin.live_grep, def_opt)
map("n", "<LEADER>fb", t_builtin.buffers, def_opt)
map("n", "<LEADER>fh", t_builtin.help_tags, def_opt)
map("n", "<LEADER>fs", utils.grep_in_blob, def_opt)
map("n", "<LEADER>fr", t_builtin.resume, def_opt)
map("n", "<LEADER>fo", t_builtin.oldfiles, def_opt)
-- Quick telescope.live_grep search from whats in the buffer search register
vim.keymap.set("n", "<LEADER>f*", utils.grep_on_search_register, {})

---- LSP Formatting and Diagnostics
map("n", "<LEADER>lf", function()
	vim.lsp.buf.format({ timeout_ms = 2000 })
end, def_opt)
map("v", "<LEADER>lf", function()
	vim.lsp.buf.format({ timeout_ms = 2000 })
end, def_opt)

---- Grepping
------ RipGrep plugin setups its own defaults
------ <LEADER>rg :Rg<CR>
------ <LEADER>rw :Rg *<CR>

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

---- Lua Line
require("lualine").setup({
	options = {
		icons_enabled = true,
		section_separators = "*",
		component_separators = "#",
	},
	sections = {
		lualine_c = { "filename", "require'nvim-gps'.get_location()" },
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
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<LEADER>hs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<LEADER>hr", ":Gitsigns reset_hunk<CR>")
		map("n", "<LEADER>hS", gs.stage_buffer)
		map("n", "<LEADER>hu", gs.undo_stage_hunk)
		map("n", "<LEADER>hR", gs.reset_buffer)
		map("n", "<LEADER>hp", gs.preview_hunk)
		map("n", "<LEADER>hb", function()
			gs.blame_line({ full = true })
		end)
		map("n", "<LEADER>tb", gs.toggle_current_line_blame)
		map("n", "<LEADER>hd", gs.diffthis)
		map("n", "<LEADER>hD", function()
			gs.diffthis("~")
		end)
		map("n", "<LEADER>td", gs.toggle_deleted)

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
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

---- Fix QuickFixes 
require("user.quickfix_actually")

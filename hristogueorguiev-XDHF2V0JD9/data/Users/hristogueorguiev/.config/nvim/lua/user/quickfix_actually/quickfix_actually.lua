--------------------------------------------------------------------------------
-- Better QuickFix plugin proto TODO:Move to a plugin, refactor, fix sign jitter
--------------------------------------------------------------------------------
-- Why would parsing edited qfix list not be default, I would really like to hear the reasoning here
local M = {}

function M.tmp_do_all()
	vim.go.errorformat = vim.go.errorformat .. ",%f|%l col %c|%m"

	vim.keymap.set("n", "<LEADER>qo", ":copen<CR>", { silent = true })

	function better_qf()
		vim.cmd("sign define QFmatch text=")
		local cur_buf = vim.api.nvim_get_current_buf()
		vim.keymap.set(
			"n",
			"J",
			":cnext<CR>zz:QFUnMarkAll<CR>:QFMarkCurrentLine<CR><C-w>w",
			{ remap = false, buffer = cur_buf }
		)
		vim.keymap.set(
			"n",
			"K",
			":cprev<CR>zz:QFUnMarkAll<CR>:QFMarkCurrentLine<CR><C-w>w",
			{ remap = false, buffer = cur_buf }
		)
		vim.keymap.set("n", "H", ":colder<CR>", { remap = false, buffer = cur_buf })
		vim.keymap.set("n", "L", ":cnewer<CR>", { remap = false, buffer = cur_buf })
		vim.keymap.set("n", "i", ":set modifiable<CR>", { remap = false, buffer = cur_buf })
		vim.keymap.set("n", "<C-s>", ":cgetbuffer<CR>:cclose<CR>:copen<CR>", { remap = false, buffer = cur_buf })
	end

	vim.api.nvim_create_autocmd( -- Enter insert mode when entering a Term buffer
		{
			"FileType",
		},
		{
			pattern = { "qf" },
			callback = better_qf,
		}
	)

	vim.api.nvim_create_user_command(
		"QFMarkCurrentLine",
		'exe "sign place 1 name=QFmatch group=QFMatches line="..line(".")',
		{}
	)

	vim.api.nvim_create_user_command("QFUnMarkAll", "sign unplace * group=QFMatches", {})
end

return M

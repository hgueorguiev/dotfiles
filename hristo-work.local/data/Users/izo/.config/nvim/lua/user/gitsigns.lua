return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
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
		end,
	},
}

return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				section_separators = "",
				component_separators = "",
				disabled_filetypes = { "alpha", "neo-tree", "vim", "qf" },
			},
			winbar = {
				lualine_a = {
					{
						'require"nvim-web-devicons".get_icon( vim.fn.expand("%:t"), vim.fn.expand("%:e"), { default = true })',
						color = "lualine_a_replace",
						separator = { left = "%#Character#" },
						right_padding = 2,
					},
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
						"require'nvim-navic'.get_location()",
						color = "lualine_a_replace",
					},
				},
				lualine_x = {
					"location",
				},
				lualine_z = {
					{
						"vim.fn.expand(' ')",
						separator = { right = "%#Character#" },
						color = "lualine_a_replace",
						draw_empty = true,
						right_padding = 2,
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
	end,
}

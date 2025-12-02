return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "storm", -- Options: "storm", "moon", "night", "day"
			transparent = false,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
			},
		})
		vim.cmd.colorscheme("tokyonight")

		-- Sets colors to line numbers Above, Current and Below in this order
		function LineNumberColors()
			vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#778E98", bold = false })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#778E98", bold = false })
			vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#778E98", bold = false })
		end
		LineNumberColors()
	end,
}

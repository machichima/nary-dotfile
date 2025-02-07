return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
		})
		vim.cmd.colorscheme("catppuccin")
		-- Sets colors to line numbers Above, Current and Below  in this order
		function LineNumberColors()
			vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#778E98", bold = false })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#778E98", bold = false })
			vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#778E98", bold = false })
		end
        LineNumberColors()
	end,
}

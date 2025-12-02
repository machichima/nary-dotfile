return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato",
		})
		-- vim.cmd.colorscheme("catppuccin")  -- Disabled, using tokyonight instead
		-- Sets colors to line numbers Above, Current and Below  in this order
		function LineNumberColors()
			vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#778E98", bold = false })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#778E98", bold = false })
			vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#778E98", bold = false })
		end
        LineNumberColors()
	end,
}

return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "moon", -- Options: "storm", "moon", "night", "day"
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

		-- Make visual selection more obvious
		vim.api.nvim_set_hl(0, "Visual", { bg = "#2d3f6f" })
		vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#2d3f6f" })

        -- Set diff highlight (mainly used in DiffView)
        vim.api.nvim_set_hl(0, "DiffAdd", {bg = "#2d5a2d"})
        vim.api.nvim_set_hl(0, "DiffDelete", {bg = "#5a2d2d"})
        vim.api.nvim_set_hl(0, "DiffChange", {bg = "#1e3a5f"})
        vim.api.nvim_set_hl(0, "DiffText", {bg = "#3d5f8f"})

        -- Make diff delete fill character empty (no ugly ---)
        vim.opt.fillchars:append("diff: ")
	end,
}

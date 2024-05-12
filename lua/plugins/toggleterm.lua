-- referece for setup : https://medium.com/@shaikzahid0713/terminal-support-in-neovim-c616923e0431

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({})

		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

		function _lazygit_toggle()
			lazygit:toggle()
		end

    local python = Terminal:new({ cmd = "python3", hidden = true })

		function _PYTHON_TOGGLE()
			python:toggle()
		end

		vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(
			"n",
			"<leader>tf",
			"<cmd>ToggleTerm direction=float<cr><CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>tv",
			"<cmd>ToggleTerm direction=vertical<cr><CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>th",
			"<cmd>ToggleTerm direction=horizontal<cr><CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>tp",
			"<cmd>lua _PYTHON_TOGGLE()<cr>",
			{ noremap = true, silent = true }
		)
	end,
}

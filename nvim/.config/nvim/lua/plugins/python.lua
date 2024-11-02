-- This is for some more setup packages for Python

return {
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
		branch = "regexp",
		config = function()
			require("venv-selector").setup({
				anaconda_envs_path = "~/miniconda3/envs",
				dap_enabled = true,
				settings = {
					search = {
						poetry = {
							command = "fd -p -g '**/bin/python' ~/workData/pypoetry/virtualenvs/",
						},
					},
				},
			})
		end,

		keys = {
			-- Keymap to open VenvSelector to pick a venv.
			{ "<leader>vs", "<cmd>VenvSelect<cr>" },
			-- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
			{ "<leader>vc", "<cmd>VenvSelectCached<cr>" },
		},
	},

	-- {
	-- 	"benlubas/molten-nvim",
	-- 	enable = true,
	-- 	build = ":UpdateRemotePlugins",
	-- 	init = function()
	-- 		vim.g.molten_image_provider = "image.nvim"
	-- 		vim.g.molten_output_win_max_height = 20
	-- 		vim.g.molten_auto_open_output = false
	-- 	end,
	-- 	keys = {
	-- 		{ "<leader>mi", ":MoltenInit<cr>", desc = "[m]olten [i]nit" },
	-- 		{
	-- 			"<leader>mv",
	-- 			":<C-u>MoltenEvaluateVisual<cr>",
	-- 			mode = "v",
	-- 			desc = "molten eval visual",
	-- 		},
	-- 		{
	-- 			"<leader>me",
	-- 			":MoltenEvaluateOperator<cr>",
	-- 			mode = "n",
	-- 			desc = "molten eval operator",
	-- 		},
	-- 		{ "<leader>mr", ":MoltenReevaluateCell<cr>", desc = "molten re-eval cell" },
	-- 	},
	-- 	config = function()
	-- 		require("molten").setup()
	-- 		vim.keymap.set("n", "<leader>ip", function()
	-- 			local venv = os.getenv("VIRTUAL_ENV")
	-- 			if venv ~= nil then
	-- 				-- in the form of /home/benlubas/.virtualenvs/VENV_NAME
	-- 				venv = string.match(venv, "/.+/(.+)")
	-- 				vim.cmd(("MoltenInit %s"):format(venv))
	-- 			else
	-- 				vim.cmd("MoltenInit python3")
	-- 			end
	-- 		end, { desc = "Initialize Molten for python3", silent = true })
	--
	-- 		vim.g.python3_host_prog =
	-- 			vim.fn.expand("/home/nary/.cache/pypoetry/virtualenvs/nvim-3B-PV_i1-py3.12/bin/python")
	-- 	end,
	-- },
	-- {
	-- 	"Vigemus/iron.nvim",
	-- 	config = function()
	-- 		local iron = require("iron.core")
	--
	-- 		iron.setup({
	-- 			config = {
	-- 				-- Whether a repl should be discarded or not
	-- 				scratch_repl = true,
	-- 				-- Your repl definitions come here
	-- 				repl_definition = {
	-- 					sh = {
	-- 						-- Can be a table or a function that
	-- 						-- returns a table (see below)
	-- 						command = { "zsh" },
	-- 					},
	-- 					python = {
	-- 						command = { "python3" },
	-- 						format = require("iron.fts.common").bracketed_paste_python,
	-- 					},
	-- 				},
	-- 				-- How the repl window will be displayed
	-- 				-- See below for more information
	-- 				repl_open_cmd = require("iron.view").split.vertical.botright(0.5),
	-- 			},
	-- 			-- Iron doesn't set keymaps by default anymore.
	-- 			-- You can set them here or manually add keymaps to the functions in iron.core
	-- 			keymaps = {
	-- 				send_motion = "<space>sc",
	-- 				visual_send = "<space>sc",
	-- 				send_file = "<space>sf",
	-- 				send_line = "<space>sl",
	-- 				send_paragraph = "<space>sp",
	-- 				send_until_cursor = "<space>su",
	-- 				send_mark = "<space>sm",
	-- 				mark_motion = "<space>mc",
	-- 				mark_visual = "<space>mc",
	-- 				remove_mark = "<space>md",
	-- 				cr = "<space>s<cr>",
	-- 				interrupt = "<space>s<space>",
	-- 				exit = "<space>sq",
	-- 				clear = "<space>cl",
	-- 			},
	-- 			-- If the highlight is on, you can change how it looks
	-- 			-- For the available options, check nvim_set_hl
	-- 			highlight = {
	-- 				italic = true,
	-- 			},
	-- 			ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
	-- 		})
	--
	-- 		-- iron also has a list of commands, see :h iron-commands for all available commands
	-- 		vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
	-- 		vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
	-- 		vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
	-- 		vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
	-- 	end,
	-- },
}

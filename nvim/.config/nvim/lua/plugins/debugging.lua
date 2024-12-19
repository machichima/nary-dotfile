return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local widgets = require("dap.ui.widgets")

			require("dap-python").setup()
			table.insert(require("dap").configurations.python, {
				justMyCode = false, -- <--- insert here
				type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
				request = "launch",
				name = "debug source code",
				program = "${file}",
			})

			dapui.setup()

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, {})
			-- vim.keymap.set("n", "<Leader>dc", dap.continue, {})

			vim.keymap.set("n", "<F5>", dap.continue, { desc = "dap start debugging or continue" })
			vim.keymap.set("n", "<F6>", dap.terminate, { desc = "dap terminate" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "dap step over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "dap step into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "dap step out" })

			-- vim.keymap.set("n", "<Leader>dr", dap.repl.open, {})
			-- vim.keymap.set("n", "<Leader>ds", function ()
			--              widgets.sidebar(widgets.scopes)
			-- end, {})
			-- vim.keymap.set("n", "<Leader>dw", function ()
			--              widgets.sidebar(widgets.watches)
			-- end, {})

			vim.keymap.set("n", "<Leader>dl", dap.run_last, {})
			vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle debug ui" })
			vim.keymap.set({ "n", "v" }, "<Leader>dh", require("dap.ui.widgets").hover, {})
			-- vim.keymap.set({ "n", "v" }, "<Leader>dp", require("dap.ui.widgets").preview, {})

			vim.keymap.set("n", "<Leader>dp", function()
				dapui.float_element("breakpoints", { enter = true })
			end, { desc = "Toggle debug ui breakpoints" })

			vim.keymap.set("n", "<Leader>dr", function()
				dapui.float_element(
					"repl",
					{ width = vim.o.columns - 10, height = vim.o.lines - 10, enter = true, position = "center" }
				)
			end, { desc = "Toggle debug ui repl" })

			vim.keymap.set("n", "<Leader>ds", function()
				dapui.float_element(
					"scopes",
					{ width = vim.o.columns - 10, height = vim.o.lines - 10, enter = true, position = "center" }
				)
			end, { desc = "Toggle debug ui scopes" })

			vim.keymap.set("n", "<Leader>dw", function()
				dapui.float_element(
					"watches",
					{ width = vim.o.columns - 10, height = vim.o.lines - 10, enter = true, position = "center" }
				)
			end, { desc = "Toggle debug ui watches" })

			vim.keymap.set("n", "<Leader>cc", function()
				dapui.float_element(
					"console",
					{ width = vim.o.columns - 10, height = vim.o.lines - 10, enter = true, position = "center" }
				)
			end, { desc = "Toggle debug ui watches" })

			vim.keymap.set("n", "<Leader>dc", function()
				vim.keymap.set("n", "<leader>dc", function()
					dapui.toggle({ layout = 2 })
				end, { desc = "Open DAP Console" })
			end, {})

			vim.keymap.set("n", "<Leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end, {})

			local types_enabled = true
			local toggle_types = function()
				types_enabled = not types_enabled
				dapui.update_render({ max_type_length = types_enabled and -1 or 0 })
			end
			vim.keymap.set("n", "<Leader>dm", toggle_types, { desc = "toggle hide long types" })
			-- vim.keymap.set("n", "<Leader>ds", function()
			-- 	local widgets = require("dap.ui.widgets")
			-- 	widgets.centered_float(widgets.scopes)
			-- end, {})
		end,
	},

	{
		"leoluz/nvim-dap-go",
		dependencies = {
			{ "mfussenegger/nvim-dap" },
			{ "rcarriga/nvim-dap-ui" },
			{ "nvim-neotest/nvim-nio" },
		},
		config = function()
			local dap_go = require("dap-go")
			local dap = require("dap")
			local dap_ui = require("dapui")
			--
			-- adapters configuration
			dap.adapters.go = {
				type = "server",
				host = "127.0.0.1",
				port = 37365,
				executable = {
					command = "dlv",
					args = { "dap", "--listen=127.0.0.1:37365", "--log" },
				},
			}

			local ts_utils = require("nvim-treesitter.ts_utils")

			local function get_current_function_name()
				local current_node = ts_utils.get_node_at_cursor()
				if not current_node then
					return ""
				end

				local expr = current_node

				while expr do
					print(expr.type())
					if expr:type() == "function_definition" then
						break
					end
					expr = expr:parent()
				end
				print(ts_utils.get_node_text(expr:child(1)))

				if not expr then
					return ""
				end

				return (ts_utils.get_node_text(expr:child(1)))[1]
			end

			vim.keymap.set("n", "<leader>cf", get_current_function_name, { desc = "test capture function" })

			dap_go.setup({
				dap_configurations = {
					{
						type = "go",
						name = "Debug (Flyte default config)",
						request = "launch",
						program = vim.fs.joinpath(vim.fn.getcwd(), "cmd"),
						args = {
							"start",
							"--config",
							"flyte-single-binary-local.yaml",
						},
						env = {
							POD_NAMESPACE = "flyte",
						},
						buildFlags = "-tags console -v",
						cwd = vim.fn.getcwd(),
					},
					{
						type = "go",
						name = "Debug (Flyte Spark config)",
						request = "launch",
						program = vim.fs.joinpath(vim.fn.getcwd(), "cmd"),
						args = {
							"start",
							"--config",
							vim.fs.joinpath(vim.fn.getcwd(), "../spark-values-override.yaml"),
						},
						env = {
							POD_NAMESPACE = "flyte",
						},
						buildFlags = "-tags console -v",
						cwd = vim.fn.getcwd(),
					},
					{
						name = "Debug Test Current File",
						type = "go",
						request = "launch",
						mode = "test",
						-- cwd = "${fileDirname}", -- The directory of the current file
						program = "${fileDirname}", -- Test the entire package where the file resides
						-- program = "${file}", -- Current file with the test
						showLog = true,
						-- cwd = vim.fn.getcwd(),
						-- dlvCwd = vim.fs.joinpath(vim.fn.getcwd(), "${fileDirname}"),
						dlvCwd = "${fileDirname}",
					},
					{
						type = "go",
						name = "Debug Test Current File Specific Go Test",
						request = "launch",
						mode = "test",
						-- program = "${file}", -- Current file with the test
						program = "${fileDirname}", -- Test the entire package where the file resides
						showLog = true,
						-- dlvCwd = vim.fs.joinpath(vim.fn.getcwd(), "${fileDirname}"),
						dlvCwd = "${fileDirname}",
						-- args = { "-test.run", "^TestFunctionName$" }, -- Replace TestFunctionName dynamically
						-- cwd = "./${relativeFileDirname}",
						args = function()
							-- Get the test name under the cursor
							-- local test_name = get_current_function_name()
							local test_name = vim.fn.expand("<cword>")
							return { "-test.run", "^" .. test_name .. "$" }
						end,
					},
				},
			})

			vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
			vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
			vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

			vim.api.nvim_set_hl(0, "DapBreakpointLine", { ctermbg = 0, bg = "#31353f" })
			vim.api.nvim_set_hl(0, "DapLogPointLine", { ctermbg = 0, bg = "#31353f" })
			vim.api.nvim_set_hl(0, "DapStoppedLine", { ctermbg = 0, bg = "#31353f" })

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapLogPoint",
				{ text = "", texthl = "DapLogPoint", linehl = "DapLogPointLine", numhl = "DapLogPoint" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStopped" }
			)
		end,
	},
}

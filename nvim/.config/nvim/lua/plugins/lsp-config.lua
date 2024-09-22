return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local mason_lsp = require("mason-lspconfig")

			local handlers = {
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({})
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim", "quarto", "pandoc", "io", "string", "print", "require", "table" },
									disable = { "trailing-space" },
								},
							},
						},
					})
				end,

				["pylsp"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.pylsp.setup({
						settings = {
							python = {
								pythonPath = vim.fn.exepath("python3"),
							},
							pylsp = {
								plugins = {
									pycodestyle = {
										ignore = { "E501" },
										maxLineLength = 160, -- Adjust this value as needed
									},
									pylsp_mypy = {
										enabled = true,
										live_mode = true,
									},
								},
							},
						},
						capabilities = capabilities,
					})
				end,
			}

			mason_lsp.setup({
				ensure_installed = { "lua_ls", "pylsp", "vimls" },
				handlers = handlers,
			})
		end,
	},
	{
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			vim.g.autoformat = false

			-- python
			-- lspconfig.pylsp.setup({
			--   settings = {
			--     python = {
			--       pythonPath = vim.fn.exepath("python3"),
			--     },
			--   },
			--   capabilities = capabilities,
			-- })

			-- lspconfig.ltex.setup{
			--   capabilities = capabilities,
			-- }

			-- lua
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
				capabilities = capabilities,
			})

			-- vim
			lspconfig.vimls.setup({
				capabilities = capabilities,
			})

			lspconfig.ltex.setup({
				filetypes = { "markdown" },
				flags = { debounce_text_changes = 300 },
				on_attach = function(client, bufnr)
					require("ltex_extra").setup({
						load_langs = { "en-GB" },
						path = "~/.config/nvim/spell/en-GB",
						-- path = vim.fn.expand('~') .. '/.local/share/ltex',
					})
				end,
				settings = {
					ltex = {
						completionEnabled = true,
						language = "en-GB",
					},
				},
			})

			local lsp_flags = {
				allow_incremental_sync = true,
				debounce_text_changes = 150,
			}

			lspconfig.yamlls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
				settings = {
					yaml = {
						schemaStore = {
							enable = true,
							url = "",
						},
					},
				},
			})

			lspconfig.marksman.setup({
				capabilities = capabilities,
				filetypes = { "markdown", "quarto" },
				settings = {
					marksman = {
						completion = {
							wiki = {
								style = "file-stem",
							},
						},
					},
					-- marksman = {
					-- 	wiki = {
					-- 		style = "file-stem",
					-- 	},
					-- },
				},
			})

			local function get_quarto_resource_path()
				local function strsplit(s, delimiter)
					local result = {}
					for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
						table.insert(result, match)
					end
					return result
				end

				local f = assert(io.popen("quarto --paths", "r"))
				local s = assert(f:read("*a"))
				f:close()
				return strsplit(s, "\n")[2]
			end

			local lua_library_files = vim.api.nvim_get_runtime_file("", true)
			local lua_plugin_paths = {}
			local resource_path = get_quarto_resource_path()
			if resource_path == nil then
				vim.notify_once("quarto not found, lua library files not loaded")
			else
				table.insert(lua_library_files, resource_path .. "/lua-types")
				table.insert(lua_plugin_paths, resource_path .. "/lua-plugin/plugin.lua")
			end

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set(
				"n",
				"<space>cd",
				"<cmd>lua vim.diagnostic.open_float()<CR>",
				{ desc = "view the diagnostics in the current line" }
			)
			vim.keymap.set(
				"n",
				"<space>cb",
				"<cmd>lua vim.diagnostic.setqflist()<CR>",
				{ desc = "view the all diagnostics in the current buffer" }
			)
			vim.keymap.set(
				"n",
				"<space>cr",
				"<cmd>lua vim.lsp.buf.rename()<CR>",
				{ desc = "rename the symbol under the cursor" }
			)

			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

			-- Disable showing visual text for diagnostic
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = false,
				update_in_insert = false,
				severity_sort = true,
			})
		end,
	},
}

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

            -- NOTE:
            --   basedpyright: autoimport and reportUndefinedVariable check
            --   ruff: static check (all others)
            mason_lsp.setup({
                ensure_installed = { "lua_ls", "basedpyright", "vimls", "gopls" },
            })

            mason_lsp.setup_handlers {

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

                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup({
                        settings = {
                            pyright = {
                                -- Using Ruff's import organizer
                                disableOrganizeImports = true,
                            },
                            python = {
                                pythonPath = vim.fn.exepath("python3"),
                                analysis = {
                                    ignore = { "*" },
                                    diagnosticMode = "off",
                                    -- autoSearchPaths = true,
                                    -- useLibraryCodeForTypes = true,
                                    -- diagnosticMode = "openFilesOnly",
                                    typeCheckingMode = "off",
                                },
                            },
                        },
                        capabilities = capabilities,
                    })
                end,

                ["basedpyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.basedpyright.setup({
                        settings = {
                            basedpyright = {
                                analysis = {
                                    -- typeCheckingMode = "off",
                                    ignore = { "*" },
                                    diagnosticSeverityOverrides = {
                                        reportUndefinedVariable = true,
                                        reportUnusedVariable = false,
                                        reportAssignmentType = false,
                                        reportUnknownMemberType = false,
                                        reportExplicitAny = false,
                                        reportUnknownVariableType = false,
                                        reportUnknownArgumentType = false,
                                        reportAny = false,
                                        reportArgumentType = false,
                                        reportAttributeAccessIssue = false,
                                    },
                                },
                                -- ignore = { "*" },
                            },
                            python = {
                                pythonPath = vim.fn.exepath("python3"),
                                analysis = {
                                    ignore = { "*" },
                                },
                            },
                        },
                        capabilities = capabilities,
                    })
                end,

                ["ruff"] = function()
                    local lspconfig = require("lspconfig")

                    vim.api.nvim_create_autocmd("LspAttach", {
                        group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
                        callback = function(args)
                            local client = vim.lsp.get_client_by_id(args.data.client_id)
                            if client == nil then
                                return
                            end
                            if client.name == "ruff" then
                                -- Disable hover in favor of Pyright
                                client.server_capabilities.hoverProvider = false
                            end
                        end,
                        desc = "LSP: Disable hover capability from Ruff",
                    })

                    lspconfig.ruff.setup({
                        settings = {
                            python = {
                                pythonPath = vim.fn.exepath("python3"),
                            },
                        },
                        capabilities = capabilities,
                        -- root_dir = lspconfig.util.root_pattern("pyproject.toml", ".git") or vim.fn.getcwd(),
                        root_dir = function(fname)
                            return lspconfig.util.find_git_ancestor(fname)
                                or lspconfig.util.root_pattern("pyproject.toml")(fname)
                                or vim.fn.getcwd()
                        end,
                    })
                end,

                ["pylsp"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pylsp.setup({
                        settings = {
                            python = {
                                pythonPath = vim.fn.exepath("python3"),
                                analysis = {
                                    ignore = { "*" },
                                    diagnosticMode = "off",
                                    -- autoSearchPaths = true,
                                    -- useLibraryCodeForTypes = true,
                                    -- diagnosticMode = "openFilesOnly",
                                    typeCheckingMode = "off",
                                    -- autoSearchPaths = true,
                                    -- useLibraryCodeForTypes = true,
                                    -- diagnosticMode = "openFilesOnly",
                                },
                            },
                            pylsp = {
                                -- Using Ruff's import organizer
                                disableOrganizeImports = true,
                                plugins = {
                                    pylint = {
                                        enabled = false,
                                        ignore = { "E501" },
                                        maxLineLength = 160, -- Adjust this value as needed
                                    },
                                    pyflakes = {
                                        enabled = true,
                                        ignore = { "E501" },
                                        maxLineLength = 160, -- Adjust this value as needed
                                    },
                                    pylsp_mypy = { enabled = false },
                                    pycodestyle = { enabled = false },
                                    mccabe = { enabled = false },
                                    -- pycodestyle = {
                                    -- 	ignore = { "E501" },
                                    -- 	maxLineLength = 160, -- Adjust this value as needed
                                    -- },
                                },
                            },
                        },
                        capabilities = capabilities,
                    })
                end,

                ["clangd"] = function()
                    local lspconfig = require("lspconfig")

                    lspconfig.clangd.setup {
                        cmd = { "clangd", "--compile-commands-dir=" .. vim.fn.getcwd() }, -- Ensure it points to your project with compile_commands.json
                        filetypes = { "c", "cpp", "objc", "objcpp" },
                        settings = {
                            clangd = {
                                -- You can add more clangd options here as needed
                            }
                        }
                    }
                end,

                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup({
                        settings = {
                            gopls = {
                                -- Include integration tests and other build tags
                                buildFlags = { "-tags=integration" },
                                -- Analyze test files
                                analyses = {
                                    unusedparams = true,
                                    shadow = false,
                                },
                                -- Enable all experimentalFeatures
                                staticcheck = true,
                            },
                        },
                    })
                end,

                -- and will be called for each installed server that doesn't have
                -- The first entry (without a key) will be the default handler
                -- a dedicated handler.
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup({})
                end,
            }
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

            local lsp_attach = function(client, bufnr)
                -- Create your keybindings here...
            end

            -- WARNING: As we sestup handle in maso;n-lspconfig already, do not use this
            -- require("mason-lspconfig").setup_handlers({
            --     function(server_name)
            --         lspconfig[server_name].setup({
            --             on_attach = lsp_attach,
            --             capabilities = lsp_capabilities,
            --         })
            --     end,
            -- })

            lspconfig.dartls.setup({
                cmd = { "dart", "language-server", "--protocol=lsp" },
            })

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
                -- on_attach = function(client, bufnr)
                -- 	require("ltex_extra").setup({
                -- 		load_langs = { "en-GB" },
                -- 		path = "~/.config/nvim/spell/en-GB",
                -- 		-- path = vim.fn.expand('~') .. '/.local/share/ltex',
                -- 	})
                -- end,
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

            -- protobuf
            -- add protobuf lsp to lsp config
            -- auto setup in mason does not work as mason lsp config does not recognise protols
            lspconfig.protols.setup({
                capabilities = capabilities,
                -- Use buf.yaml for workspace configuration
                root_dir = lspconfig.util.root_pattern("buf.yaml", "buf.work.yaml", ".git"),
                cmd = {
                    "protols",
                    -- Tell protols to include the flyte2 directory in the proto path
                    "-I", vim.fn.getcwd() .. "/flyte2",
                    "-I", vim.fn.getcwd() .. "/idl",
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
                virtual_text = true,
                signs = true,
                underline = false,
                update_in_insert = false,
                severity_sort = true,
            })

            -- Set default border for LSP floating windows
            require('lspconfig.ui.windows').default_options.border = 'rounded'

            -- Override vim.lsp.util.open_floating_preview to set width limits
            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or 'rounded'
                opts.max_width = opts.max_width or 80
                opts.max_height = opts.max_height or 30
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            	border = "rounded",
            	max_width = 80,
            	max_height = 30,
            })
        end,
    },
}

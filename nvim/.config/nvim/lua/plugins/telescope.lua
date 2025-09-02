return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local builtin = require("telescope.builtin")
            local action = require("telescope.actions")
            local telescope = require("telescope")
            local lga_actions = require("telescope-live-grep-args.actions")

            telescope.setup({
                defaults = {
                    layout_strategy = "horizontal",
                    layout_config = {
                        width = { padding = 0 },
                        height = { padding = 0 },
                        preview_cutoff = 1,
                    },
                    mappings = {
                        i = {
                            ["<c-d>"] = action.delete_buffer,
                        },
                        n = {
                            ["<c-d>"] = action.delete_buffer,
                        },
                    },
                    -- other defaults configuration here
                },
                extensions = {
                    live_grep_args = {
                        auto_quoting = true, -- enable/disable auto-quoting
                        -- define mappings, e.g.
                        mappings = { -- extend mappings
                            i = {
                                ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                                ["<C-i>"] = nil,
                                -- freeze the current list and start a fuzzy search in the frozen list
                                -- ["<C-s>"] = lga_actions.to_fuzzy_refine,
                            },
                        },
                        -- ... also accepts theme settings, for example:
                        -- theme = "dropdown", -- use dropdown theme
                        -- theme = { }, -- use own theme spec
                        -- layout_config = { mirror=true }, -- mirror preview pane
                    },
                },
                -- other configuration values here
            })

            -- builtin
            vim.keymap.set(
                "n",
                "<leader>ff",
                builtin.find_files,
                { desc = "Telescope: Find files in current workspace" }
            )
            vim.keymap.set("n", "<leader>fc", function()
                builtin.find_files({
                    cwd = vim.fn.expand("%:p:h"),
                    hidden = true,
                })
            end, { desc = "Telescope: Find files in current directory" })

            vim.keymap.set(
                "n",
                "<leader>gw",
                telescope.extensions.live_grep_args.live_grep_args,
                { desc = "Telescope: Live Grep with args in current workspace" }
            )
            -- vim.keymap.set("n", "<leader>gw", builtin.live_grep, { desc = "Telescope: Live Grep in current workspace" })
            vim.keymap.set("n", "<C-f>", function()
                builtin.live_grep({
                    search_dirs = { vim.fn.expand("%:p") },
                    hidden = true,
                })
            end, { desc = "Telescope: Live Grep in current file" })

            vim.keymap.set("n", "<leader>gc", function()
                builtin.live_grep({
                    cwd = vim.fn.expand("%:p:h"),
                    hidden = true,
                })
            end, { desc = "Telescope: Live Grep in current directory" })

            vim.keymap.set(
                "n",
                "<leader>gn",
                builtin.treesitter,
                { desc = "Telescope: Lists Function names, variables, from Treesitter" }
            )

            -- lsp
            vim.keymap.set("n", "<leader>ci", builtin.lsp_incoming_calls, {desc = "Telescope: List LSP incoming calls for word under the cursor"})
            vim.keymap.set("n", "<leader>co", builtin.lsp_incoming_calls, {desc = "Telescope: List LSP outgoing calls for word under the cursor"})

            vim.keymap.set("n", "<C-h>", builtin.help_tags, {})
            vim.keymap.set("n", "<leader>b", builtin.buffers, {})


            -- action mappings moved to main setup above

            -- load extensions
            telescope.load_extension("live_grep_args")
            telescope.load_extension("fzf")
        end,
    },

    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            -- This is your opts table
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            -- even more opts
                        }),
                    },
                },
            })

            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "nvim-telescope/telescope-project.nvim",
        config = function()
            require("telescope").load_extension("project")
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").load_extension("file_browser")

            vim.keymap.set("n", "<leader>fb", function()
                require("telescope").extensions.file_browser.file_browser({
                    cwd = vim.fn.expand("%:p:h"),
                    hidden = true,
                })
            end, { desc = "Telescope file browser: current directory" })
        end,
    },
}

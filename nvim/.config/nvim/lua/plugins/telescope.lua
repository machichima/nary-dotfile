return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            local action = require("telescope.actions")

            -- builtin
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find files in current workspace" })
            vim.keymap.set("n", "<leader>fc", function()
                builtin.find_files({
                    cwd = vim.fn.expand("%:p:h"),
                    hidden = true,
                })
            end, { desc = "Telescope: Find files in current directory" })

            vim.keymap.set("n", "<leader>gw", builtin.live_grep, { desc = "Telescope: Live Grep in current workspace" })
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

            vim.keymap.set("n", "<C-h>", builtin.help_tags, {})
            vim.keymap.set("n", "<leader>b", builtin.buffers, {})

            -- action
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<c-d>"] = action.delete_buffer,
                        },
                        n = {
                            ["<c-d>"] = action.delete_buffer,
                        },
                    },
                },
            })
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
    }
}

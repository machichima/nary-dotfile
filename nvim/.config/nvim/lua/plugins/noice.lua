return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        config = function()
            require("notify").setup({
                timeout = 100,
            })

            require("noice").setup({
                -- Completely disable LSP integration to prevent interference
                lsp = {
                    progress = {
                        enabled = true,  -- Keep LSP progress messages
                    },
                    override = {},  -- Remove all overrides
                    signature = {
                        enabled = false,
                    },
                    hover = {
                        enabled = false,
                    },
                    message = {
                        enabled = true,  -- Keep LSP messages
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false, -- Disable to let native handlers control borders
                },
            })
        end,
    },
}

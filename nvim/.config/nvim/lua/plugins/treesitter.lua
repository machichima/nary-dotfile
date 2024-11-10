local md_toc = function()
    local query_string = [[(atx_heading)
        [(atx_h1_marker) (atx_h2_marker) (atx_h3_marker) (atx_h4_marker) (atx_h5_marker) (atx_h6_marker)] @level
        heading_content: ((inline) @heading)]]
    local query = vim.treesitter.query.parse("markdown", query_string)
    local parser = vim.treesitter.get_parser(nil, "markdown")
    local tree = parser:parse()[1]:root()
    local headings = {}
    local stage_heading = function(heading_level)
        return function(heading_text, heading_line)
            table.insert(headings, {
                text = string.rep("·   ", heading_level) .. heading_text,
                lnum = heading_line + 1,
                bufnr = vim.fn.bufnr(),
            })
        end
    end
    local add_staged_heading = nil
    for _, node, _ in query:iter_captures(tree, 0, 0, -1) do
        if node:type() ~= "inline" then
            local heading_level = string.len(vim.treesitter.get_node_text(node, 0))
            add_staged_heading = stage_heading(heading_level)
            goto continue
        end
        if add_staged_heading == nil then
            error("No heading level found")
        end
        add_staged_heading(vim.treesitter.get_node_text(node, 0), node:range())
        ::continue::
    end
    vim.fn.setqflist(headings, "r")
    local qfbufnr = vim.fn.getqflist({ winid = 0, qfbufnr = 0 })
    vim.cmd("copen")
    vim.api.nvim_set_option_value("conceallevel", 2, { win = qfbufnr["winid"] })
    vim.api.nvim_set_option_value("concealcursor", "niv", { win = qfbufnr["winid"] })
    vim.cmd([[syntax match ConcealedDetails /\v^[^|]*\|[^|]*\| / conceal]])
    vim.cmd([[syntax match ConcealBullet /·/ conceal]])
    local qf_mappings = {
        {
            "n",
            "<C-p>",
            function()
                pcall(vim.cmd, "cprev")
                vim.cmd([[wincmd p]])
            end,
        },
        {
            "n",
            "<C-n>",
            function()
                pcall(vim.cmd, "cnext")
                vim.cmd([[wincmd p]])
            end,
        },
        {
            "n",
            "<ESC>",
            function()
                vim.cmd("cclose")
            end,
        },
    }
end

return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")

        config.setup({
            ensure_installed = {
                "lua",
                "python",
                "r",
                "dockerfile",
                "git_config",
                "jsdoc",
                "make",
                "toml",
                "vimdoc",
                "yaml",
                -- 'markdown'
            },
            -- auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = {
                        ["]j"] = "@cellseparator",
                        ["]c"] = "@cellcontent",
                    },
                    goto_previous_start = {
                        ["[j"] = "@cellseparator",
                        ["[c"] = "@cellcontent",
                    },
                },
            },

            vim.keymap.set("n", "<leader>toc", md_toc, {}),
        })
    end,
}

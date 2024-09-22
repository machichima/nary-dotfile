return {
    'machichima/image-view.nvim',
    name = "imageview",
    config = function()
        local imageview = require("imageview")
        imageview.setup({
            opts = {
                open_type = "kitty-tmux",
                -- option:
                -- 1. "explorer": by Windows picture / tmux
                -- 2. "wezterm-tmux"
                -- 3. "kitty-tmux"
                -- 4. "wsl": use `open` command
                -- 5. "feh": use `feh -. filepath` to open the image (only available on linux)
            },
        })

        vim.keymap.set("n", "<leader>i", imageview.get_node_at_cursor, {})
    end,
}

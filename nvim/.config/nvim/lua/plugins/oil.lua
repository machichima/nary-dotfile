return {
    "stevearc/oil.nvim",
    opts = {
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function ()
        require("oil").setup({
            view_options = {
                show_hidden = false,
            }
        })
    end
}

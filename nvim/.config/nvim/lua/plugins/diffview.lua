return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup({
      keymaps = {
        view = {
          ["]c"] = function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              require("diffview.actions").next_conflict()
            end
          end,
          ["[c"] = function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              require("diffview.actions").prev_conflict()
            end
          end,
        },
      },
    })
  end,
}

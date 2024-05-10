return {
  "rolv-apneseth/tfm.nvim",
  name = 'tfm',
  opts = {
    file_manager = "ranger",
    enable_cmds = true
  },
  keys = {
        -- Make sure to change these keybindings to your preference,
        -- and remove the ones you won't use
        {
            "<leader>e",
            ":Tfm<CR>",
            desc = "TFM",
        },
        {
            "<leader>mh",
            ":TfmSplit<CR>",
            desc = "TFM - horizontal split",
        },
        {
            "<leader>mv",
            ":TfmVsplit<CR>",
            desc = "TFM - vertical split",
        },
        {
            "<leader>mt",
            ":TfmTabedit<CR>",
            desc = "TFM - new tab",
        },
    }
}

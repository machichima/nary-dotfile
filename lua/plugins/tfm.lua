return {
  "rolv-apneseth/tfm.nvim",
  name = "tfm",
  lazy = false,
  opts = {
    file_manager = "ranger",
    enable_cmds = true,
    replace_netrw = true,
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
  },

  -- config = function()
  --   vim.keymap.set('n', "<leader>e", function ()
  --     local tfm = require("tfm")
  --     local cwd = vim.fn.getcwd()
  --     tfm.select_file_manager("ranger")
  --     tfm.open(cwd .. "/", "tabedit")
  --   end)
  -- end
}

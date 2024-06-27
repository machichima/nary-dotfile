local function no_buffers_worth_saving()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(bufnr, "buflisted") and not vim.api.nvim_buf_get_option(bufnr, "readonly") then -- disregard unlisted buffers
      if vim.api.nvim_buf_get_name(bufnr) ~= "" then
        return false -- there is a buffer with a name
      end
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      if #lines > 1 or (#lines == 1 and #lines[1] > 0) then
        return false -- there is a buffer with content
      end
    end
  end
  return true -- there are no listed, writable, named, nonempty buffers
end

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
      -- ":Tfm<CR>",
      function()
        local is_buf_empty = vim.fn.empty(vim.fn.expand("%:t")) == 1
        local path = nil
        if is_buf_empty then
          -- get current buffer folder
          path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
        else
          -- buf not empty, have file opened
          path = vim.fn.expand("%:p")
        end
        -- local cwd = vim.fn.getcwd()
        require("tfm").select_file_manager("ranger")
        require("tfm").open(path)
      end,
      desc = "tfm",
    },
    {
      "<leader>mh",
      ":Tfmsplit<cr>",
      desc = "tfm - horizontal split",
    },
    {
      "<leader>mv",
      ":Tfmvsplit<cr>",
      desc = "tfm - vertical split",
    },
    {
      "<leader>mt",
      ":TfmTabedit<cr>",
      desc = "tfm - new tab",
    },
  },

  -- config = function()
  --   -- vim.keymap.set('n', "<leader>e", function ()
  --   --   local tfm = require("tfm")
  --   --   local cwd = vim.fn.getcwd()
  --   --   tfm.select_file_manager("ranger")
  --   --   tfm.open(cwd .. "/", "tabedit")
  --   -- end)
  -- end,
}

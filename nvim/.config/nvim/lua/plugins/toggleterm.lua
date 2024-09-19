-- referece for setup : https://medium.com/@shaikzahid0713/terminal-support-in-neovim-c616923e0431

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({

      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,

      open_mapping = [[<leader>/]],
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

    function _lazygit_toggle()
      lazygit:toggle()
    end

    -- python
    function _PYTHON_TOGGLE()
      local python = Terminal:new({ cmd = "ipython", hidden = true, direction = "vertical" })
      python:toggle()
    end

    -- go
    function _GO_TOGGLE()
      local go = Terminal:new({ direction = "vertical" })
      local path = vim.fn.expand("%:p")
      go:toggle()
      go:send("go run " .. path)
    end

    function _VERTICAL_SPLIT()
      local verSplit = Terminal:new({ direction = "vertical" })
      verSplit:toggle()
    end

    vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("n", "<leader>tv", "<cmd>lua _VERTICAL_SPLIT()<cr>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap(
      "n",
      "<leader>tv",
      "<cmd>ToggleTerm direction=vertical<cr><CR>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>th",
      "<cmd>ToggleTerm direction=horizontal<cr><CR>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>tg", "<cmd>lua _GO_TOGGLE()<cr>", { noremap = true, silent = true })
  end,
}

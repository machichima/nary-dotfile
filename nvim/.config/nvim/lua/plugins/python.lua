-- This is for some more setup packages for Python

return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    config = function()
      require("venv-selector").setup({
        anaconda_envs_path = "~/miniconda3/envs",
        dap_enabled = true,
      })
    end,
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "wezterm"
      vim.g.molten_output_win_max_height = 20

      -- I find auto open annoying, keep in mind setting this option will require setting
      -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
      -- vim.g.molten_auto_open_output = false

      -- optional, I like wrapping. works for virt text and the output window
      vim.g.molten_wrap_output = true

      -- Output as virtual text. Allows outputs to always be shown, works with images, but can
      -- be buggy with longer images
      vim.g.molten_virt_text_output = true

      -- this will make it so the output shows up below the \`\`\` cell delimiter
      vim.g.molten_virt_lines_off_by_1 = true
    end,

    config = function()
      -- require("molten-nvim").setup({})



      vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
      vim.keymap.set(
        "n",
        "<leader>me",
        ":MoltenEvaluateOperator<CR>",
        { silent = true, desc = "run operator selection" }
      )
      vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" })
      vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" })
      vim.keymap.set(
        "v",
        "<leader>r",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, desc = "evaluate visual selection" }
      )

      vim.keymap.set("n", "<leader>rd", ":MoltenDelete<CR>", { silent = true, desc = "molten delete cell" })
      vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
      vim.keymap.set(
        "n",
        "<leader>os",
        ":noautocmd MoltenEnterOutput<CR>",
        { silent = true, desc = "show/enter output" }
      )
    end,
  },
  --	{
  --		"Vigemus/iron.nvim",
  --		config = function()
  --			local iron = require("iron.core")
  --
  --			iron.setup({
  --				config = {
  --					-- Whether a repl should be discarded or not
  --					scratch_repl = true,
  --					-- Your repl definitions come here
  --					repl_definition = {
  --						sh = {
  --							-- Can be a table or a function that
  --							-- returns a table (see below)
  --							command = { "zsh" },
  --						},
  --					},
  --					-- How the repl window will be displayed
  --					-- See below for more information
  --					repl_open_cmd = require("iron.view").bottom(40),
  --				},
  --				-- Iron doesn't set keymaps by default anymore.
  --				-- You can set them here or manually add keymaps to the functions in iron.core
  --				keymaps = {
  --					send_motion = "<space>sc",
  --					visual_send = "<space>sc",
  --					send_file = "<space>sf",
  --					send_line = "<space>sl",
  --					send_paragraph = "<space>sp",
  --					send_until_cursor = "<space>su",
  --					send_mark = "<space>sm",
  --					mark_motion = "<space>mc",
  --					mark_visual = "<space>mc",
  --					remove_mark = "<space>md",
  --					cr = "<space>s<cr>",
  --					interrupt = "<space>s<space>",
  --					exit = "<space>sq",
  --					clear = "<space>cl",
  --				},
  --				-- If the highlight is on, you can change how it looks
  --				-- For the available options, check nvim_set_hl
  --				highlight = {
  --					italic = true,
  --				},
  --				ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  --			})
  --
  --			-- iron also has a list of commands, see :h iron-commands for all available commands
  --			vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
  --			vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
  --			vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
  --			vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
  --		end,
  --	},
}

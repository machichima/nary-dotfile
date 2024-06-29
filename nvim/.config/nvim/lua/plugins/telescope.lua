return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      local action = require("telescope.actions")

      -- builtin
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find files in current workspace" })
      vim.keymap.set("n", "<leader>fc", function()
        builtin.find_files({
          cwd = vim.fn.expand("%:p:h"),
          hidden = true,
        })
      end, { desc = "Telescope: Find files in current directory" })
      vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Telescope: Live Grep in current workspace" })
      vim.keymap.set("n", "<leader>fg", function()
        builtin.live_grep({
          cwd = vim.fn.expand("%:p:h"),
          hidden = true,
        })
      end, { desc = "Telescope: Live Grep in current directory" })
      vim.keymap.set("n", "<C-h>", builtin.help_tags, {})
      vim.keymap.set("n", "<leader>b", builtin.buffers, {})

      -- action
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<c-d>"] = action.delete_buffer,
            },
            n = {
              ["<c-d>"] = action.delete_buffer,
            },
          },
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      -- This is your opts table
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
        },
      })

      require("telescope").load_extension("ui-select")
    end,
  },
  {
    "nvim-telescope/telescope-project.nvim",
    config = function()
      require("telescope").load_extension("project")
    end,
  },
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
    },
    config = true,
  },
}

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local mason_lsp = require("mason-lspconfig")

      local handlers = {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({})
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        end,
      }

      mason_lsp.setup({
        ensure_installed = { "lua_ls", "pylsp", "vimls" },
        handlers = handlers
      })
    end,
  },
  {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      -- python
      -- lspconfig.pylsp.setup({
      --   settings = {
      --     python = {
      --       pythonPath = vim.fn.exepath("python3"),
      --     },
      --   },
      --   capabilities = capabilities,
      -- })

      -- lspconfig.ltex.setup{
      --   capabilities = capabilities,
      -- }

      -- lua
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
        capabilities = capabilities,
      })

      -- vim
      lspconfig.vimls.setup({
        capabilities = capabilities,
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}

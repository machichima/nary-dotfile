return {
	"nvim-treesitter/nvim-treesitter", 
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")

		config.setup({
			ensure_installed = { 
        'lua', 
        'python', 
        'r',
        'dockerfile',
        'git_config',
        'jsdoc',
        'make',
        'toml',
        'vimdoc',
        'markdown'
      },
      auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})

	end

}


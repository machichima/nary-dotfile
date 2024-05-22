local opts = {

	workspaces = {
		{
			name = "ds",
			path = "~/workData/obsidian/Data Science",
		},
	},
	log_level = vim.log.levels.INFO,

	daily_notes = {
		-- Optional, if you keep daily notes in a separate directory.
		folder = "Review_and_Planner/Daily_Notes",
		-- Optional, if you want to change the date format for the ID of daily notes.
		date_format = "%Y-%m-%d",
		-- Optional, if you want to change the date format of the default alias of daily notes.
		alias_format = "%B %-d, %Y",
		-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
		template = nil,
	},

	-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
	completion = {
		-- Set to false to disable completion.
		nvim_cmp = true,
		-- Trigger completion at 2 chars.
		min_chars = 2,
	},

	-- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
	-- way then set 'mappings = {}'.
	mappings = {
		-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
		-- ["gf"] = {
		--   action = function()
		--     local ob_client = require("obsidian").get_client()
		--     return "<cmd>Telescope find_files search_dirs=require('obsidian').get_client().dir"
		--     -- vim.cmd(":Telescope find_files search_dirs=ob_client.dir")
		--     -- require('telescope.builtin').find_files({search_dirs=ob_client.dir})
		--     -- require("obsidian").util.gf_passthrough()
		--   end,
		--   opts = { noremap = false, expr = true, buffer = true },
		-- },
		-- Toggle check-boxes.
		["<leader>ch"] = {
			action = function()
				return require("obsidian").util.toggle_checkbox()
			end,
			opts = { buffer = true },
		},
		-- Smart action depending on context, either follow link or toggle checkbox.
		["<cr>"] = {
			action = function()
				return require("obsidian").util.smart_action()
			end,
			opts = { buffer = true, expr = true },
		},
	},

	-- Where to put new notes. Valid options are
	--  * "current_dir" - put new notes in same directory as the current buffer.
	--  * "notes_subdir" - put new notes in the default notes subdirectory.
	new_notes_location = "current_dir",

	attachments = {
		-- The default folder to place images in via `:ObsidianPasteImg`.
		-- If this is a relative path it will be interpreted as relative to the vault root.
		-- You can always override this per image by passing a full path to the command instead of just a filename.
		img_folder = "@attachments", -- This is the default
		-- A function that determines the text to insert in the note when pasting an image.
		-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
		-- This is the default implementation.
		---@param client obsidian.Client
		---@param path obsidian.Path the absolute path to the image file
		---@return string
		img_text_func = function(client, path)
			path = client:vault_relative_path(path) or path
			return string.format("![%s](%s)", path.name, path)
		end,
	},
}

return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	--   "BufReadPre path/to/my-vault/**.md",
	--   "BufNewFile path/to/my-vault/**.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = opts,
	-- see below for full list of options 👇
	config = function()
		require("obsidian").setup(opts)

		function _TELESCOPE_FIND()
			location, name, link_type = require("obsidian.util").parse_cursor_link({ include_naked_urls = true, include_file_urls = true })
      require("telescope.builtin").find_files({search_dirs=require('obsidian').get_client().dir, search_file=location .. ".md"})
		end

		vim.api.nvim_set_keymap(
			"n",
			"gf",
			"<cmd>lua _TELESCOPE_FIND()<CR>",
			-- Telescope find_files search_dirs=require('obsidian').get_client().dir<CR>",
			{ noremap = true, silent = true }
		)
	end,
}

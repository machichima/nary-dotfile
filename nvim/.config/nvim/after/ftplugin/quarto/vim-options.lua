vim.opt_local.textwidth = 110
vim.cmd("setlocal colorcolumn=+1")

-- formatting table
-- ref: https://heitorpb.github.io/bla/format-tables-in-vim/
vim.keymap.set(
	"v",
	"<leader>tt",
	"! tr -s ' ' | column -t -s '|' -o '|'<CR>",
	{ noremap = true, silent = true, buffer = true, desc = "format markdown table" }
)

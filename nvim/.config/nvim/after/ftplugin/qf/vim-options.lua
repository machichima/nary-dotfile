vim.keymap.set("n", "<C-n>", ":cnext<CR>zz", { noremap = true, silent = true})
vim.keymap.set("n", "<C-p>", ":cprev<CR>zz", { noremap = true, silent = true})

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


vim.cmd([[
  syntax region HighlightEquals start=/==/ end=/==/
  highlight HighlightEquals guifg=yellow ctermfg=yellow

  syntax region HighlightBold start=/\*\*/ end=/\*\*/
  highlight HighlightBold guifg=blue ctermfg=blue
]])


vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
})

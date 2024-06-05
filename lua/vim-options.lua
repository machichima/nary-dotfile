vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hidden = true
vim.opt.conceallevel = 1

vim.g.mapleader = " "
vim.keymap.set("n", "<C-t>", ":tabs<CR>", {})
vim.keymap.set("i", "<C-v>", '<ESC>l"+Pli') -- Paste insert mode

vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- set work dir to current dir
vim.keymap.set("n", "<leader>w", "<cmd>:tcd %:h<CR>")

-- exit from terminal model to normal
vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", { noremap = true })

-- resizes panes
vim.keymap.set("n", "<C-right>", "<C-w>>")
vim.keymap.set("n", "<C-left>", "<C-w><")
vim.keymap.set("n", "<C-up>", "<C-w>+")
vim.keymap.set("n", "<C-down>", "<C-w>-")

-- copy and paste
-- copy
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+yg_')
vim.keymap.set("n", "<leader>yy", '"+yy')
-- paste
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')
-- cut
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')
vim.keymap.set("n", "<leader>D", '"+dg_')
vim.keymap.set("n", "<leader>dd", '"+dd')


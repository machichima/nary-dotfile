vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.hidden = true;

vim.g.mapleader = " "
vim.keymap.set('n', '<C-t>', ':tabs<CR>', {})
vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli') -- Paste insert mode

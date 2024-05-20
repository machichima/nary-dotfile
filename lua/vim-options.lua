vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.hidden = true;
vim.opt.conceallevel = 1;

vim.g.mapleader = " "
vim.keymap.set('n', '<C-t>', ':tabs<CR>', {})
vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli') -- Paste insert mode
vim.keymap.set('n', 'j', 'jzz')
vim.keymap.set('n', 'k', 'kzz')

vim.api.nvim_create_autocmd({"CursorMoved"}, {
  callback = function ()
    vim.api.nvim_feedkeys("zz", 'n', true)
  end 

})

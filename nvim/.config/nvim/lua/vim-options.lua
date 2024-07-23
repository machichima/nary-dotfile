vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.opt.linebreak = true
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.hidden = true
vim.opt.conceallevel = 1
vim.opt.cursorline = true

vim.g.mapleader = " "
vim.keymap.set("n", "<C-t>", ":tabs<CR>", {})
vim.keymap.set("i", "<C-v>", '<ESC>l"+Pli') -- Paste insert mode

vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- set work dir to current dir
vim.keymap.set(
    "n",
    "<leader>w",
    "<cmd>:tcd %:h<CR>",
    { desc = "set the workspace to current directory for the current tab" }
)

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

-- moving lines
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("i", "<C-j>", "<Esc>:m .+1<CR>==gi", { silent = true })

vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { silent = true })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("i", "<C-k>", "<Esc>:m .-2<CR>==gi", { silent = true })

-- jump between buffer
-- vim.keymap.set("n", "tj", ":bnext<CR>", { silent = true })
-- vim.keymap.set("n", "tk", ":bprev<CR>", { silent = true })

-- jump between tabs
vim.keymap.set("n", "tj", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "tk", ":tabprevious<CR>", { silent = true })

-- close all buffer except current one
vim.api.nvim_create_user_command("BufOnly", ":%bd|e#|bd#", {})

-- open app link (e.g. Zotero)
vim.keymap.set("n", "<leader>gx", ":!explorer.exe <cfile><CR>", { silent = true, desc = "Open url through Windows" })

-- copy filename to clipboard
function copyFileName()
    local filepath = vim.fn.expand("%:t")
    vim.fn.setreg("+", filepath) -- writvim-options.luae to clippoard
end

vim.keymap.set("n", "<leader>pc", copyFileName, { noremap = true, silent = true })

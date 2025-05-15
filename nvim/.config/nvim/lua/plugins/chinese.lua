return {
    'noearc/jieba.nvim',
    dependencies = { 'noearc/jieba-lua' },
    config = function()
        vim.keymap.set({ 'x', 'n' }, 'B', '<cmd>lua require("jieba_nvim").wordmotion_B()<CR>',
            { noremap = false, silent = true })
        vim.keymap.set({ 'x', 'n' }, 'b', '<cmd>lua require("jieba_nvim").wordmotion_b()<CR>',
            { noremap = false, silent = true })
        vim.keymap.set({ 'x', 'n' }, 'w', '<cmd>lua require("jieba_nvim").wordmotion_w()<CR>',
            { noremap = false, silent = true })
        vim.keymap.set({ 'x', 'n' }, 'W', '<cmd>lua require("jieba_nvim").wordmotion_W()<CR>',
            { noremap = false, silent = true })
        vim.keymap.set({ 'x', 'n' }, 'E', '<cmd>lua require("jieba_nvim").wordmotion_E()<CR>',
            { noremap = false, silent = true })
        vim.keymap.set({ 'x', 'n' }, 'e', '<cmd>lua require("jieba_nvim").wordmotion_e()<CR>',
            { noremap = false, silent = true })
        vim.keymap.set({ 'x', 'n' }, 'ge', '<cmd>lua require("jieba_nvim").wordmotion_ge()<CR>',
            { noremap = false, silent = true })
        vim.keymap.set({ 'x', 'n' }, 'gE', '<cmd>lua require("jieba_nvim").wordmotion_gE()<CR>',
            { noremap = false, silent = true })
    end
}

vim.keymap.set("v", "<leader>w", function()
    print(vim.fn.wordcount().visual_words)
end, { noremap = true, silent = true, buffer = true, desc = "selected word count" })

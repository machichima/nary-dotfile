packages_table = {
    "nvim-lualine/lualine.nvim",
    config = function()
        local prose = require("nvim-prose")
        require("lualine").setup({
            options = {
                theme = "codedark",
                component_separators = "|",
                section_separators = "",
            },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    "diagnostics",
                    {
                        "macro-recording",
                        fmt = show_macro_recording,
                    },
                },
                lualine_x = {
                    { prose.word_count, cond = prose.is_available },
                    -- { prose.reading_time, cond = prose.is_available },
                    "encoding",
                    "fileformat",
                    "filetype",
                },
            },
        })
    end,
}

function show_macro_recording()
    local recording_register = vim.fn.reg_recording()
    if recording_register == "" then
        return ""
    else
        return "Recording @" .. recording_register
    end
end

vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
        require("lualine").refresh({
            place = { "statusline" },
        })
    end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
        local uv = vim.uv
        local timer = uv.new_timer()
        timer:start(
            50,
            0,
            vim.schedule_wrap(function()
                require("lualine").refresh({
                    place = { "statusline" },
                })
            end)
        )
    end,
})

return packages_table

return {
  dir = "~/nvim_plugins/image-wezterm-tmux.nvim", -- Your path
  name = "imagewsl",
  config = function()
    require("imagewsl").setup({
      opts = {
        open_type = "explorer",
        -- option:
        -- 1. "explorer": by Windows picture / tmux
        -- 2. "tmux"
        -- 3. "wsl": use `open` command
      },
    })
  end,
}

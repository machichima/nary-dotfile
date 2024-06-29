return {
  "3rd/image.nvim",
  enabled = true,
  -- default config
  require("image").setup({
    backend = "kitty",
    integrations = {
      markdown = {
        enabled = true,
        -- clear_in_insert_mode = false,
        -- download_remote_images = true,
        only_render_image_at_cursor = true,
        filetypes = { "markdown", "vimwiki", "quarto" }, -- markdown extensions (ie. quarto) can go here
        resolve_image_path = function(document_path, image_path, fallback)
          -- document_path is the path to the file that contains the image
          -- image_path is the potentially relative path to the image. for
          -- markdown it's `![](this text)`
          local client = require("obsidian").get_client()

          local in_obsidian = false
          if string.find(vim.fn.resolve(document_path), tostring(client.current_workspace.path)) then
            -- vim.fn.resolve(vim.fn.expand("%:p"))
            in_obsidian = true
          end

          local url = ""
          if in_obsidian then
            -- For obsidian notes (with incomplete image path)
            local workspace_path = tostring(client.current_workspace.path)
            local attachments_folder = client.opts.attachments.img_folder
            local file_name = ""

            if image_path:match("^(.-)|") == nil then
              file_name = image_path
            else
              file_name = image_path:match("^(.-)|")
            end

            url = workspace_path .. "/" .. attachments_folder .. "/" .. file_name
          else
            -- For other markdown note (with full image path)
            url = image_path
          end

          -- you can call the fallback function to get the default behavior
          return fallback(document_path, url)
        end,
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    kitty_method = "normal",
    window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
  }),
}

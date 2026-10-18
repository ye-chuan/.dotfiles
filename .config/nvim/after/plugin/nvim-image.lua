require("image").setup({
    backend = "kitty", -- or "ueberzug" or "sixel"
    processor = "magick_cli", -- or "magick_rock"
    integrations = {
        markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = false,
            only_render_image_at_cursor = false,
            only_render_image_at_cursor_mode = "popup", -- or "inline"
            floating_windows = false, -- if true, images will be rendered in floating markdown windows
            filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        asciidoc = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = false,
            only_render_image_at_cursor = false,
            only_render_image_at_cursor_mode = "popup",
            floating_windows = false,
            filetypes = { "asciidoc", "adoc" },
        },
        -- The following might not have `download_remote_images`, but I'm setting
        -- them to false for now anyways just in case.
        neorg = {
            enabled = true,
            download_remote_images = false,
            filetypes = { "norg" },
        },
        rst = {
            enabled = true,
            download_remote_images = false,
        },
        typst = {
            enabled = true,
            filetypes = { "typst" },
            download_remote_images = false,
        },
        html = {
            enabled = false,
            download_remote_images = false,
        },
        css = {
            enabled = false,
            download_remote_images = false,
        },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    scale_factor = 1.0,
    kitty_direct_chunk_size = 4096, -- chunk size for direct Kitty graphics protocol transmission
    window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
    editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})


--- Opens the closest image in the system's default image viewer.
--- Relies on `image.nvim` to fetch image metadata for the current buffer,
--- calculates the distance from the cursor (by row) to each image, and uses
--- `vim.ui.open` on the nearest one.
--- This is superior to `gx` in the sense that it doesn't rely on file paths
--- (e.g. mermaid blocks, different working directory, etc.)
local function open_closest_img_externally()
    local ok, image = pcall(require, "image")
    if not ok then
        vim.notify("image.nvim is required", vim.log.levels.ERROR)
        return
    end

    -- Fetch all images currently rendered by image.nvim in this buffer
    local images = image.get_images()

    if not images or #images == 0 then
        vim.notify("No inline diagrams found to open.", vim.log.levels.WARN)
        return
    end

    -- Find the image closest to current cursor position
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local closest_img = images[1]
    local min_dist = math.huge
    for _, img in ipairs(images) do
        -- image.nvim stores the row position in geometry.y
        local img_line = (img.geometry and img.geometry.y) or 0
        local dist = math.abs(img_line - cursor_line)

        if dist < min_dist then
            min_dist = dist
            closest_img = img
        end
    end

    if closest_img and closest_img.path then
        vim.ui.open(closest_img.path)
    end
end


-- Keybinds
vim.keymap.set("n", "<leader>o", open_closest_img_externally,
    { desc = "Open closest image (using image.nvim) in system viewer" }
)

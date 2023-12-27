require("catppuccin").setup({
    --transparent_background = true,  -- Disables setting bg color (some terminal will just override transparency with bg color)
    integrations = {
        treesitter = true,
        cmp = true,
    },
    
    custom_highlights = function(colors)
        return {
            CmpItemMenu = { fg = C.overlay1 },  -- The source label for completion (this gives more of a subtle colour)
        }
    end,
})

vim.cmd.colorscheme "catppuccin-mocha"

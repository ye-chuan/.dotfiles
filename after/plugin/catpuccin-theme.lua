require("catppuccin").setup({
    --transparent_background = true,  -- Disables setting bg color (some terminal will just override transparency with bg color)
    integrations = {
        treesitter = true,
    }
})

vim.cmd.colorscheme "catppuccin-mocha"


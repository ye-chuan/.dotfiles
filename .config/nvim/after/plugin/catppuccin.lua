local utils = require("utils")

require("catppuccin").setup({
    flavour = "auto",
    transparent_background = true,  -- Disables setting bg color (some terminal will just override transparency with bg color)
    float = {
        transparent = true,     -- Enables transparency on floating windows (e.g. autocomplete)
        solid = false,          -- "true" refers to a style of using background colors instead of borders for float
    },
    integrations = {
        cmp = true,
        render_markdown = true,
    },

    -- Global Overrides
    custom_highlights = function(colors)
        return {
            -- Plugin: nvim-cmp
            CmpItemMenu = { fg = colors.overlay1 },  -- The source label (e.g. [lsp], [buf]) for completion (this gives more of a subtle colour)

            -- Plugin: render-markdown.nvim
            RenderMarkdownCode = { bg = colors.surface0 },
        }
    end,

    -- Per-flavour overrides
    highlight_overrides = {
        -- NOTE: I've currently only overridden for mocha as it is the only flavour I use
        mocha = function (mocha)
            return {
                -- Plugin: render-markdown.nvim
                --- Adjust the blending to have slightly more contrast
                RenderMarkdownH1Bg = { bg = utils.hex_blend(mocha.red, "#1e1e2e", 0.15) },
                RenderMarkdownH2Bg = { bg = utils.hex_blend(mocha.peach, "#1e1e2e", 0.15) },
                RenderMarkdownH3Bg = { bg = utils.hex_blend(mocha.yellow, "#1e1e2e", 0.15) },
                RenderMarkdownH4Bg = { bg = utils.hex_blend(mocha.green, "#1e1e2e", 0.15) },
                RenderMarkdownH5Bg = { bg = utils.hex_blend(mocha.sapphire, "#1e1e2e", 0.15) },
                RenderMarkdownH6Bg = { bg = utils.hex_blend(mocha.lavender, "#1e1e2e", 0.15) },
            }
        end
    }
})

vim.cmd.colorscheme "catppuccin-nvim"

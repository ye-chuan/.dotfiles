require('render-markdown').setup({
    completions = { lsp = { enabled = true } },

    quote = {
        -- Render the blockquote indicator even on soft wraps
        repeat_linebreak = true
    },

    checkbox = {
        custom = {
            important = {
                raw = "[v]",
                rendered = "󰱒 ",
                highlight = "RenderMarkdownChecked",
            },
        },
    },

    code = {
        -- Language `diff` has background disabled by default, but I prefer having
        -- the background on since my colourscheme does not set background for `diff`
        disable_background = { },

        -- "Tab" look around the language name
        language_border = ' ',
        language_left = '',
        language_right = '',
    },

    heading = {
        icons = { '󰼏 ', '󰎨 ', '󰼑 ', '󰎲 ', '󰼓 ', '󰎴 ' },

    },

    latex = {
        bottom_pad = 1,
    },
})

require('render-markdown').setup({
    completions = { lsp = { enabled = true } },
    quote = {
        -- Render the blockquote indicator even on soft wraps
        repeat_linebreak = true
    },
    code = {
        -- Language `diff` has background disabled by default, but I prefer having
        -- the background on since my colourscheme does not set background for `diff`
        disable_background = { },
    }
})

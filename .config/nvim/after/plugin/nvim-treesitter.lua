require("nvim-treesitter.configs").setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    -- Some of these requires tree-sitter CLI (e.g `npm -g install tree-sitter-cli`)
    ensure_installed = {
        "c", "python", "java", "cpp", "lua",
        "html", "javascript", "jsdoc", "typescript", "vue",
        "bash", "json",
        "haskell",
        "markdown", "markdown_inline", 
        "vim", "vimdoc",
        --latex",   -- (requires tree-sitter CLI)
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if we don't have tree-sitter CLI installed locally
    auto_install = false,

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        disable = { },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = { "latex" },
        -- `latex` syntax highlighting provided by `VimTeX` plugin
    },
}

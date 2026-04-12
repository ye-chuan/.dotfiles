-- This plugin not serves as merely a helper for managing parsers, actual
-- configuration for highlighting and folds has been moved to core.
--
-- However, the following are currently (2026) still managed by this plugin
--   Indentation - nvim-treesitter.indentexpr()

-- Help is in :h nvim-treesitter, which is different from :h treesitter (core)
-- There is no need to configure this plugin (i.e. `.setup`)

require("nvim-treesitter").install {
    -- Some might require tree-sitter CLI (e.g `npm -g install tree-sitter-cli`)
    "c", "python", "java", "cpp", "lua",
    "html", "javascript", "jsdoc", "typescript", "tsx", "vue",
    "bash", "json",
    "haskell",
    "markdown", "markdown_inline", 
    "vim", "vimdoc",
    --latex",   -- (requires tree-sitter CLI)
}

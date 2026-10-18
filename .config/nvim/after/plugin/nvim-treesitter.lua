-- This plugin not serves as merely a helper for managing parsers, actual
-- configuration for highlighting and folds has been moved to core.
--
-- However, the following are currently (2026) still managed by this plugin
--   Indentation - nvim-treesitter.indentexpr()

-- Help is in :h nvim-treesitter, which is different from :h treesitter (core)
-- There is no need to configure this plugin (i.e. `.setup`)

require("nvim-treesitter").install {
    -- Reminder that nvim-treesitter requires the tree-sitter CLI to be installed (via system package manager or npm)
    "c", "python", "java", "cpp", "lua", "c_sharp",
    "html", "javascript", "jsdoc", "typescript", "tsx", "vue",
    "json", "yaml", "toml", "diff",
    "bash",
    "markdown", "markdown_inline", "mermaid",
    "vim", "vimdoc",
    "haskell",
    "latex",
}

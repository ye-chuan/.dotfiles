-- This file contains configuration related to NeoVim's internal Treesitter
-- integration. Configuration for the nvim-treesitter plugin resides in
-- nvim/after/plugin/nvim-treesitter.lua, and the plugin is mainly used just
-- to install parsers

-- Currently (2026), Highlighting and Folds are already handled by core
-- (Indentation still handled by nvim-treesitter)

-- For reference, see the help for:
--  Highlighting - vim.treesitter.start()
--  Folds - vim.treesitter.foldexpr() and foldmethod

-- Instead of using ftplugins, which might get messy when we uninstall / install
-- more parsers, we will use a centralised Autocmd here to attempt to start
-- Treesitter Highlighting and set the Folding methods if the parser is installed.

vim.api.nvim_create_autocmd("Filetype", {
    group = vim.api.nvim_create_augroup("TreesitterGlobalConfig", {}),
    callback = function (ev)
        local bufnr = ev.buf
        
        -- Try to start treesitter (for highlighting), pcall fails silently if parser is missing
        local ts_started = pcall(vim.treesitter.start, bufnr)

        -- Since vim.treesitter.start sets `syntax=off` by default, if we still need Vim's Regex highlighting,
        -- we can set it back on here
        if ts_started and vim.bo[bufnr].filetype == "tex" then
            vim.bo[bufnr].syntax = "on" -- `latex` syntax highlighting provided by `VimTeX` plugin
        end

        if ts_started then
            -- `vim.schedule()` delays the running of the block to after ftplugins are ran
            -- (if not then of course the fallbacks defined in ftplugins might override the
            -- configs here)
            vim.schedule(function ()
                if not vim.api.nvim_buf_is_valid(bufnr) then    -- In case buffer died before this scheduled block runs
                    return
                end
                -- Using `nvim_buf_call` because `foldmethod` is a window-local option, calling something like
                -- `nvim_set_option_value(..., { buf = bufnr })` on a window-local option has undefined behaviour (#24398)
                -- Refer to `:h nvim_buf_call` we see if the buffer remains in the same window when this is ran then perfect,
                -- nothing changes, the option is set on this window.
                -- Even if buffer leaves the entire *tab* before the block runs, then a temporary window is created for the
                -- commands to run, and Vim remember these settings set by us for the next time the buffer moves into a
                -- window again (see :h local-options).
                vim.api.nvim_buf_call(bufnr, function()
                    if not vim.wo.diff then     -- Diff mode should use diff folds
                        vim.opt_local.foldmethod = "expr"
                        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    end
                    -- NOTE: Temporarily using nvim-treesitter plugin for this until core integrates treesitter indentations
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end)
            end)
        end
    end
})

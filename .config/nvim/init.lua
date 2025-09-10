if vim.g.vscode then
    -- VSCode Neovim Config (using the Neovim Extension)
    -- line numbering are handled by VSCode: Settings > Editor > Line Numbers
else

-- Plugins that needs to be configured early
-- Note that some plugins (like vimtex) needs to be sourced even earlier
-- than the `sharedrc.vim` itself due to some ordering issues?
-- (specifically: sourcing after the `syntax on` line seems to cause the
-- setting of `let g:vimtex_view_method = "zathura"` to occur too late?)
vim.cmd.source(vim.fn.stdpath("config") .. "/early-config/airlinerc.vim")

-- Import shared config file (shared with vanilla Vim)
local sharedrc = vim.fn.stdpath("config") .. "/sharedrc.vim"
vim.cmd.source(sharedrc)

require "nvimrc"
require "mainmodule"

end

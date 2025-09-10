-- Vim Keybindings
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})

-- Telescope Configuration
require("telescope").setup{
  defaults = {
    -- Default configuration for telescope goes here (non picker specific)
    -- config_key = value,
    prompt_prefix = " ",
    selection_caret = " ",
    border = false, -- NOTE: Temporary fix until telescope.nvim supports "winborder" from NeoVim v0.11
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        --["<C-h>"] = actions.which_key
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

-- Default Mappings
-- <C-n>/<Down> Next item
-- <C-p>/<Up>   Previous item
-- j/k          Next/previous (in normal mode)
-- H/M/L        Select High/Middle/Low (in normal mode)
-- gg/G         Select the first/last item (in normal mode)
-- <CR>         Confirm selection
-- <C-x>        Go to file selection as a split
-- <C-v>        Go to file selection as a vsplit
-- <C-t>        Go to a file in a new tab
-- <C-u>        Scroll up in preview window
-- <C-d>        Scroll down in preview window
-- <C-f>        Scroll left in preview window (NOTE: Not yet, only in v0.2.0)
-- <C-k>        Scroll right in preview window (NOTE: Not yet, only in v0.2.0)
-- <M-f>        Scroll left in results window (NOTE: Not yet, only in v0.2.0)
-- <M-k>        Scroll right in results window (NOTE: Not yet, only in v0.2.0)
-- <C-/>        Show mappings for picker actions (insert mode)
-- ?            Show mappings for picker actions (normal mode)
-- <C-c>        Close telescope (insert mode)
-- <Esc>        Close telescope (in normal mode)
-- <Tab>        Toggle selection and move to next selection
-- <S-Tab>      Toggle selection and move to prev selection
-- <C-q>        Send all items not filtered to quickfixlist (qflist)
-- <M-q>        Send all selected items to qflist
-- <C-r><C-w>   Insert cword in original window into prompt (insert mode)
-- <C-r><C-a>   Insert cWORD in original window into prompt (insert mode)
-- <C-r><C-f>   Insert cfile in original window into prompt (insert mode)
-- <C-r><C-l>   Insert cline in original window into prompt (insert mode)

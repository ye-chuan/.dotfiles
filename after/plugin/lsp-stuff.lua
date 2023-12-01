---- Must be setup in the order: Mason -> LSP-Config (because Mason temporarily adds to the PATH for LSP-Config?)

-- Packages / LSPs are installed in /nvim-data/mason
require("mason").setup({
    -- See :h mason-settings
    ui = {
        ---@since 1.0.0
        -- Whether to automatically check for new versions when opening the :Mason window.
        check_outdated_packages_on_open = true,

        ---@since 1.0.0
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "none",

        icons = {
            package_installed = "󰪥", -- "✓",
            package_pending = "󱑥", -- "➜",
            package_uninstalled = "" -- "✗"
        }
    }
})



----- Setup / Configure Each LSP Server
-- see :h lspconfig-all for recommended configs
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
    -- So for clangd to work with mingw gcc in Windows, a few things need to be done
    cmd = {"clangd", "--query-driver=C:/_Software/msys64/mingw64/bin/gcc.exe"}, -- First is to run clangd with the flag `--query-driver {path-to-gcc}` to **allow it** to query the gcc compiler for standard includes and stuff
    -- Very important to note that we are merely allowing clangd to query, but it will not query unless it know it has to, which is where step 2 comes in: we need to let clangd know how to compile how source,
    -- in other words what is the compilation command used to compile (and consequently what is the compiler used to compile, if we specify that we are compiling with gcc, and if we gave it permission to query it (earlier),
    -- then it will query gcc (this will solve the issues like "<stdio.h> not found".
    -- Options are:
    -- - Include a "compile_commands.json" with instructions on how to compile, an example is:
    --      ```
    --      [{"directory": "C:/Users/sengy/testproject",
    --        "arguments": ["gcc", "-o", "file.o", "test.c"],
    --             "file": "test.c" }]
    --      ```
    --   Note that the the the arguments[0] here needs to match with the compiler at the path given in --query-driver
    --   Instead of "arguments" we can also specify `"command": "gcc -o file.o test.c"`
    --
    -- - Or configure clangd to modify how a source file is compiled at a user level so we don't have to create a `compile_commands.json` for every little project
    --   User-Level Config is stored as a `config.yaml` in `%LocalAppData%/clangd/`, an example is:
    --      ```
    --      CompileFlags:                     # Tweak the parse settings
    --        Add: [-Wall]                    # Enable more warnings
    --        Remove: -W*                     # strip all other warning-related flags
    --        Compiler: gcc                   # Change argv[0] of compile flags to `gcc`
    --      ```
}
lspconfig.jdtls.setup{
    root_dir = function(filename)
        return vim.fs.dirname(vim.fs.find({".projectroot", ".git"}, {upward = true})[1])
    end,
    }
lspconfig.pyright.setup{}

----- COSMETICS -----
local signs = { Error = " ", Warn = " ", Hint = "󰌶 ", Info = " " }
for name, sign in pairs(signs) do
    local hlname = "DiagnosticSign" .. name     -- Concat to get the actual highlight group name
    vim.fn.sign_define(hlname, {text = sign, texthl = hlname, numhl = hlname})    -- See :h sign-define
end

----- KEY MAPPINGS -----
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)     -- Goto prev error
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)     -- Goto next error
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to map the following keys ONLY
-- AFTER The language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {      -- Attach this autocmd to the built-in event "LspAttach" (see :he LspAttach)
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),     -- Creates a new group for these autocmds called "UserLspConfig
  callback = function(ev)   -- ev is the event, which has an attribute .buf that is the current buffer number
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'  -- vim.bo[ev.buf] indexes and returns current buffer, then override/set it's omnifunc (see :he omnifunc) with the one in our lsp

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }    -- Store current buffer no. (ie. 0) so mappings are only set for this buffer
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<Leader>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', '<Leader>f', function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})

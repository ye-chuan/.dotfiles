---- Must be setup in the order: Mason -> Mason-LSPConfig -> LSP-Config (because Mason temporarily adds the LSP locations to the PATH for LSP-Config?)

-- Packages / LSPs are installed to ~/.local/share/nvim/mason (Windows: %LOCALAPPDATA%/nvim-data/mason)
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

mason_registry = require("mason-registry")  -- For querying installed packages' location e.g. mason_registry.get_package('vue-language-server'):get_install_path()

-- Mason-LSPConfig is an optional bridge between the 2, currently mainly using it to ensure_installed
-- Note that it uses LSPConfig server names instead of the package names in Mason (see `:h mason-lspconfig-server-map`)
require("mason-lspconfig").setup({
    -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
    -- This setting has no relation with the `automatic_installation` setting.
    ---@type string[]
    ensure_installed = {
        "clangd",
        "pyright",
        "jdtls",

        "html",
        "cssls",
        "ts_ls",
        "volar",    -- Vue.js

        -- "hls",      -- Haskell (requires ghcup)
    },

    -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
    -- This setting has no relation with the `ensure_installed` setting.
    -- Can either be:
    --   - false: Servers are not automatically installed.
    --   - true: All servers set up via lspconfig are automatically installed.
    --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
    --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
    ---@type boolean
    automatic_installation = false,
})

----- Setup / Configure Each LSP Server
local nvim_cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()    -- Remember to broacast the extended capabilites that nvim-cmp provided to NeoVim to all the LSP Servers (these includes snippet support, auto-imports etc.)

-- see :h lspconfig-all for recommended configs
local lspconfig = require("lspconfig")
local clangd_setup_table = {
    capabilities = nvim_cmp_capabilities,
}
if vim.fn.has("win32") then
    -- So for clangd to work with mingw gcc in Windows, a few things need to be done
    clangd_setup_table["cmd"] = {"clangd", "--query-driver=C:/_Software/msys64/mingw64/bin/gcc.exe"}    -- First is to run clangd with the flag `--query-driver {path-to-gcc}` to **allow it** to query the gcc compiler for standard includes and stuff
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
end
lspconfig.clangd.setup(clangd_setup_table)

lspconfig.pyright.setup({
    capabilities = nvim_cmp_capabilities,
})

lspconfig.jdtls.setup({
    capabilities = nvim_cmp_capabilities,
    root_dir = function(filename)
        return vim.fs.dirname(vim.fs.find({".projectroot", ".git"}, {upward = true})[1])
    end,
})

-- Web Dev
lspconfig.html.setup({
    capabilities = nvim_cmp_capabilities,
})

lspconfig.cssls.setup({
    capabilities = nvim_cmp_capabilities,   -- Requires snippet support capabilities else a little useless
})

volar_path = mason_registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"
lspconfig.tsserver.setup({
    capabilities = nvim_cmp_capabilities,
    init_options = {
        plugins = {
            {
                -- Vue Support
                name = "@vue/typescript-plugin",
                location = volar_path,  -- tsserver will run `require("@vue/typescript-plugin")` in this location
                languages = { "vue" },
            },
        },
    },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

lspconfig.volar.setup({
    -- Volar by itself only manages HTML & CSS sections now, for Vue support of JS we need a "@vue/typescript-plugin" plugin for tsserver.
    -- Volar's location will contain a "@vue/typescript-plugin" that has to be imported/used by tsserver (see config for tsserver above)
    capabilities = nvim_cmp_capabilities,
})

-- Others
lspconfig.hls.setup{
    capabilities = nvim_cmp_capabilities,
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
    -- Default Root Pattern: "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml"
    -- More defaults listed in :h lspconfig-all
}


----- KEY MAPPINGS -----
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)     -- Goto prev error
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)     -- Goto next error
vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to map the following keys ONLY
-- AFTER The language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {      -- Attach this autocmd to the built-in event "LspAttach" (see :he LspAttach)
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),     -- Creates a new group for these autocmds called "UserLspConfig
  callback = function(ev)   -- ev is the event, which has an attribute .buf that is the current buffer number
    -- Enable completion triggered by <C-X><C-O> (currently disabled for auto-completion plugin instead)
    -- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"  -- vim.bo[ev.buf] indexes and returns current buffer, then override/set it's omnifunc (see :he omnifunc) with the one in our lsp

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }    -- Store current buffer no. (ie. 0) so mappings are only set for this buffer
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, opts)
    -- vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set("n", "<Leader>wl", function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    -- vim.keymap.set("n", "<Leader>f", function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})

----- Override LSP Handlers -----
-- LSP Handlers are functions that are called when certain LSP event is triggered (e.g. pressing SHIFT-K for hover will call vim.lsp.handlers["textDocument/hover"] (see `:h lsp-method`) which is by default mapped to vim.lsp.handler.hover())
-- Configuring handlers is explained in `:h lsp-handler-configuration`

-- Add borders around LSP popups
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
        border = "rounded", -- Values taken from `:h nvim_open_win()` as mentioned in `:h vim.lsp.handlers.hover()`
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
        border = "rounded",
    }
)

----- Diagnostics Configurations -----
-- Change how the diagnostic signs look in the gutter
local signs = { Error = " ", Warn = " ", Hint = "󰌶 ", Info = " " }
for name, sign in pairs(signs) do
    local hlname = "DiagnosticSign" .. name     -- Concat to get the actual highlight group name
    vim.fn.sign_define(hlname, {text = sign, texthl = hlname, numhl = hlname})    -- See :h sign-define
end

-- See :h vim.diagnostic.config(); Options are given in :h vim.diagnostic.Opts
vim.diagnostic.config({
    float = { border = "rounded" },                             -- Add borders to diagnostic popups
    virtual_text = {
        severity = { min = vim.diagnostic.severity.WARN }      -- Only show inline diagnostics for WARNs and above
    },
    underline = {
        severity = { min = vim.diagnostic.severity.WARN }      -- Only underline only for WARNs and above
    },
    signs = true,
    update_in_insert = false,                                   -- Do not show diagnostics while typings
})


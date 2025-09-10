-- Packages / LSPs are installed to ~/.local/share/nvim/mason (Windows: %LOCALAPPDATA%/nvim-data/mason)
require("mason").setup({
    -- See :h mason-settings
    ui = {
        ---@since 1.0.0
        -- Whether to automatically check for new versions when opening the :Mason window.
        check_outdated_packages_on_open = true,

        ---@since 1.0.0
        -- The border to use for the UI window. Accepts same format as `:h nvim_open_win` or simply values from `:h winborder`.
        border = "double",

        icons = {
            package_installed = "󰪥", -- "✓",
            package_pending = "󱑥", -- "➜",
            package_uninstalled = "" -- "✗"
        }
    }
})
-- To access the locations of the LSP installed, consider reading https://github.com/mason-org/mason.nvim/releases/tag/v2.0.0

-- Mason-LSPConfig is an optional bridge between the 2, currently mainly using it to ensure_installed
-- Note that it uses LSPConfig server names instead of the package names in Mason (see `:h mason-lspconfig-server-map`)
require("mason-lspconfig").setup({
    -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
    -- This setting has no relation with the `automatic_installation` setting.
    ---@type string[]
    ensure_installed = {
        "clangd",
        "pyright",
        --"jdtls",  -- Java (requires jdk)

        "html",
        "cssls",
        "ts_ls",

        "jsonls",
        --"hls",    -- Haskell (requires ghcup)

        --"texlab", -- Latex
    },

    -- Whether servers that are set up (via vim.lsp.enable()) should be
    -- automatically installed if they're not already installed.
    -- This setting has no relation with the `ensure_installed` setting.
    -- Can either be:
    --   - false: Servers are not automatically installed.
    --   - true: All servers set up via lspconfig are automatically installed.
    --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
    --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
    ---@type boolean
    automatic_installation = false,
   -- Whether to automatically enable all LSPs installed via Mason.
   -- I prefer to manually run `vim.lsp.enable()`; furthermore, I anticipate a migration
   -- from this plugin altogether as it is currently only good for its `ensure_installed`
    automatic_enable = false,
})

----- Setup / Configure Each LSP Server -----
-- Native configuration of LSP has been supported since NeoVim 0.11,
-- Configs will be stored anywhere in NeoVim's runtime path as
-- `lsp/{lsp-config-name}.lua`, which is then read by NeoVim's LSP engine
-- with `vim.lsp.enable("{lsp-config-name}")`
--
-- Any configs defined here with `vim.lsp.config("{lsp-config-name}" = {...})`
-- will be merged with the other configs (including those from the
-- `nvim-lspconfig plugin) as per `:h lsp-config-merge`
-- (Uses a "deep table merge"; note plain lists are simply overridden)
--
-- We will be using mostly sane default configs provided by the `nvim-lspconfig`
-- plugin, which has `lsp/{lsp-name}.lua` configs for many major LSPs
-- Note: There is no need to `require("lspconfig")`, the plugin is now
-- a data-only plugin and does not run any code
--
-- see :h lspconfig-all for recommended configs to include here when using
-- the `nvim-lspconfig` plugin

-- Broacast the extended capabilites that nvim-cmp provided to NeoVim to all
-- the LSP Servers (these includes snippet support, auto-imports etc.)
local nvim_cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
    capabilites = nvim_cmp_capabilities,
})

vim.lsp.enable("pyright")

local clangd_config_extend = {}
if vim.fn.has("win32") == 1 then
    -- So for clangd to work with mingw gcc in Windows, a few things need to be done
    vim.lsp.config("clangd", {
        cmd = {"clangd", "--query-driver=C:/_Software/msys64/mingw64/bin/gcc.exe"}
    })    -- First is to run clangd with the flag `--query-driver {path-to-gcc}` to **allow it** to query the gcc compiler for standard includes and stuff
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
vim.lsp.config("clangd", clangd_config_extend)
vim.lsp.enable("clangd")

local existing_conf = vim.lsp.config["jdtls"] or {}
local root_markers_extended = vim.deepcopy(existing_conf["root_markers"] or {})
vim.list_extend(root_markers_extended, {".projectroot"})
vim.lsp.config("jdtls", {
    root_markers = root_markers_extended,
})
vim.lsp.enable("jdtls")

---- Web Dev
vim.lsp.enable("html")

vim.lsp.enable("cssls")

vim.lsp.enable("ts_ls")

---- Markup
vim.lsp.enable("jsonls")

---- Others
vim.lsp.config("hls", {
    filetypes = { "haskell", "lhaskell", "cabal" },
    -- Default Root Pattern: "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml"
    -- More defaults listed in :h lspconfig-all
})
vim.lsp.enable("hls")

--vim.lsp.config("texlab", {
--    settings = {
--        texlab = {
--            build = {
--                onSave = true,    -- Conflict with VimTeX plugin if true
--                forwardSearchAfter = true,
--            },
--            -- Forward search command to be sent to Zathura via SyncTex
--            -- We should also configure inverse search in Zathura's config.
--            -- These recommended configs are provided in:
--            -- https://github.com/latex-lsp/texlab/wiki/Previewing#zathura
--            forwardSearch = {                -- Zathura forward search
--                executable = "zathura",
--                args = { "--synctex-forward", "%l:1:%f", "%p" },
--            },
--        }
--    }
--})
-- If using VimTeX plugin, not much configuration is needed
vim.lsp.enable("texlab")


----- KEY MAPPINGS -----
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)     -- Goto prev error
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)     -- Goto next error
vim.keymap.set("n", "<Leader>d", vim.diagnostic.setloclist) -- Tip: :lcl to close location list

---- Default Mappings (see :h lsp-defaults)
--- Global
-- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
-- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
-- "grr" is mapped in Normal mode to vim.lsp.buf.references()
-- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
-- "grt" is mapped in Normal mode to vim.lsp.buf.type_definition()
-- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
-- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()
-- "an" and "in" are mapped in Visual mode to outer and inner incremental selections, respectively, using vim.lsp.buf.selection_range() 

--- Buffer Local
-- "K" is mapped in Normal Mode to vim.lsp.buf.hover()
-- Since `formatexpr` is seet to vim.lsp.formatexpr():
--      "gq" formats via the LSP
-- Since the `omnifunc` is set to vim.lsp.omnifunc():
--      "CTRL-X CTRL-X" in Insert Mode invokes LSP Autocomplete
-- Since the `tagfunc` is set to vim.lsp.tagfunc():
--      "CTRL-]" goes to definition
--      "CTRL-W ]" goes to definition in in new window
--      "CTRL-W }" shows definition in "preview window" (CTRL-W z to close; see :h preview-window)
----

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

    -- The following are not really used, the built-in `tagfunc` override described above should be used instead
    -- I'm just keeping these here for more finegrain
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)    -- Overrides the default naive "glocal variable declaration" search
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)     -- Overrides the default naive "local variable declaration" search

    --vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    --vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    --vim.keymap.set("n", "<Leader>wl", function()
    --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, opts)
    --vim.keymap.set("n", "<Leader>f", function()
    --  vim.lsp.buf.format { async = true }
    --end, opts)
  end,
})

-- See :h vim.diagnostic.config(); Options are given in :h vim.diagnostic.Opts
vim.diagnostic.config({
    virtual_text = {
        severity = { min = vim.diagnostic.severity.WARN }      -- Only show inline diagnostics for WARNs and above
    },
    underline = {
        severity = { min = vim.diagnostic.severity.WARN }      -- Only underline only for WARNs and above
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
        },
        -- The colour of the line of code (colour according to highlight groups, see `:highlight`)
        linehl = {
            --[vim.diagnostic.severity.ERROR] = "ErrorMsg",
        },
        -- The colour of the line number
        numhl = {
            --[vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
    update_in_insert = false,   -- Do not show diagnostics while typings
    severity_sort = true,       -- Priority of sign is sorted according to the severity of the diagnostic
})


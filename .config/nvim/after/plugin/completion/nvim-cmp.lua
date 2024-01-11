local cmp = require("cmp")

local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<C-B>"] = cmp.mapping.scroll_docs(-4),
        ["<C-F>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-Y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

        -- Map <C-N> and <C-P> to select items from nvim-cmp only when the menu is active (else it will act as per normal in Vim)
        ["<C-N>"] = function(fallback)    -- `fallback` refers to the original function of this mapping
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ["<C-P>"] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
    }, {                    -- The order of the sources {{A, B}, {C}} means source C will only show when there is nothing from A or B
        { name = "buffer", keyword_length = 3 },  -- keyword_length determines the text length before auto-complete kicks in
    }),
    formatting = {
        format = function(entry, vim_item)  -- A `vim_item` will be given to us to modify and return, `entry` stored information of the completion
            -- Kind Icons
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)    -- Concatenate the item's kind with it's icon
            -- Source Label (highlight group is CmpItemMenu)
            vim_item.menu = ({              -- Set the menu label of the vim_item
            buffer = "[buf]",
            nvim_lsp = "[lsp]",
            luasnip = "[snip]",
        })[entry.source.name]   -- Pick label from the name of the entry's source
        return vim_item
    end,
        }
    })

-- vim.keymap.set("i", "<C-X><C-O>", cmp.mapping.complete)
-- 
-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--     sources = cmp.config.sources({
--         { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
--     }, {
--         { name = 'buffer' },
--     })
-- })
-- 
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = 'buffer' }
--     }
-- })
-- 
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = 'path' }
--     }, {
--         { name = 'cmdline' }
--     })
-- })
-- 
-- Set up lspconfig.
-- Done in lsp-stuff.lua
-- Below is for reference only
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--     capabilities = capabilities
-- }

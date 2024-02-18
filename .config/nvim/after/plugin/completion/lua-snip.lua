local ls = require('luasnip')

ls.setup({
    update_events = {"TextChanged", "TextChangedI"}, -- Updates dependent fields while typing
    -- enable_autosnippets = true
})

require("luasnip.loaders.from_vscode").lazy_load({paths = {
    vim.fn.stdpath("config") .. "/snippets/friendly-snippets",
    vim.fn.stdpath("config") .. "/snippets/my-snippets"
}})

-- Keymaps
-- vim.keymap.set({"i", "s"}, "<C-Y>", function()  -- Expand Snippet
--     if ls.expandable() then
--         ls.expand()
--     end
-- end

vim.keymap.set({"i", "s"}, "<C-J>", function()  -- Move to next field
    if ls.jumpable(1) then
        ls.jump(1)
    end
end)

vim.keymap.set({"i", "s"}, "<C-K>", function()  -- Move back to previous field
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end)

vim.keymap.set("i", "<C-L>", function() -- Cycle through the choices for a field
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

vim.keymap.set("n", "<leader><leader>s", "<cmd>source " .. vim.fn.expand("%:p") .. "<CR>")


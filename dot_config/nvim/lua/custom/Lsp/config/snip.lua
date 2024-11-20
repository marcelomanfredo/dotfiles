-- Set up luasnip
local ls = require "luasnip"

vim.snippet.expand = ls.lsp_expand

vim.snippet.activate = function(filter)
    filter = filter or {}
    filter.direction = filter.direction or 1

    if filter.direction == 1 then
        return ls.expand_or_jumpable()
    else
        return ls.jampable(filter.direction)
    end
end

vim.snippet.jump = function(direction)
    if direction == 1 then
        if ls.expandable() then
            return ls.expand_or_jump()
        else
            return ls.jumpable(1) and ls.jump(1)
        end
    else
        return ls.jumpable(-1) and ls.jump(-1)
    end
end

vim.snippet.stop = ls.unlink_current

-- ###################################################################################################################

ls.config.set_config {
    history = false,
    updateevents = "TextChanged,TextChangedI",
}

-- Get custom snippets from "snippets" folder
for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/Lsp/snippets/*.lua", true)) do
    loadfile(ft_path)()
end


-- Keymaps for navigating through snippets
vim.keymap.set({ "i", "s" }, "<C-k>", function()
    return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
end, { silent = true, desc = "Go to next field in snippet" })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
    return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
end, { silent = true, desc = "Go to prev field in snippet" })

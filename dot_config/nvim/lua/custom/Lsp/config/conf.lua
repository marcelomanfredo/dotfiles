-- This file is being called from nvim/lua/custom/plugins/completion_lsp.lua

require 'custom.Lsp.config.snip'

vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.shortmess:append "ac"

local cmp = require 'cmp'
local mappings = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping(
        cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        { "i", "c" }
    ),
    ["<C-Space>"] = cmp.mapping.complete(),
}

local lspkind = require "lspkind"
lspkind.init()

-- Nvim-cmp -> completion config
cmp.setup({
    sources = {
        { name = 'nvim_lsp', keyword_length = 1 },
        { name = 'luasnip',  keyword_length = 1 },
        { name = 'path',     keyword_length = 2 },
        { name = 'cmdline',  keyword_length = 3 },
        { name = 'buffer',   keyword_length = 5 },
    },

    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },

    mapping = mappings,

    formatting = {
        format = lspkind.cmp_format {
            mode = "symbol_text",
            with_text = true,
            menu = {
                nvim_lsp = "[LSP]",
                luasnip = "[snip]",
                path = "[path]",
                buffer = "[buf]",
            },
        },
    },

    completion = {
        autocomplete = {
            cmp.TriggerEvent.TextChanged,
            cmp.TriggerEvent.InsertEnter,
        },
    },
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' },
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Disable builtin SQL completion, allowing only dadbod
vim.g.loaded_sql_complete = 1
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    callback = function()
        -- Disable problematic keymaps from built-in sql ftplugin
        local keys = { "<C-C>v", "<C-C>c", "<C-C>s", "<C-C>f", "<C-C>L", "<C-C>k", "<C-C>o", "<C-C>T",
            "<C-C>l", "<C-C>R", "<C-C>p", "<C-C>a", "<C-C>t", "<C-C>v" }
        for _, key in ipairs(keys) do
            pcall(vim.api.nvim_buf_del_keymap, 0, 'i', key)
        end
    end
})
cmp.setup.filetype({ "sql" }, {
    sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
    },
})

-- Menu style
vim.api.nvim_set_hl(0, 'CmpItemMenu', { bg = 'NONE', fg = '#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemAbbr', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKind', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKindText', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg='NONE', fg='#808080' })
--vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { bg='NONE', fg='#808080' })

return {
    "hrsh7th/nvim-cmp",
    lazy = false,
    name = "cmp",
    dependencies = {
        "onsails/lspkind.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-buffer",
        {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
            config = function()
                local ls = require 'luasnip'
                vim.snippet.expand = ls.lsp_expand

                vim.snippet.activate = function(filter)
                    filter = filter or {}
                    filter.direction = filter.direction or 1

                    if filter.direction == 1 then
                        return ls.expand_or_jumpable()
                    else
                        return ls.jumpable(filter.direction)
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

                ls.config.set_config({
                    history = true,
                    updateevents = "TextChanged,TextChangedI",
                })

                -- Get custom snippets
                -- [[
                -- for _, f_path in ipairs(vim.api.nvim_get_runtime_file('lua/plugins/lsp/snippets/*.lua', true)) do
                    -- loadfile(f_path)()
                -- end

                -- KEYMAPS
                vim.keymap.set({ 'i', 's' }, '<C-k>', function()
                    return vim.snippet.active({ direction = 1} and vim.snippet.jump(1))
                end, { silent = true, desc = "Go to next field in snippet" })

                vim.keymap.set({ 'i', 's' }, '<C-j>', function()
                    return vim.snippet.active({ direction = -1} and vim.snippet.jump(-1))
                end, { silent = true, desc = "Go to prev field in snippet" })
            end,
        },
        "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
        local cmp = require 'cmp'
        local lspkind = require 'lspkind'

        lspkind.init()
        return {
            sources = {
                { name = "nvim_lsp", keyword_length = 1 },
                { name = "luasnip",  keyword_length = 1 },
                { name = "path",     keyword_length = 2 },
                { name = "buffer",   keyword_length = 5 },
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-y>"] = cmp.mapping(
                    cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true, }),
                    { 'i', 'c' } ),
                ["<C-Space>"] = cmp.mapping.complete(),
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    with_text = true,
                    menu = {
                        nvim_lsp = "[LSP]",
                        luasnip  = "[SNP]",
                        path     = "[PAT]",
                        buffer   = "[BUF]",
                    },
                }),
            },
            completion = {
                autocomplete = {
                    cmp.TriggerEvent.TextChanged,
                    cmp.TriggerEvent.InsertEnter,
                },
            },
            window = {
                completion = {
                    border = 'rounded',
                    winhighlight = 'Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None',
                },
                documentation = {
                    border = 'rounded',
                },
            },
        }
    end,
    config = function(_, opts)
        vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
        vim.opt.shortmess:append "ac"

        local cmp = require 'cmp'
        cmp.setup(opts)

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' },
            },
        })

        cmp.setup.cmdline(':', {
            --mapping = cmp.mapping.preset.cmdLine(),
            sources = cmp.config.sources({
                { name = 'path' },
                { name = 'buffer' },
            }),
            matching = { disallow_symbol_nonprefix_matching = false },
        })

        -- SQL
        -- [[
        -- vim.g.loaded_sql_complete = 1
        -- vim.api.nvim_create_autocmd('FileType', {
            -- group = vim.api.nvim_create_augroup('CmpSQL', { clear = true }),
            -- pattern = "sql",
            -- callback = function()
                -- Disable these problematic keymaps from builtin
                -- local keys = { "<C-C>v", "<C-C>c", "<C-C>s", "<C-C>f", "<C-C>L", "<C-C>k", "<C-C>o", "<C-C>T", "<C-C>l", "<C-C>R", "<C-C>p", "<C-C>a", "<C-C>t", "<C-C>v" }
                -- for _, key in ipairs(keys) do
                    -- pcall(vim.api.nvim_buf_del_keymap, 0, 'i', key)
                -- end
            -- end
        -- })
        -- cmp.setup.filetype({ 'sql' } , {
            -- sources = {
                -- { name = "vim-dadbod-completion" },
                -- { name = "buffer" },
            -- },
        -- })
        -- ]]

        vim.api.nvim_set_hl(0, "CmpItemMenu", { bg = 'NONE', fg = '#808080' })
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
    end,
}


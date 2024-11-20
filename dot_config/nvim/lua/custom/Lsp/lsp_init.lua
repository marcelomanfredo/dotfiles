local lsp = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, bufnr)
    local function buf_set_option(option, value)
        vim.api.nvim_set_option_value(option, value, { buf = bufnr })
    end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    if client.server_capabilities.document_highlight then
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
                vim.diagnostic.setloclist({ open = false }) -- Update location list
            end
        })
    end

    --Mappings for lsp
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = "LSP: Go to Declaration" }))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = "LSP: Go to Definition" }))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover,
        vim.tbl_extend('force', opts, { desc = "LSP: display hove information about the symbol under the cursor" }))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
        vim.tbl_extend('force', opts, { desc = "LSP: Go to Implementation" }))
    vim.keymap.set('n', '<C-S-K>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<leader><leader>f', vim.cmd.LspFormat,
        vim.tbl_extend('force', opts, { desc = "Format if LSP supports it" }))
end

-- Auto format if LSP supports it
vim.api.nvim_create_user_command('LspFormat', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local should_format = false

    for _, client in ipairs(clients) do
        if client.server_capabilities.documentFormattingProvider then
            should_format = true
            break
        end
    end

    if should_format then
        vim.lsp.buf.format({ bufnr = bufnr })
    end
end, { force = true, desc = "Save and auto-format if LSP supports it" })

-- Auto-Format before save
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        vim.cmd.LspFormat()
    end
})


-- Lua
lsp.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        })
    end,
    settings = {
        Lua = {}
    }
}


-- Rust
lsp.rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        ["rust_analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
            },
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true,
            },
        },
    },
}


-- Go
lsp.gopls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

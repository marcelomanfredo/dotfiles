local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        "cmp",
        "mason",
        {
            "mason-org/mason-lspconfig.nvim",
            opts = {
                --automatic_enable = false
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "gopls",
                    "clangd",
                },
            },
        },
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local servers = {
            "clangd",
            "gopls",
            "lua_ls",
            "rust_analyzer",
        }
        for _, server in ipairs(servers) do
            vim.lsp.config(server, {
                capabilities = capabilities,
            })
        end

        -- Specific configs
        vim.lsp.config('lua_ls', {
            cmd = { 'lua-language-server' },
            filetypes = { 'lua' },
            root_markers = {
                ".luarc.json",
                ".luarc.jsonc",
                ".luacheckrc",
                ".stylua.toml",
                ".git",
            },
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                        },
                    },
                },
            },
        })
    end,
}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('LspConfig', { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/implementation') then
            -- Keymaps
            local opts = { buffer = args.buf, noremap = true, silent = true }

            vim.keymap.set('n', '<leader>A', vim.lsp.buf.code_action,
                vim.tbl_extend('force', opts,
                    { desc = [[LSP -> Selects a code action (LSP: "textDocument/codeAction")]] }))

            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                vim.tbl_extend('force', opts, { desc = "LSP -> Jumps to the declaration of the symbol under the cursor" }))

            vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
                vim.tbl_extend('force', opts, { desc = "LSP -> Jumps to the definition of the symbol under the cursor" }))

            vim.keymap.set('n', 'K', function()
                    vim.lsp.buf.hover({ border = 'rounded' })
            end, vim.tbl_extend('force', opts,
                    { desc = "LSP -> Display hover information about the symbol under the cursor" }))

            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
                vim.tbl_extend('force', opts,
                    { desc = "LSP -> Lists all the implementations for the symbol under the cursor in the quickfix menu" })) -- maybe open in telescope?

            vim.keymap.set({ 'i', 'n' }, '<C-p>', function()
                vim.lsp.buf.signature_help({
                    border = 'rounded',
                    focusable = false,
                })
            end,
                vim.tbl_extend('force', opts,
                    { desc = "LSP -> Displays signature information about the symbol under the cursor" }))

            vim.keymap.set('n', '<leader>wl', vim.lsp.buf.list_workspace_folders,
                vim.tbl_extend('force', opts, { desc = "LSP -> Lists workspace folders" }))

            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
                vim.tbl_extend('force', opts, { desc = "LSP -> Add the folder at path to the workspace folders" }))

            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
                vim.tbl_extend('force', opts, { desc = "LSP -> Remove the folder at path from the workspace folders" }))

            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                vim.tbl_extend('force', opts, { desc = "LSP -> Jumps to the declaration of the symbol under the cursor" }))

            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                vim.tbl_extend('force', opts, { desc = "LSP -> Jumps to the declaration of the symbol under the cursor" }))

            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition,
                vim.tbl_extend('force', opts,
                    { desc = "LSP -> Jumps to the definition of the type of the symbol under the cursor" }))

            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
                vim.tbl_extend('force', opts, { desc = "LSP -> Renames all references to the symbol under the cursor" }))

            vim.keymap.set('n', 'gr', vim.lsp.buf.references,
                vim.tbl_extend('force', opts, { desc = "LSP -> Lists all the references to the symbol under the cursor" }))

            vim.keymap.set('n', '<leader>K', vim.diagnostic.open_float,
                vim.tbl_extend('force', opts, { desc = "LSP -> Show diagnostics in a floating window" }))

            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
                vim.tbl_extend('force', opts, { desc = "LSP -> Add buffer diagnostics to the location list" }))

            vim.keymap.set('n', '<leader>dh', function()
                local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
                vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = args.buf })
            end, vim.tbl_extend('force', opts, { desc = "LSP -> Toggles inlay hints" }))
        end

        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end

        vim.diagnostic.config({
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            virtual_text = true,
            --virtual_lines = true,
            float = {
                source = true,
                border = 'rounded',
            },
        })
    end,
})

return M

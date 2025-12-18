local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        "cmp",
        "mason",
        {
            "mason-org/mason-lspconfig.nvim",
            opts = {
                automatic_enable = {
                    exclude = {
                        "stylua",
                    },
                },
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
            "lua_ls",
            "rust_analyzer",
            "gopls",
            "clangd",
            "bashls",
            "basedpyright",
            "emmet_language_server",
            "taplo",
        }
        for _, server in ipairs(servers) do
            vim.lsp.config(server, {
                capabilities = capabilities,
            })
        end

        -- [[ Specific configs ]]
        -- Lua
        vim.lsp.config("lua_ls", {
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
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
                        version = "LuaJIT",
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                        },
                    },
                },
            },
        })

        -- Rust: being managed by 'mrcjkb/rustaceanvim'
        require("plugins/lsp/rust")
    end,
}

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspConfig", { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method("textDocument/implementation") then
            -- Keymaps
            require("plugins/lsp/lsp-keymaps").keys(args)
        end

        -- inlay_hints can be toggled with '<leader>dh'
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end

        -- Autoformat on save
        if client.name == "null_ls" and client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormatting", { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = args.buf,
                        filter = function(client)
                            if client.name == "null-ls" then
                                return true
                            end

                            local clients = vim.lsp.get_clients({ bufnr = args.buf })
                            local is_none_attached = false
                            for _, c in ipairs(clients) do
                                if c.name == "null-ls" and c:supports_method("textDocument/formatting") then
                                    is_none_attached = true
                                    break
                                end
                            end
                            if not is_none_attached then
                                return client:supports_method("textDocument/formatting")
                            end
                            return false -- fallback in case neither none-ls nor lsp has formatting capabilities
                        end,
                    })
                end,
            })
        end

        vim.diagnostic.config({
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            virtual_text = true,
            --virtual_lines = true,
            float = {
                source = true,
                border = "rounded",
            },
        })
    end,
})

return M

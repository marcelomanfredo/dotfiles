vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspConfig", { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method("textDocument/implementation") then
            -- Keymaps
            require("plugins.lsp.utils.keymaps-lsp").keys(args)
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

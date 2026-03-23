vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspConfig", { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method("textDocument/implementation") then
            -- Keymaps
            require("plugins.lsp.utils.keymaps").keys(args)
        end

        if client.name == "rust-analyzer" then
            local opts = { buffer = args.buf, noremap = true, silent = true }

            -- Overwrite keymaps and rustaceanvim specifics
            vim.keymap.set("n", "K", function()
                vim.cmd.RustLsp("hover", "actions")
            end, vim.tbl_extend("force", opts, { desc = "Lsp[Rust] -> Hover actions" }))
            vim.keymap.set("n", "<leader>A", function()
                vim.cmd.RustLsp("codeAction")
            end, vim.tbl_extend("force", opts, { desc = "Lsp[Rust] -> Code actions" }))
            vim.keymap.set("n", "<leader>e", function()
                vim.cmd.RustLsp("explainError", "cycle")
            end, vim.tbl_extend("force", opts, { desc = "Lsp[Rust] -> Explain error" }))
            vim.keymap.set("n", "<leader>E", function()
                vim.cmd.RustLsp("renderDiagnostic", "cycle")
            end, vim.tbl_extend(
                "force",
                opts,
                { desc = "Lsp[Rust] -> Render diagnostic (like `cargo build`)" }
            ))
            vim.keymap.set("n", "sd", function()
                local query = vim.fn.input("# ")
                vim.cmd.RustLsp("workspaceSymbol", "allSymbols", query)
            end, vim.tbl_extend("force", opts, { desc = "Lsp[Rust] -> Search symbol under the cursor" }))

            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
                callback = function()
                    vim.cmd.RustFmt()
                end,
            })
        end

        -- DAP Keymaps
        local dap = require("dap")
        vim.keymap.set("n", "<F1>", dap.step_into, { desc = "DAP -> Step into", silent = true, noremap = true })
        vim.keymap.set("n", "<F2>", dap.step_over, { desc = "DAP -> Step over", silent = true, noremap = true })
        vim.keymap.set("n", "<F3>", dap.step_out, { desc = "DAP -> Step out", silent = true, noremap = true })
        vim.keymap.set("n", "<F4>", dap.step_back, { desc = "DAP -> Step back", silent = true, noremap = true })
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP -> Continue", silent = true, noremap = true })
        vim.keymap.set(
            "n",
            "<leader>b",
            dap.toggle_breakpoint,
            { desc = "DAP -> Toggle breakpoint", silent = true, noremap = true }
        )
        vim.keymap.set(
            "n",
            "<leader>B",
            "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
            { desc = "DAP -> Toggle conditional breakpoint", silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>c", dap.run_to_cursor, { desc = "Dap -> Run until cursor" })
        vim.keymap.set("n", "<leader>?", function()
            require("dapui").eval(nil, { enter = true })
        end, { desc = "DAP -> Eval var under cursor" })

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

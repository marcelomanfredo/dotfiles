return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = function()
        local nls = require("null-ls")
        return {
            on_attach = function(client, bufnr)
                -- Autoformat on save
                if client.name == "null_ls" and client:supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                filter = function(cli)
                                    return cli.name == "null-ls"
                                end,
                            })
                        end,
                    })
                end
            end,
            sources = {
                nls.builtins.formatting.stylua,
            },
        }
    end,
}

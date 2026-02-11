vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("RustDebugger", { clear = true }),
    pattern = "rust",
    callback = function()
        vim.keymap.set("n", "<leader><F5>", function()
            vim.cmd.RustLsp("debug")
        end, { desc = "DAP -> Start rust debugger" })
        vim.keymap.set("n", "<leader><F6>", function()
            vim.cmd.RustLsp("debuggables")
        end, { desc = "DAP -> Prompts to select what to debug" })
    end,
})

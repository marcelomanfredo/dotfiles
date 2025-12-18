return {
    "mbbill/undotree",
    name = "undotree",
    config = function()
        if vim.fn.has("persistent_undo") == 1 then
            local target = vim.fn.expand("~/.undodir/")
            if vim.fn.isdirectory(target) == 0 then
                vim.fn.mkdir(target, p, 0700)
            end

            vim.opt.undodir = target
            vim.opt.undofile = true
        end

        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree UI" })
    end,
}

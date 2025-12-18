return {
    "tpope/vim-fugitive",
    lazy = false,
    config = function()
        -- Global keymap
        vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = "Fugitive -> git status" })

        local group = vim.api.nvim_create_augroup('Git', { clear = true })
        vim.api.nvim_create_autocmd('FileType', {
            group = group,
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                vim.keymap.set('n', '<leader>p', function()
                    vim.cmd.Git('push')
                end, { buffer = bufnr, remap = false, desc = 'Fugitive -> git push' })

                vim.keymap.set('n', '<leader>P', function()
                    vim.cmd.Git({ 'push', '--rebase' })
                end, { buffer = bufnr, remap = false, desc = 'Fugitive -> git push --rebase' })

                -- Manually set branch
                vim.keymap.set('n', '<leader>b', '<cmd>Git push -u origin ', { buffer = bufnr, remap = false, desc = 'Fugitive -> git push -u origin <branch>' })

                -- Select diff when merge conflicts
                vim.keymap.set('n', '<leader>F', '<cmd>diffget //2<CR>', { buffer = bufnr, remap = false, desc = 'Fugitive -> Select HEAD version on merge conflict' })
                vim.keymap.set('n', '<leader>J', '<cmd>diffget //3<CR>', { buffer = bufnr, remap = false, desc = 'Fugitive -> Select BRANCH version on merge conflict' })
            end,
        })
    end,
}

-- Quality of life
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex) -- Go to Project View (explorer)
vim.keymap.set('n', 'J', 'mzJ`z')             -- When appending lines with 'J', make cursor stay at the beggining of the line
vim.keymap.set('n', '<C-d>', '<C-d>zz')       -- Make cursor stay at the middle
vim.keymap.set('n', '<C-u>', '<C-u>zz')       -- Make cursor stay at the middle
vim.keymap.set('n', 'n', 'nzzzv')             -- Make cursor stay at the middle
vim.keymap.set('n', 'N', 'Nzzzv')             -- Make cursor stay at the middle
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = "Delete current selection to void and paste last copied text" })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = "Yank current line to system clipboard" })
vim.keymap.set({ "n", "v" }, '<leader>y', [["+y]],
    {
        desc =
        "In Normal mode, it will open the cmd \"+y and allow a motion for yanking, while in visual mode it just yanks the selection"
    })
vim.keymap.set({ "n", "v" }, '<leader>d', [["_d]], { desc = "Deletes current line or selected text into the void" })
vim.keymap.set('n', '<leader><leader>l', function() vim.opt.list = not vim.opt.list:get() end,
    { desc = "Toggle \"list\" on and off - nom printable characters" })


-- SQL dadbod
vim.keymap.set('n', '<leader>sq', '<cmd>DBUIToggle<cr>')
vim.keymap.set('n', '<leader>sf', '<cmd>DBUIFindBuffer<cr>')


-- Source current lua file to neovim config
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<cr>')


-- Fugitive git
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)


-- Undotree toggle
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)


-- Move lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")


-- Movement keybindings for splits
vim.keymap.set('n', '<C-j>', '<c-w>(j)')
vim.keymap.set('n', '<C-k>', '<c-w>(k)')
vim.keymap.set('n', '<C-l>', '<c-w>(l)')
vim.keymap.set('n', '<C-h>', '<c-w>(h)')
vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>')
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>')
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>')
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>')


-- Resize splits
vim.keymap.set('n', '<M-]>', '<cmd>resize -5<CR>')
vim.keymap.set('n', '<M-[>', '<cmd>resize +5<CR>')
vim.keymap.set('n', '<M-,>', '<cmd>vertical resize -5<CR>')
vim.keymap.set('n', '<M-.>', '<cmd>vertical resize +5<cr>')

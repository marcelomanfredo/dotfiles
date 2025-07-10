local harpoon = require("harpoon")

-- REQUIRED: this call is needed due to autocmds setup
harpoon:setup()

vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = "Harpoon: Add current buffer to list" })
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    { desc = "Harpoon: Toggle quick menu" })

vim.keymap.set('n', '<M-j>', function() harpoon:list():select(1) end,
    { desc = "Harpoon: Go to buffer 1", noremap = true, silent = true })
vim.keymap.set('n', '<M-k>', function() harpoon:list():select(2) end,
    { desc = "Harpoon: Go to buffer 2", noremap = true, silent = true })
vim.keymap.set('n', '<M-l>', function() harpoon:list():select(3) end,
    { desc = "Harpoon: Go to buffer 3", noremap = true, silent = true })
vim.keymap.set('n', '<M-ç>', function() harpoon:list():select(4) end,
    { desc = "Harpoon: Go to buffer 4", noremap = true, silent = true })

vim.keymap.set('n', '<C-p>', function() harpoon:list():prev() end, { desc = "Harpoon: Go to prev buffer" })
vim.keymap.set('n', '<C-n>', function() harpoon:list():next() end, { desc = "Harpoon: Go to next buffer" })

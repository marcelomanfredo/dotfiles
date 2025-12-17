-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable mouse
vim.opt.mouse = ""

-- Make you life easy!
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "Go to Project View (explorer)" })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = "Makes pointer stay at the current position when appending lines" })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = "Put cursor in the middle of the screen when jumping through the file" })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = "Put cursor in the middle of the screen when jumping through the file" })
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Let line stay in the middle of the screen" })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Let line stay in the middle of the screen" })
vim.keymap.set({'n', 'x'}, 'G', 'Gzz', { desc = "Put line in the middle of the screen when jumping to EOF" })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = "Replace selection without overwriting the default register" })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = "Yank current line to system clipboard" })
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]], { desc = "Yank: In normal mode, opens the cmd with \"+y, allowing motion. In visual mode, yanks the selection" })
vim.keymap.set({'n', 'v'}, '<leader>d', [["_d]], { desc = "Delete to void: In normal mode, opens the cmd with \"_d, allowing motion. In visual mode, deletes the selection" })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = "Exit terminal mode" })
vim.keymap.set('v', 'K', [[:m '<-2<CR>gv=gv]], { desc = "Move selected region up" })
vim.keymap.set('v', 'J', [[:m '>+1<CR>gv=gv]], { desc = "Move selected region down" })

vim.keymap.set('n', '<leader><leader>w', function()
    vim.opt_local.wrap = not vim.opt_local.wrap:get()
    vim.opt_local.linebreak = not vim.opt_local.linebreak:get()
end, { desc = "Toggle line wrap" })

vim.keymap.set('n', '<leader><leader>l', function()
    vim.opt_local.list = not vim.opt_local.list:get()
end, { desc = "Toggle the \"list\" option, which shows/hide non-printable characters" })

-- Stolen from the GOAT TJ /
vim.keymap.set('n', 'j', function()
    local count = vim.v.count
    if count == 0 then
        return "gj"
    else
        return "j"
    end
end, { expr = true, desc = "Navigate through wrapped lines easily" })
vim.keymap.set('n', 'k', function()
    local count = vim.v.count
    if count == 0 then
        return "gk"
    else
        return "k"
    end
end, { expr = true, desc = "Navigate through wrapped lines easily" })
-- /

-- Splits
vim.keymap.set('n', '<C-h>', '<C-w>(h)', { desc = "Easy navigation through splits" })
vim.keymap.set('n', '<C-j>', '<C-w>(j)', { desc = "Easy navigation through splits" })
vim.keymap.set('n', '<C-k>', '<C-w>(k)', { desc = "Easy navigation through splits" })
vim.keymap.set('n', '<C-l>', '<C-w>(l)', { desc = "Easy navigation through splits" })
vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { desc = "Easy navigation through tmux panels" })
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { desc = "Easy navigation through tmux panels" })
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { desc = "Easy navigation through tmux panels" })
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { desc = "Easy navigation through tmux panels" })
vim.keymap.set('n', '<M-[>', '<cmd>resize +5<CR>', { desc = "Increase current split height" })
vim.keymap.set('n', '<M-]>', '<cmd>resize -5<CR>', { desc = "Increase current split height" })
vim.keymap.set('n', '<M-.>', '<cmd>vertical resize +5<CR>', { desc = "Increase current split width" })
vim.keymap.set('n', '<M-,>', '<cmd>vertical resize -5<CR>', { desc = "Increase current split width" })

local telescope = require 'telescope'

telescope.setup({
    extensions = {
        wrap_results = true,
        fzf = {},
    },
    defaults = {
        prompt_prefix = " ",
        path_display = {
            shorten = 2,
            truncate = 3,
        },
        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
        only_sort_text = true,
        disable_coordinates = true,
    },
    pickers = {
        live_grep = {
            only_sort_text = true,
            disable_coordinates = true,
            additional_args = function(_)
                return { "--hidden" }
            end,
        },
        find_files = {
            hidden = true,
        },
    },
})

pcall(require('telescope').load_extension, "fzf")

local function is_git_dir(cwd)
    local p = vim.fn.finddir(".git", cwd .. ";/home")
    if p ~= nil then
        return true
    end
    print(cwd .. " is not a git directory!")
    return false
end

-- Keymaps
local builtin = require "telescope.builtin"

vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find({ sorting_strategy = "ascending", previewer = false, layout_config = { prompt_position = "top" } })
end, { desc = "Telescope - Search current buffer" })

vim.keymap.set('n', '<leader>fw', builtin.find_files, { desc = "Telescope - Find files in current work directory [:cd]" })
vim.keymap.set('n', '<leader>fW', function()
    local cwd = vim.fn.expand("%:p:h")
    builtin.find_files({ cwd = cwd })
end, { desc = "Telescope - Find files in the current buffer directory" })

vim.keymap.set('n', '<leader>fh', function() builtin.find_files({ hidden = true, no_ignore = true }) end,
    { desc = "Telescope - Find files (including hidden) in current work directory" })
vim.keymap.set('n', '<leader>fH', function()
    local cwd = vim.fn.expand("%:p:h")
    builtin.find_files({ cwd = cwd, hidden = true, no_ignore = true })
end, { desc = "Telescope - Find files (including hidden) in current buffer directory" })

vim.keymap.set('n', '<leader>gf', function()
    local cwd = vim.fn.expand("%:p:h")
    local b = is_git_dir(cwd)
    if b then
        builtin.git_files({ cwd = cwd })
    end
end, { desc = "Telescope - Find git files from current project" })

vim.keymap.set('n', '<leader>gc', function()
    local cwd = vim.fn.expand("%:p:h")
    local b = is_git_dir(cwd)
    if b then
        builtin.git_commits({ cwd = cwd })
    end
end, { desc = "Telescope - Find commits from the project" })

--[[
live_grep is not working... I tried fixing it, but couldn't
for my mental health sake, I gave up =(
]]
-- vim.keymap.set('n', '<leader>rg', function()
--     builtin.live_grep({
--         cwd = vim.fn.expand('%:p:h')
--     })
-- end, { desc = "Telescope - Search for a string in current path. Utilizes Ripgrep" })
-- vim.keymap.set('n', '<leader>rw', builtin.live_grep,
--     { desc = "Telescope - Similar to \'<leader>rg\', but instead find in the current work directory" })

vim.keymap.set('n', '<leader>gr', function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = vim.fn.input("Grep >> ", word) })
    end,
    { desc = "Telescope - Search word under the cursor/selection in current work directory" })
vim.keymap.set('n', '<leader>gR', function()
        local word = vim.fn.expand("<cWORD>")
        builtin.grep_string({ search = vim.fn.input("Grep >> ", word) })
    end,
    { desc = "Telescope - Search WORD under the cursor/selection in current work directory" })

vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "Telescope - Search all keymaps configured for normal mode" })

vim.keymap.set('n', '<leader>fc',
    function() builtin.find_files { cwd = vim.fn.expand("~/.local/share/chezmoi/dot_config") } end,
    { desc = "Telescope - Find file inside .config/ directory [CHEZMOI]" })

vim.keymap.set('n', '<leader>st', function()
    builtin.help_tags({
        layout_config = {
            preview_width = 0.7
        },
    })
end, { desc = "Telescope - Search help tags" })

vim.keymap.set('n', '<leader>sm', function()
    builtin.man_pages({
        layout_config = {
            preview_width = 0.7
        }
    })
end, { desc = "Telescope - Search man pages" })

vim.keymap.set('n', '<leader>sh', builtin.search_history,
    { desc = "Telescope - list recent searches and re-execute them" })

local telescope = require 'telescope'

telescope.setup({
    extensions = {
        wrap_results = true,
        fzf = {},
    },
    defaults = {
        prompt_prefix = " ",
    },
    pickers = {
        live_grep = {
            file_ignore_patterns = { 'node_modules', '.git', '.venv' },
            additional_args = function(_)
                return { "--hidden" }
            end,
        },
        find_files = {
            file_ignore_patterns = { 'node_modules', '.git', '.venv' },
            hidden = true,
        },
    },
})

pcall(require('telescope').load_extension, "fzf")

-- Keymaps
local builtin = require "telescope.builtin"
vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find({ sorting_strategy = "ascending", previewer = false, layout_config = { prompt_position = "top" } })
end, { desc = "Search current buffer" })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files in current work directory" })
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = "Find git files from current project" })
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Find commits from the project" })
vim.keymap.set('n', '<leader>rg', function() builtin.live_grep({ cwd = vim.fn.expand('%:p:h') }) end,
    { desc = "Search for a string in current work directory as you type. Utilizes Ripgrep" })
vim.keymap.set('n', '<leader>gr', function() builtin.grep_string({ search = vim.fn.input("Grep >> ") }) end,
    { desc = "Search string under the cursor/selection in current work directory" })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "Search all keymaps configured for normal mode" })
vim.keymap.set('n', '<leader>fc',
    function() builtin.find_files { cwd = vim.fn.expand("~/.local/share/chezmoi/dot_config") } end,
    { desc = "Find file inside .config/ directory [CHEZMOI]" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Search help tags" })

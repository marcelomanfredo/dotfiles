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

vim.keymap.set('n', '<leader>fw', builtin.find_files, { desc = "Find files in current work directory" })

vim.keymap.set('n', '<leader>fh', function() builtin.find_files({ hidden = true, no_ignore = true }) end,
    { desc = "Find files (including hidden) in current work directory" })

vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = "Find git files from current project" })

vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Find commits from the project" })

vim.keymap.set('n', '<leader>rg', function() builtin.live_grep({ cwd = vim.fn.expand('%:p:h') }) end,
    { desc = "Search for a string in current path. Utilizes Ripgrep" })

vim.keymap.set('n', '<leader>rw', builtin.live_grep,
    { desc = "Similar to \'<leader>rg\', but instead find in the current work directory" })

vim.keymap.set('n', '<leader>gr', function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = vim.fn.input("Grep >> ", word) })
    end,
    { desc = "Search string under the cursor/selection in current work directory" })

vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "Search all keymaps configured for normal mode" })

vim.keymap.set('n', '<leader>fc',
    function() builtin.find_files { cwd = vim.fn.expand("~/.local/share/chezmoi/dot_config") } end,
    { desc = "Find file inside .config/ directory [CHEZMOI]" })

vim.keymap.set('n', '<leader>ft', builtin.help_tags, { desc = "Search help tags" })


-- Spell checker
local function SpellCheck()
    if vim.fn.mode() ~= 'v' and vim.fn.mode() ~= 'V' then
        vim.notify("Visual mode only!", vim.log.levels.WARN)
    end

    -- Save context
    local ctx_win = vim.api.nvim_get_current_win()
    local ctx_buf = vim.api.nvim_get_current_buf()

    -- Yank selection
    vim.cmd('normal! "ay')
    local selected_text = vim.fn.getreg('a')
    local lines = vim.split(selected_text, '\n')
    local edited_lines = vim.deepcopy(lines) -- store edits

    -- Build telescope float win
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    -- Show line number with possible errors
    local make_display = function(entry)
        local line_num = string.format('%3d', entry.index)
        local line_content = entry.value

        local has_error = line_content:match('%a%a%a+') ~= nil

        if has_error then
            return string.format('%s: %s ', line_num, line_content)
        else
            return string.format('%s: %s', line_num, line_content)
        end
    end

    local picker = pickers.new({
        prompt_title = ' Spell Check Selection',
        prompt_prefix = ' ',
        finder = finders.new_table({
            results = edited_lines,
            entry_maker = function(line, index)
                return {
                    value = line,
                    display = make_display,
                    ordinal = line,
                    index = index,
                }
            end
        }),
        sorter = conf.generic_sorter({}),
        previewer = nil,
        layout_config = {
            width = 0.9,
            height = 0.8,
            prompt_position = "top",
        },
        attach_mappings = function(prompt_bufnr, map)
            -- RETURN: Edit the current line
            map('i', '<CR>', function()
                local entry = action_state.get_selected_entry()

                -- Create editor
                local function create_popup()
                    local popup_buf = vim.api.nvim_create_buf(false, true)
                    local popup_win = vim.api.nvim_open_win(popup_buf, true, {
                        relative = 'cursor',
                        width = math.min(80, vim.o.columns - 10),
                        height = 3,
                        row = 1,
                        col = 0,
                        style = 'minimal',
                        border = 'rounded',
                        title = 'Edit Line',
                    })

                    --Set up popup buffer
                    vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, { entry.value })
                    vim.wo[popup_win].spell = true
                    vim.bo[popup_buf].spelllang = 'en'
                    vim.bo[popup_buf].filetype = 'markdown'
                    vim.bo[popup_buf].spelloptions = 'camel'

                    -- Start editing
                    vim.cmd('normal! $')
                    vim.cmd('startinsert')

                    -- Save func for the group
                    local function save_popup()
                        local new_line = vim.api.nvim_buf_get_lines(popup_buf, 0, 1, false)[1]
                        edited_lines[entry.index + 1] = new_line
                        vim.api.nvim_win_close(popup_win, true)

                        -- Reopen with updated content
                        SpellCheck()
                    end

                    -- Popup keymaps
                    vim.keymap.set('n', '<leader>w', save_popup, { buffer = popup_buf, desc = 'save edits' })
                    vim.keymap.set('n', '<leader>q', function()
                        vim.api.nvim_win_close(popup_win, true)
                        -- Reopen without save
                        SpellCheck()
                    end, { buffer = popup_buf, desc = 'discard edits' })

                    vim.notify("Edit line. <leader>w to save, <leader>q to cancel", vim.log.levels.INFO)
                    return popup_buf, popup_win
                end

                actions.close(prompt_bufnr)

                vim.defer_fn(create_popup, 50)
            end)

            -- Ctrl+S: Apply all and close
            map('i', '<C-s>', function()
                actions.close(prompt_bufnr)

                -- Apply to the original
                local final_text = table.concat(edited_lines, '\n')
                vim.api.nvim_set_current_win(ctx_win)
                vim.api.nvim_set_current_buf(ctx_buf)
                vim.fn.setreg('a', final_text)
                vim.cmd('normal! gv"ap')

                vim.notify(" Spell check applied!", vim.log.levels.INFO)
            end)

            -- Ctrl+Q: Cancel
            map('i', '<C-q>', function()
                actions.close(prompt_bufnr)
                vim.notify('󰰲 Spell Check cancelled!', vim.log.levels.INFO)
            end)

            return true
        end,
    })

    picker:find()
end

-- Keymap for spell check
vim.keymap.set('v', '<leader>sc', SpellCheck, { desc = 'Open spell check window' })

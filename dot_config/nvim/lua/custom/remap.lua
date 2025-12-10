-- Quality of life
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "Go to Project View (explorer)" })
vim.keymap.set('n', 'J', 'mzJ`z',
    { desc = "When appending lines with 'J', make cursor stay at the beginning of the line" })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = "Make cursor stay at the middle" })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = "Make cursor stay at the middle" })
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Make cursor stay at the middle" })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Make cursor stay at the middle" })
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
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = "Exit terminal mode" })
vim.keymap.set('n', '<leader><leader>r', function()
    -- Get the current word under the cursor
    local word = vim.fn.expand('<cword>')

    vim.ui.input({ prompt = "Replace \'" .. word .. "\' with: ", default = word }, function(input)
        if input then
            -- Perform global replacement
            vim.cmd('%s/' .. word .. '/' .. input .. '/g')
        end
    end)
end, { desc = 'Performs a simple word under cursor replace' })
vim.keymap.set('n', '<leader>h', function()
    local f = vim.fn.expand("%:p")
    vim.fn.jobstart({ "xdg-open", f }, { detach = true })
end, { desc = "Starts a live server to preview HTML changes" })
vim.keymap.set('n', '<leader><leader>w',
    function()
        vim.opt.wrap = not vim.opt.wrap:get()
        vim.opt.linebreak = not vim.opt.linebreak:get()
    end,
    { desc = "Toggle line wrap" })

-- SQL dadbod
vim.keymap.set('n', '<leader>sq', '<cmd>DBUIToggle<cr>')
vim.keymap.set('n', '<leader>sf', '<cmd>DBUIFindBuffer<cr>')


-- Source current lua file to neovim config
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<cr>', { desc = "Source current Lua file" })


-- Fugitive git
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)


-- Undotree toggle
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Toggle undotree view" })


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

-- Markdown Preview toggle
vim.keymap.set('n', '<leader>m', '<cmd>MarkdownPreviewToggle<cr>', { desc = "Toggles Markdown Preview into firefox" })


-- SQL formatter
local function sqruff_format()
    if vim.bo.filetype ~= "sql" then
        vim.notify("Not a SQL file", vim.log.levels.INFO)
        return
    end

    local filepath = vim.api.nvim_buf_get_name(0)
    local buf_contents = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local input = table.concat(buf_contents, "\n")

    local cmd = { "pg_format", "-abg", "--redundant-parenthesis", "--no-space-function", filepath }
    --[[
    -a: obscure all literals in queries.
    -b: start with the comma in parameters list > useful for quick comments.
    -g: add a newline between statements in transactions regroupement. Add readability.
    --redundant-parenthesis: do not remove redundant parenthesis in DML.
    --no-space-function: remove space between function call and the open parenthesis.
	]]

    local output = vim.fn.system(cmd, input)
    local lines = vim.split(output, "\n")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.notify("Formatting was successful", vim.log.levels.INFO)
end
vim.keymap.set('n', '<leader>fs', sqruff_format, { desc = "Format SQL files" })


-- Spellcheck
local function SpellCheckSelection()
    if vim.fn.mode() ~= 'v' and vim.fn.mode() ~= 'V' then
        print("Error: This works only in visual mode!")
        return
    end

    -- Save original window and buffer
    local orig_win = vim.api.nvim_get_current_win()
    local orig_buf = vim.api.nvim_get_current_buf()

    -- Yank the visual selection into register 'a'
    vim.cmd('normal! "ay')

    local selected_text = vim.fn.getreg('a')

    -- Create a floating scratch buffer
    local buf = vim.api.nvim_create_buf(true, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = 'minimal',
        border = 'rounded',
        title = 'Spell Check',
        title_pos = 'center',
    })

    -- Set buffer options
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(selected_text, '\n'))
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(buf, 'spell', true)
    vim.api.nvim_buf_set_option(buf, 'spelllang', 'en')
    vim.api.nvim_buf_set_option(buf, 'spelloptions', 'camel')

    -- Function to apply changes back to original selection
    local function apply_changes()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local modified_text = table.concat(lines, '\n')

        -- Go back to original window and buffer
        vim.api.nvim_set_current_win(orig_win)
        vim.api.nvim_set_current_buf(orig_buf)

        -- Replace visual selection
        vim.fn.setreg('a', modified_text)
        vim.cmd('normal! gv"ap')

        -- Close floating window
        vim.api.nvim_win_close(win, true)
    end

    -- Keymaps for floating buffer
    vim.keymap.set('n', '<leader>w', apply_changes, { buffer = buf, desc = 'Apply spell check' })
    vim.keymap.set('n', '<leader>q', function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf, desc = 'Close without applying' })

    print("SpellCheck active. <leader>w to apply, <leader>q to close.")
end
--vim.keymap.set('v', '<leader>sc', SpellCheckSelection, { desc = 'Spell check selection' })

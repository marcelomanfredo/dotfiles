-- No cursor overlay in Neovim, all should be handled by the terminal emulator
vim.opt.guicursor = ""

-- Change CWD, for better integration with tmux status bar
--vim.opt.autochdir = true -- I don't know if I like this

-- Activate line and relative line numbers
vim.opt.nu = true
vim.opt.rnu = true

-- <Space> as indent, and set a number for it
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- Stop "o" and "O" to insert line with comment.
-- Set textwidth limit to 120 characters in comment lines.
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        vim.opt_local.textwidth = 120
        vim.opt_local.formatoptions:remove("o")
    end
})

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

-- Adjust screen to keep cursor at the center if it's the end of the file
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = function()
        local height = vim.api.nvim_win_get_height(0)
        local cur_row = vim.fn.winline()
        local scrolloff = vim.o.scrolloff

        if cur_row > height - scrolloff then
            vim.cmd("normal! zz")
        end
    end,
})

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

vim.opt.list = true
vim.opt.listchars = {
    eol = '↲',
    tab = '»·',
    trail = '·',
    lead = '·',
    extends = '⟩',
    precedes = '⟨',
    nbsp = '˔',
    multispace = '␣'
}

-- Spell check
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "markdown", "tex", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = 'en'
        vim.opt_local.spelloptions = "camel"
    end,
    desc = "Enable spell checking for text-based filetypes"
})

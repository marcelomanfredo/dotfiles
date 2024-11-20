-- LSP
vim.lsp.set_log_level("debug")
require 'custom.Lsp.lsp_init'

-- Remaps
require 'custom.remap'

-- Settings
require 'custom.settings'

--Undotree
if vim.fn.has("persistent_undo") == 0 then
    local target_path = vim.fn.expand("~/.undodir")

    --Check if dir exists
    if vim.fn.isdirectory(target_path) == -1 then
        vim.fn.mkdir(target_path, "p", 0699)
    end

    vim.o.undodir = target_path
    vim.o.undofile = true
end

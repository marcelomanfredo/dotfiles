local dap = require 'dap'
local ui = require 'dapui'
local vt = require 'nvim-dap-virtual-text'

ui.setup()
vt.setup()

-- Lua
dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
    }
}

dap.adapters.nlua = function(callback, config)
    callback({
        type = 'server',
        host = config.host or '127.0.0.1',
        port = config.port or 8086
    })
end


-- Setting up CODELLDB
dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        command = '/usr/bin/codelldb',
        args = { "--port", "${port}" },
    }
}


-- The great RUST
dap.configurations.rust = {
    {
        name = "Launch rust",
        type = 'codelldb',
        request = 'launch',
        program = function()
            local cwd = vim.fn.getcwd()
            return vim.fn.input('Path to executable : ',
                cwd .. '/target/debug/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))
        end,
        cargo = {
            args = { "test", "--no-run", "--lib" }, -- Cargo cmd line to build the debug target
            env = { RUSTFLAGS = '-Clinker=ld.mold' },
            problemMatcher = '$rustc',
            filter = {
                name = 'mylib',
                kind = 'lib',
            },
        },
    }
}
--
--vim.g.rustaceanvim = {
--    on_attach = cfg.on_attach,
--}


-- C & C++
dap.configurations.c = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}

dap.configurations.cpp = dap.configurations.c



-- Debugging Keymaps
local km = vim.keymap
km.set('n', '<F1>', dap.step_into, { desc = "DAP: Step into", silent = true, noremap = true })
km.set('n', '<F2>', dap.step_over, { desc = "DAP: Step over", silent = true, noremap = true })
km.set('n', '<F3>', dap.step_out, { desc = "DAP: Step out", silent = true, noremap = true })
km.set('n', '<F4>', dap.step_back, { desc = "DAP: Step back", silent = true, noremap = true })
km.set('n', '<F5>', dap.continue, { desc = "DAP: Continue", silent = true, noremap = true })
km.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint", silent = true, noremap = true })
km.set('n', '<leader>B', "<cmd>lua dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { desc = "Toggle conditional breakpoint", silent = true, noremap = true })


-- Listeners to open and close DAPUI automatically
dap.listeners.before.attach.dapui_config = function()
    ui.open()
end
dap.listeners.before.launch.dapui_config = function()
    ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    ui.close()
end

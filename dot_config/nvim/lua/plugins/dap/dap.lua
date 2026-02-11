return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            dependencies = {
                "nvim-neotest/nvim-nio",
            },
            opts = {
                library = { "nvim-dap-ui" },
            },
        },
        "theHamsta/nvim-dap-virtual-text",
        "leoluz/nvim-dap-go",
    },
    lazy = true,
    config = function()
        require("plugins.dap.utils.dap-ui")
        -- [[ Keymaps ]]
        -- Set on lsp.utils.keymaps

        local dap = require("dap")
        dap.adapters.codelldb = {
            type = "executable",
            command = "codelldb",
        }

        dap.configurations.cpp = {
            {
                name = "Launch",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }
        dap.configurations.c = dap.configurations.cpp

        vim.g.rustaceanvim = {
            dap = {
                adapter = require("rustaceanvim.config").get_codelldb_adapter(
                    vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                    vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
                ),
            },
        }
        require("plugins.dap.utils.rustacean")

        require("dap-go").setup()
    end,
}

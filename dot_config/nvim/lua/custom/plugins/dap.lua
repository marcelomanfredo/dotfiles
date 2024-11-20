return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        --"mrcjkb/rustaceanvim", -- See this one for the future
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
        "jbyuki/one-small-step-for-vimkind",
    },
    config = function()
        require 'custom.Dap.dap_init'
    end,
}

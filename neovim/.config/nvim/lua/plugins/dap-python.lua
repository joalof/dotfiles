return {
    "mfussenegger/nvim-dap-python",
    keys = {
        { "<leader>dtm", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dtc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
    },
    config = function()
        -- local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup()
    end,
}

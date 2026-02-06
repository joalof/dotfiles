return {
    "mfussenegger/nvim-dap-python",
    config = function()
        require("dap-python").setup("python3")
        -- If using the above, then `python3 -m debugpy --version`
        -- must work in the shell
    end
}

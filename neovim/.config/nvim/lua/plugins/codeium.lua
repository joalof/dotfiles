return {
    -- {
    --     "jcdickinson/http.nvim",
    --     build = "cargo build --workspace --release"
    -- },
    {
        -- TODO find something that is maintained
        "jcdickinson/codeium.nvim",
        dependencies = {
            -- "jcdickinson/http.nvim",
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        -- function to prevent accumulating binaries
        -- https://github.com/jcdickinson/codeium.nvim/issues/58
        build = function()
            local bin_path = vim.fn.stdpath("cache") .. "/codeium"
            local old_binaries = vim.fs.find(
                function() return true end,
                { type = "file", limit = math.huge, path = bin_path }
            )
            table.remove(old_binaries) -- remove last item (= most up to date binary) from list
            for _, binary_path in pairs(old_binaries) do
                os.remove(binary_path)
                os.remove(vim.fs.dirname(binary_path))
            end
        end,
        config = function()
            require("codeium").setup({})
        end
    },
}

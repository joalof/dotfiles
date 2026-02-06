return {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        delay = 1000,
        large_file_cutoff = 2000,
        large_file_overrides = {
            providers = { "lsp" },
        },
        filetypes_denylist = {
            'fugitive',
            'markdown',
            'help',
        },
    },
    keys = {
        { "]r", desc = "Next Reference" },
        { "[r", desc = "Prev Reference" },
    },
    config = function(_, opts)
        require("illuminate").configure(opts)

        local function map(key, dir, buffer)
            vim.keymap.set("n", key, function()
                require("illuminate")["goto_" .. dir .. "_reference"](false)
            end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
        end

        map("]r", "next")
        map("[r", "prev")

        -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                local buffer = vim.api.nvim_get_current_buf()
                map("]r", "next", buffer)
                map("[r", "prev", buffer)
            end,
        })
    end,
}

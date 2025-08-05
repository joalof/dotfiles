return {
    "waiting-for-dev/ergoterm.nvim",
    keys = { "<C-s>c", "<C-s>/", "<C-s>_" },
    dependencies = {
        "nvimtools/hydra.nvim",
    },
    config = function()
        require("ergoterm").setup({})

        local terminal = require("ergoterm.terminal")
        vim.keymap.set({ "n", "t" }, "<C-s>c", function()
            local term = terminal.Terminal:new({ layout = "tab" })
            term:focus()
        end)
        vim.keymap.set({ "n", "t" }, "<C-s>/", function()
            local term = terminal.Terminal:new({ layout = "right" })
            term:focus()
        end)
        vim.keymap.set({ "n", "t" }, "<C-s>_", function()
            local term = terminal.Terminal:new({ layout = "below" })
            term:focus()
        end)

        -- hydra for tab navigation, not strictly related 
        -- to terminals but I probably only want these keyamps
        -- if we're using nvims built-in terminal instead of 
        -- terminal emulator multiplexing
        local hydra = require("hydra")
        hydra({
            name = "tab navigation",
            mode = { "n", "t" },
            body = "<C-s>",
            config = {hint = false},
            heads = {
                {
                    "n",
                    function()
                        vim.api.nvim_command("tabnext")
                    end,
                },
                {
                    "p",
                    function()
                        vim.api.nvim_command("tabprevious")
                    end,
                },
            },
        })
        
    end,
}

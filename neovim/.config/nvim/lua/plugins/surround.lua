return {
    "kylechui/nvim-surround",
    -- version = "*", -- Use for stability; omit to use `main` branch for the latest features
    -- event = "VeryLazy",
    keys = {
        { mode = { "n" }, "ys" },
        { mode = { "n" }, "yss" },
        { mode = { "n" }, "yS" },
        { mode = { "n" }, "ySS" },
        { mode = { "n" }, "ds" },
        { mode = { "n" }, "cs" },
    },
    config = function()
        Config = require("nvim-surround.config")
        require("nvim-surround").setup({
            -- modify pair surrounds to never add spaces
            surrounds = {
                ["("] = {
                    add = { "(", ")" },
                    find = function()
                        return Config.get_selection({ motion = "a(" })
                    end,
                    delete = "^(. ?)().-( ?.)()$",
                },
                ["{"] = {
                    add = { "{", "}" },
                    find = function()
                        return Config.get_selection({ motion = "a{" })
                    end,
                    delete = "^(. ?)().-( ?.)()$",
                },
                ["<"] = {
                    add = { "<", ">" },
                    find = function()
                        return Config.get_selection({ motion = "a<" })
                    end,
                    delete = "^(. ?)().-( ?.)()$",
                },
                ["["] = {
                    add = { "[", "]" },
                    find = function()
                        return Config.get_selection({ motion = "a[" })
                    end,
                    delete = "^(. ?)().-( ?.)()$",
                },
            },
        })
    end,
}

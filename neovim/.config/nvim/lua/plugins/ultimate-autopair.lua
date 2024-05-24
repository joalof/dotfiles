return {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {
        cmap = false,
        bs = {
            map = "<C-h>",
            cmap = "<C-h>",
        },
        cr = {
            map = "<C-j>",
        },
        tabout = {
            enable = true,
            map = "<C-l>",
            hopout = true,
        },
        fastwarp = {
           enable = false,
        },
        extensions = {
            alpha = {after = true},
        }
    },
}

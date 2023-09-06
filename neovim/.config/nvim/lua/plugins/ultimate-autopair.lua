return {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    commit = "667d2304e8eb9ddbfa7f962528cfce0a5edcc163",
    opts = {
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

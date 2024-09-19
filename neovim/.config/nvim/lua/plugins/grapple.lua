return {
    "cbochs/grapple.nvim",
    opts = {
        scope = "git_branch",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
        { "m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
        { "M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
        { "<c-l>", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
        { "<c-h>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
    },
}

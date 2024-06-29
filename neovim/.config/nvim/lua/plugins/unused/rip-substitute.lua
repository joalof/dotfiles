return {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
        {
            "<leader>as",
            function() require("rip-substitute").sub() end,
            mode = { "n", "x" },
            desc = " rip substitute",
        },
    },
}

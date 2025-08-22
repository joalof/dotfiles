return {
    "andrewferrier/debugprint.nvim",
    opts = {
        keymaps = {
            normal = {
                plain_below = "<leader>dpp",
                plain_above = nil,
                variable_below = "<leader>dpv",
                variable_above = nil,
                variable_below_alwaysprompt = nil,
                variable_above_alwaysprompt = nil,
                textobj_below = "<leader>dp",
                textobj_above = nil,
                toggle_comment_debug_prints = nil,
                delete_debug_prints = nil,
            },
            visual = {
                variable_below = "<leader>dp",
                variable_above = nil,
            },
        },
        commands = {
            toggle_comment_debug_prints = "ToggleCommentDebugPrints",
            delete_debug_prints = "DeleteDebugPrints",
        },
    },
    version = "*",
}

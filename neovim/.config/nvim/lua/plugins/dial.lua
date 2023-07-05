return {
    'monaqa/dial.nvim',
    keys = {"<C-a>", "<C-x>"},
    config = function()
        local augend = require("dial.augend")
        require("dial.config").augends:register_group{
          default = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.date.alias["%Y/%m/%d"],
            augend.constant.new {
                elements = {"true", "false"},
                word = true,
                cyclic = true,
                preserve_case = true,
            }
          },
        }
        vim.keymap.set("n", "<C-a>", require('dial.map').inc_normal())
        vim.keymap.set("n", "<C-x>", require('dial.map').dec_normal())
        vim.keymap.set("v", "<C-a>", require('dial.map').inc_visual())
        vim.keymap.set("v", "<C-x>", require('dial.map').dec_visual())
    end,
}

return {
    'echasnovski/mini.bracketed',
    dependencies = {
        "nvimtools/hydra.nvim",
    },
    config = function()
        local hydra = require("hydra")

        local bracketed = require('mini.bracketed')
        local func_maps = {
            buffer = 'b',
            diagnostic = 'e',
            file = 'f',
            quickfix = 'q',
        }

        local heads = {forward = {}, backward = {}}
        local i = 1
        for func, head in pairs(func_maps) do
            heads.forward[i] = {head, function() bracketed[func]('forward') end}
            heads.forward[i + 1] = {head:upper(), function() bracketed[func]('last') end}
            heads.backward[i] = {head, function() bracketed[func]('backward') end}
            heads.backward[i + 1] = {head:upper(), function() bracketed[func]('first') end}
            i = i + 2
        end
        
        hydra({
            name = "bracket navigation forward",
            mode = { "n" },
            body = "]",
            config = {hint = false},
            heads = heads['forward'],
        })

        hydra({
            name = "bracket navigation backward",
            mode = { "n" },
            body = "[",
            config = {hint = false},
            heads = heads['backward'],
        })
        
    end,
}

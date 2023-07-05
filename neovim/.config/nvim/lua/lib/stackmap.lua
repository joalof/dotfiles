-- From https://github.com/tjdevries/stackmap.nvim
-- MIT License
--[[
Copyright (c) 2022 TJ DeVries

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local M = {}

local find_mapping = function(maps, lhs)
    for _, value in ipairs(maps) do
        if value.lhs == lhs then
            return value
        end
    end
end

M._stack = {}

M.push = function(name, mode, mappings)
    local maps = vim.api.nvim_get_keymap(mode)

    local existing_maps = {}
    for lhs, rhs in pairs(mappings) do
        local existing = find_mapping(maps, lhs)
        if existing then
            existing_maps[lhs] = existing
        end
    end

    for lhs, rhs in pairs(mappings) do
        -- TODDO: need some way to pass options in here
        vim.keymap.set(mode, lhs, rhs)
    end

    -- TODO: Next time show bash about metatables POGSLIDE
    M._stack[name] = M._stack[name] or {}

    M._stack[name][mode] = {
        existing = existing_maps,
        mappings = mappings,
    }
end

M.pop = function(name, mode)
    local state = M._stack[name][mode]
    M._stack[name][mode] = nil

    for lhs in pairs(state.mappings) do
        if state.existing[lhs] then
            -- Handle mappings that existed
            local og_mapping = state.existing[lhs]

            -- TODO: Handle the options from the table
            vim.keymap.set(mode, lhs, og_mapping.rhs)
        else
            -- Handled mappings that didn't exist
            vim.keymap.del(mode, lhs)
        end
    end
end

M._clear = function()
    M._stack = {}
end

return M

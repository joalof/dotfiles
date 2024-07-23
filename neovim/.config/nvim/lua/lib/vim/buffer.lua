local Buffer = setmetatable({}, {})
local api = vim.api

Buffer.__index = Buffer

function Buffer:new(...)
    local args = {...}
    local buf = {
        handle = 0
    }
    setmetatable(buf, Buffer)
    return buf
end

local mt = getmetatable(Buffer)
function mt.__call(_, opts)
    return Buffer:new(opts)
end

function Buffer:find(name, opts)
    local handles = api.nvim_list_bufs()
end

function Buffer:length()
    return api.nvim_buf_line_count(self.handle)
end

function Buffer:name()
    return api.nvim_buf_get_name(self.handle)
end

function Buffer:exists()
end

function Buffer:get_options()
end

function Buffer:set_options()
end

function Buffer:set_lines()
end

function Buffer:get_lines()
end

function Buffer:set_text()
end

function Buffer:get_text()
end

return Buffer

local api = vim.api

local Buffer = setmetatable({}, {})

local M = { Buffer = Buffer }

local property_setters = {
    name = function(buf, name)
        return api.nvim_buf_set_name(buf.handle, name)
    end,
}

local property_getters = {
    name = function(buf)
        return api.nvim_buf_get_name(buf.handle)
    end,
    length = function(buf)
        return api.nvim_buf_line_count(buf.handle)
    end,
    loaded = function(buf)
        return api.nvim_buf_is_loaded(buf)
    end,
    valid = function(buf)
        return api.nvim_buf_is_loaded(buf)
    end,
}

Buffer.__index = function(tbl, key)
    local raw = rawget(Buffer, key)
    if raw then
        return raw
    end

    local getter = property_getters[key]
    if getter then
        return getter(tbl)
    end
end

Buffer.__indexnew = function(tbl, key, value)
    local setter = property_setters[key]
    if setter then
        setter(tbl, value)
    else
        rawset(tbl, key, value)
    end
end

function Buffer:new(handle)
    handle = handle or 0
    local buf = {
        handle = handle,
    }
    setmetatable(buf, Buffer)
    return buf
end

function Buffer:from_name(name)
    local handles = api.nvim_list_bufs()
    for _, handle in ipairs(handles) do
        local buf_name = api.nvim_buf_get_name(handle)
        if buf_name == name then
            return Buffer:new(handle)
        end
    end
end

local mt = getmetatable(Buffer)
function mt.__call(_, ...)
    if #arg == 0 then
        arg = { 0, n = 1 }
    end
    if arg["n"] == 1 then
        if type(arg[1]) == "number" then
            return Buffer:new(arg[1])
        elseif type(arg[1]) == "string" then
            return Buffer:from_name(arg[1])
        end
    end
end

function Buffer:get_options(opt_names)
    local opts = {}
    for _, name in ipairs(opt_names) do
        opts[name] = api.nvim_get_option_value(name, { buf = self.handle })
    end
    return opts
end

function Buffer:set_options(opts)
    for name, val in pairs(opts) do
        api.nvim_set_option_value(name, val, { buf = self.handle })
    end
end

function Buffer:set_lines(lines, start, stop, strict_indexing)
    start = start or 0
    stop = stop or start
    strict_indexing = strict_indexing or true
    api.nvim_buf_set_lines(self.handle, start, stop, strict_indexing, lines)
end

function Buffer:get_lines(start, stop, strict_indexing)
    start = start or 0
    stop = stop or self.length
    strict_indexing = strict_indexing or true
    local lines = api.nvim_buf_get_lines(self.handle, start, stop, strict_indexing)
    return lines
end

function Buffer:set_text(text, start_row, start_col, stop_row, stop_col)
    stop_row = stop_row or start_row
    stop_col = stop_col or start_col
    api.nvim_buf_set_text(self.handle, start_row, start_col, stop_row, stop_col, text)
end

function Buffer:get_text(start_row, start_col, stop_row, stop_col, opts)
    opts = opts or {}
    local text = api.nvim_buf_get_text(self.handle, start_row, start_col, stop_row, stop_col, opts)
    return text
end

function Buffer:attach(send_buffer, opts)
    opts = opts or {}
    local success = api.nvim_buf_attach(self.handle, send_buffer, opts)
    return success
end

function Buffer:detach()
    local success = api.nvim_buf_detach(self.handle)
    return success
end

function Buffer:create_command()
end

function Buffer:del_command()
end

function Buffer:get_commands()
end

M.find = function(opts)
    opts = opts or {}
    local bufs = {}
    local handles = api.nvim_list_bufs()
    for i, handle in ipairs(handles) do
        local buf = Buffer:new(handle)
        bufs[i] = buf
    end
    return bufs
end

return M

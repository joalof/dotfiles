local api = vim.api
require('table.new')

local M = {}

--
-- Buffer class
--
local Buffer = setmetatable({}, {})

M.Buffer = Buffer


local buffer_getters = {
    name = function(buf)
        return api.nvim_buf_get_name(buf.handle)
    end,
    line_count = function(buf)
        return api.nvim_buf_line_count(buf.handle)
    end,
    loaded = function(buf)
        return api.nvim_buf_is_loaded(buf.handle)
    end,
    valid = function(buf)
        return api.nvim_buf_is_valid(buf.handle)
    end,
    changedtick = function(buf)
        return api.nvim_buf_get_changedtick(buf.handle)
    end,
    readonly = function(buf)
        return buf:get_option("readonly")
    end,
    filetype = function(buf)
        return buf:get_option("filetype")
    end,
}

local buffer_setters = {
    name = function(buf, name)
        api.nvim_buf_set_name(buf.handle, name)
    end,
    readonly = function(buf, value)
        buf:set_option({ readonly = value })
    end,
}

Buffer.__index = function(tbl, key)

    local raw = rawget(Buffer, key)
    if raw then
        return raw
    end

    local getter = buffer_getters[key]
    if getter then
        return getter(tbl)
    end
end

Buffer.__newindex = function(tbl, key, value)
    local setter = buffer_setters[key]
    if setter then
        setter(tbl, value)
    else
        rawset(tbl, key, value)
    end
end

function Buffer:new(handle, verify)
    verify = verify or true
    if verify and handle ~= 0 then
        if not api.nvim_buf_is_valid(handle) then
            error(string.format('Buffer with handle %d is not valid', handle))
        end
    end
    local buf = {
        handle = handle,
    }
    setmetatable(buf, Buffer)
    return buf
end

-- creates a new Buffer
function Buffer:create(name, listed, scratch)
    listed = listed or true
    scratch = scratch or false
    local handle = api.nvim_create_buf(listed, scratch)
    local buf = Buffer:new(handle, false)
    if name then
        buf.name = name
    end
    return buf
end


-- Gets an existing Buffer or creates a new one with a given name
function Buffer:from_name(name)
    local existing_handles = api.nvim_list_bufs()
    for _, hand in ipairs(existing_handles) do
        local buf_name = api.nvim_buf_get_name(hand)
        if buf_name == name then
            return Buffer:new(hand, false)
        end
    end
    error(string.format('Buffer with name %s does not exist', name))
end

local Buffer_mt = getmetatable(Buffer)
function Buffer_mt.__call(_, ...)
    if #args == 1 then
        if type(args[1]) == "number" then
            return Buffer:new(args[1])
        elseif type(args[1]) == "string" then
            return Buffer:from_name(args[1])
        end
    end
    error(string.format('No constructor matching arguments.'))
end

function Buffer:is_file()
    local Path = require("lib.path").Path
    local buf_path = Path(self.name)
    return buf_path:is_file()
end

function Buffer:get_option(opt_name)
    if type(opt_name) == "string" then
        local value = api.nvim_get_option_value(opt_name, { buf = self.handle })
        return value
    else
        local opts = {}
        for _, name in ipairs(opt_name) do
            opts[name] = api.nvim_get_option_value(name, { buf = self.handle })
        end
        return opts
    end
end

function Buffer:set_option(opts)
    for name, val in pairs(opts) do
        api.nvim_set_option_value(name, val, { buf = self.handle })
    end
end

function Buffer:delete(opts)
    opts = opts or {}
    api.nvim_buf_delete(self.handle, opts)
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

function Buffer:get_offset(index)
    local offset = api.nvim_buf_get_offset(self.handle, index)
    return offset
end

function Buffer:set_keymap(lhs, rhs, mode, opts)
    mode = mode or "n"
    opts = opts or {}
    opts.buffer = 0
    vim.keymap.set(mode, lhs, rhs, opts)
end

function Buffer:get_keymap(mode)
    mode = mode or "n"
    local keymaps = api.nvim_buf_get_keymap(self.handle, mode)
    return keymaps
end

function Buffer:del_keymap(lhs, mode)
    mode = mode or "n"
    local opts = { buffer = self.handle }
    vim.keymap.del(mode, lhs, opts)
end

function Buffer:set_var(name, value)
    api.nvim_buf_set_var(self.handle, name, value)
end

function Buffer:del_var(name)
    api.nvim_buf_set_var(self.handle, name)
end

function Buffer:set_mark(name, line, col, opts)
    opts = opts or {}
    local success = api.nvim_buf_set_mark(self.handle, name, line, col, opts)
    return success
end

function Buffer:del_mark(name)
    local success = api.nvim_buf_del_mark(self.handle, name)
    return success
end

function Buffer:attach(send_buffer, opts)
    opts = opts or {}
    local success = api.nvim_buf_attach(self.handle, send_buffer, opts)
    return success
end

function Buffer:create_command(name, command, opts)
    opts = opts or {}
    api.nvim_buf_create_user_command(self.handle, name, command, opts)
end

function Buffer:del_command(name)
    api.nvim_buf_del_user_command(self.handle, name)
end

function Buffer:get_commands(opts)
    opts = opts or {}
    local commands = api.nvim_buf_get_commands(self.handle, opts)
    return commands
end

function Buffer:call(fun)
    local res = api.nvim_buf_call(self.handle, fun)
    return res
end

function Buffer:add_highlight(hl_group, line, col_start, col_stop, ns_id)
    ns_id = ns_id or 0
    col_start = col_start or 0
    col_stop = col_stop or -1
    local ns_id_new = api.nvim_buf_add_highlight(self.handle, ns_id, hl_group, line, col_start, col_stop)
    return ns_id_new
end

function Buffer:clear_namespace(ns_id, line_start, line_stop)
    line_start = line_start or 0
    line_stop = line_stop or -1
    api.nvim_buf_clear_namespace(self.handle, ns_id, line_start, line_stop)
end

function Buffer:set_extmark(ns_id, line, col, opts)
    opts = opts or {}
    local id = api.nvim_buf_set_extmark(self.handle, ns_id, line, col, opts)
    return id
end

function Buffer:get_extmarks(ns_id, start, stop, opts)
    opts = opts or {}
    local extmarks = api.nvim_buf_get_extmarks(self.handle, ns_id, start, stop, opts)
    return extmarks
    
end

function Buffer:get_extmark_by_id(ns_id, id, opts)
    opts = opts or {}
    local extmark = api.nvim_buf_get_extmark_by_id(self.handle, ns_id, id, opts)
    return extmark
end

function Buffer:del_extmark(ns_id, id)
    local success = api.nvim_buf_del_extmark(self.handle, ns_id, id)
    return success
end

--
-- BufferList class
--
local BufferList = setmetatable({}, {})

M.BufferList = BufferList

local bufferlist_getters = {
    handles = function(buf_list)
        local res = table.new(#buf_list, 0)
        for i, buf in buf_list do
            res[i] = buf.handle
        end
        return res
    end,
    names = function(buf_list)
        local res = table.new(#buf_list, 0)
        for i, buf in buf_list do
            res[i] = buf.name
        end
        return res
    end,
}

BufferList.__index = function(tbl, key)
    if type(key) == "number" then
        return tbl[key]
    end
    local getter = bufferlist_getters[key]
    if getter then
        return getter(tbl)
    else
    end
end


-- creates a BufferList object with given handles that
-- are not guaranteed to correspond to actual valid buffers
function BufferList:new(handles)
    local buf_list = table.new(#handles, 0)
    for i, hand in ipairs(handles) do
        buf_list[i] = Buffer:new(hand)
    end
    setmetatable(buf_list, BufferList)
    return buf_list
end

function BufferList:from_names(names)
    local bufs = table.new(#names, 0)
    for i, name in ipairs(names) do
        bufs[i] = Buffer:from_name(name)
    end
    setmetatable(bufs, BufferList)
    return bufs
end

local BufferList_mt = getmetatable(BufferList)
function BufferList_mt.__call(_, ...)
    args = {...}
    if #args == 1 and type(args[1]) == "table" then
        if type(args[1][1]) == 'number' then
            return BufferList:from_handles(args[1])
        elseif type(args[1][1]) == 'string' then
            return BufferList:from_names(args[1])
        end
    end
    error('No constructor for given arguments.')
end

function BufferList:get_property(property)
    local res = table.new(#self.handles, 0)
    for i, buf in ipairs(self) do
        res[i] = buf[property]
    end
    return res
end

function BufferList:filter(fun)
    local bufs = {}
    for i, buf in ipairs(self) do
        if fun(buf) then
            bufs[i] = self.handles[i]
        end
    end
    setmetatable(bufs, BufferList)
    return bufs
end

function BufferList:filter_by(property, value)
    local bufs = {}
    for i, buf in ipairs(self) do
        if buf[property] == value then
            bufs[i] = buf
        end
    end
    setmetatable(bufs, BufferList)
    return bufs
end

--
-- Module level functions
--
function M.list()
    local handles = api.nvim_list_bufs()
    return BufferList:from_handles(handles)
end

return M

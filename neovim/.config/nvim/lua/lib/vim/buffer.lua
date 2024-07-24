local api = vim.api

local Buffer = setmetatable({}, {})

local M = { Buffer = Buffer }

local property_getters = {
    name = function(buf)
        return api.nvim_buf_get_name(buf.handle)
    end,
    length = function(buf)
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

local property_setters = {
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

    local getter = property_getters[key]
    if getter then
        return getter(tbl)
    end
end

Buffer.__newindex = function(tbl, key, value)
    local setter = property_setters[key]
    if setter then
        setter(tbl, value)
    else
        rawset(tbl, key, value)
    end
end

-- creates a Buffer object with given handle that
-- is not guaranteed to correspond to any actual buffer
function Buffer:_new(handle)
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
    local buf = Buffer:_new(handle)
    if name then
        buf.name = name
    end
    return buf
end

-- gets an existing Buffer from it's handle
function Buffer:from_handle(handle)
    if handle == 0 then
        return Buffer:_new(0)
    end
    local existing_handles = api.nvim_list_bufs()
    for _, hand in ipairs(existing_handles) do
        if hand == handle then
            return Buffer:_new(handle)
        end
    end
end

-- Gets an existing Buffer by name or creates a new one
function Buffer:from_name(name)
    local existing_handles = api.nvim_list_bufs()
    for _, hand in ipairs(existing_handles) do
        local buf_name = api.nvim_buf_get_name(hand)
        if buf_name == name then
            return Buffer:_new(hand)
        end
    end
    local buf_new = Buffer:create(name)
    return buf_new
end

local mt = getmetatable(Buffer)
function mt.__call(_, ...)
    args = {...}
    if #args == 0 then
        return Buffer:create()
    end
    if #args == 1 then
        if type(args[1]) == "number" then
            return Buffer:from_handle(args[1])
        elseif type(args[1]) == "string" then
            return Buffer:from_name(args[1])
        end
    end
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

--
-- Extmark-related functions
--
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
-- Module level functions
--
function M.list()
    local bufs = {}
    local handles = api.nvim_list_bufs()
    for i, handle in ipairs(handles) do
        local buf = Buffer:_new(handle)
        bufs[i] = buf
    end
    return bufs
end

function M.find(opts)
    opts = opts or {}
    local bufs = {}
    local handles = api.nvim_list_bufs()
    for i, handle in ipairs(handles) do
        local buf = Buffer:_new(handle)
        bufs[i] = buf
    end
    return bufs
end

return M

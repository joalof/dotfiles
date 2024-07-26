local api = vim.api
require("table.new")

local M = {}

--- @class Buffer
--- @field handle number The handle of the buffer
--- @field name string The name of the buffer
--- @field line_count number The number of lines in the buffer (readonly)
--- @field loaded boolean Indicates if the buffer is loaded (readonly)
--- @field valid boolean Indicates if the buffer is valid (readonly)
--- @field changedtick number The changedtick of the buffer (readonly)
--- @field readonly boolean Indicates if the buffer is readonly
--- @field filetype string The filetype of the buffer (readonly)
--- @field is_file boolean Indicates if the buffer corresponds to a file (readonly)
local Buffer = setmetatable({}, {})

M.Buffer = Buffer

local Buffer_getters = {
    --- @param buf Buffer
    --- @return string
    name = function(buf)
        return api.nvim_buf_get_name(buf.handle)
    end,
    --- @param buf Buffer
    --- @return number
    line_count = function(buf)
        return api.nvim_buf_line_count(buf.handle)
    end,
    --- @param buf Buffer
    --- @return boolean
    loaded = function(buf)
        return api.nvim_buf_is_loaded(buf.handle)
    end,
    --- @param buf Buffer
    --- @return boolean
    valid = function(buf)
        return api.nvim_buf_is_valid(buf.handle)
    end,
    --- @param buf Buffer
    --- @return number
    changedtick = function(buf)
        return api.nvim_buf_get_changedtick(buf.handle)
    end,
    --- @param buf Buffer
    --- @return string
    readonly = function(buf)
        return buf:get_option("readonly")
    end,
    --- @param buf Buffer
    --- @return string
    filetype = function(buf)
        return buf:get_option("filetype")
    end,
    --- @param buf Buffer
    --- @return boolean
    is_file = function(buf)
        local Path = require("lib.path").Path
        local buf_path = Path(buf.name)
        return buf_path:is_file()
    end,
}

local Buffer_setters = {
    --- @param buf Buffer
    --- @param name string
    name = function(buf, name)
        api.nvim_buf_set_name(buf.handle, name)
    end,
    --- @param buf Buffer
    --- @param value boolean
    readonly = function(buf, value)
        buf:set_option("readonly", value)
    end,
}

Buffer.__index = function(tbl, key)
    local raw = rawget(Buffer, key)
    if raw then
        return raw
    end

    local getter = Buffer_getters[key]
    if getter then
        return getter(tbl)
    end
end

Buffer.__newindex = function(tbl, key, value)
    local setter = Buffer_setters[key]
    if setter then
        setter(tbl, value)
    else
        rawset(tbl, key, value)
    end
end

--- Creates a new Buffer instance
--- @param handle number The handle of the buffer
--- @param verify boolean Whether to verify the buffer handle
--- @return Buffer
function Buffer:new(handle, verify)
    if handle == 0 then
        handle = api.nvim_get_current_buf()
    else
        verify = verify or true
        if verify then
            if not api.nvim_buf_is_valid(handle) then
                error(string.format("Buffer with handle %d is not valid", handle))
            end
        end
    end
    local buf = {
        handle = handle,
    }
    setmetatable(buf, Buffer)
    return buf
end

--- Creates a new Buffer in neovim 
--- @param name string? Name of the new buffer
--- @param listed boolean? Name of the new buffer
--- @param scratch boolean? Name of the new buffer
--- @return Buffer
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

--- Gets an existing Buffer from it's name
--- @param name string? Name of the new buffer
--- @return Buffer
function Buffer:from_name(name)
    local existing_handles = api.nvim_list_bufs()
    for _, hand in ipairs(existing_handles) do
        local buf_name = api.nvim_buf_get_name(hand)
        if buf_name == name then
            return Buffer:new(hand, false)
        end
    end
    error(string.format("Buffer with name %s does not exist", name))
end

local Buffer_mt = getmetatable(Buffer)
function Buffer_mt.__call(_, ...)
    args = { ... }
    if #args == 1 then
        if type(args[1]) == "number" then
            return Buffer:new(args[1])
        elseif type(args[1]) == "string" then
            return Buffer:from_name(args[1])
        end
    end
    error(string.format("No constructor matching arguments"))
end

--- Gets a buffer option
--- @param opt_name string
--- @return any
function Buffer:get_option(opt_name)
    local value = api.nvim_get_option_value(opt_name, { buf = self.handle })
    return value
end

--- Gets several buffer option
--- @param opt_names table<string>
--- @return table<string, any>
function Buffer:get_options(opt_names)
    local opts = {}
    for _, name in ipairs(opt_names) do
        opts[name] = api.nvim_get_option_value(name, { buf = self.handle })
    end
    return opts
end

--- Sets a buffer option
--- @param opt_name string
--- @param value any
function Buffer:set_option(opt_name, value)
    api.nvim_set_option_value(opt_name, value, { buf = self.handle })
end

--- Sets several buffer option
--- @param opts table<string, any>
function Buffer:set_options(opts)
    for name, val in pairs(opts) do
        api.nvim_set_option_value(name, val, { buf = self.handle })
    end
end

function Buffer:write()
    -- TODO use plenary
end

function Buffer:delete(opts)
    opts = opts or {}
    api.nvim_buf_delete(self.handle, opts)
end

function Buffer:get_parent_windows()
    local wn = require("lib.vim.window")
    local wins = wn.list()
    local parents = wins:filter(function(win)
        return win.buffer.handle == self.handle
    end)
    return parents
end

function Buffer:set_lines(lines, start, stop, strict_indexing)
    start = start or 0
    stop = stop or start
    strict_indexing = strict_indexing or true
    api.nvim_buf_set_lines(self.handle, start, stop, strict_indexing, lines)
end

function Buffer:get_lines(start, stop, strict_indexing)
    start = start or 0
    stop = stop or self.line_count
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

-----------------------------------------------------------------
-- BufferList class
-----------------------------------------------------------------

--- @class BufferList : table
--- @field handles table<number> The list of buffer handles
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
    end
    local raw = rawget(BufferList, key)
    if raw then
        return raw
    end
end

--- Creates a new BufferList instance
--- @param handles table<number> The list of buffer handles
--- @return BufferList
function BufferList:new(handles)
    local buf_list = table.new(#handles, 0)
    for i, hand in ipairs(handles) do
        buf_list[i] = Buffer:new(hand)
    end
    setmetatable(buf_list, BufferList)
    return buf_list
end

--- Creates a BufferList from a list of buffer names
--- @param names table<string> The list of buffer names
--- @return BufferList
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
    args = { ... }
    if #args == 1 and type(args[1]) == "table" then
        if type(args[1][1]) == "number" then
            return BufferList:new(args[1])
        elseif type(args[1][1]) == "string" then
            return BufferList:from_names(args[1])
        end
    end
    error("No constructor for given arguments.")
end

--- Gets a property from all buffers in the list
--- @param property string The property to get
--- @return table The list of property values
function BufferList:get_property(property)
    local res = table.new(#self.handles, 0)
    for i, buf in ipairs(self) do
        res[i] = buf[property]
    end
    return res
end

--- Filters buffers in the list based on a function
--- @param fun function Filtering function, will be passed the 
--- @return BufferList The filtered list of buffers
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

--- Filters buffers in the list based on a property value
--- @param property string The property to filter by
--- @param value any The value to match
--- @return BufferList The filtered list of buffers
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

-----------------------------------------------------------------
-- Module level functions
-----------------------------------------------------------------

--- Sets the current buffer
--- @param buf Buffer|number The buffer instance or handle
function M.set_current(buf)
    local oop = require("lib.oop")
    if oop.is_instance(buf, Buffer) then
        buf = buf.handle
    end
    api.nvim_set_current_buf(buf)
end

--- Lists all buffers
--- @return BufferList The list of all buffers
function M.list()
    local handles = api.nvim_list_bufs()
    return BufferList:new(handles)
end

return M

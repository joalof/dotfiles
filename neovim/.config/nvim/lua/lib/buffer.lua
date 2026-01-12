local api = vim.api
require("table.new")

local File = require("lib.file").File

--- @class Buffer
--- @field id number The handle of the buffer
--- @field name string The name of the buffer
--- @field line_count number The number of lines in the buffer (readonly)
--- @field loaded boolean Indicates if the buffer is loaded (readonly)
--- @field valid boolean Indicates if the buffer is valid (readonly)
--- @field changedtick number The changedtick of the buffer (readonly)
--- @field readonly boolean Indicates if the buffer is readonly
--- @field filetype string The filetype of the buffer (readonly)
--- @field is_file boolean Indicates if the buffer corresponds to a file (readonly)
local Buffer = setmetatable({}, {})

local Buffer_getters = {
    --- @param buf Buffer
    --- @return string
    name = function(buf)
        return api.nvim_buf_get_name(buf.id)
    end,
    --- @param buf Buffer
    --- @return number
    line_count = function(buf)
        return api.nvim_buf_line_count(buf.id)
    end,
    --- @param buf Buffer
    --- @return boolean
    loaded = function(buf)
        return api.nvim_buf_is_loaded(buf.id)
    end,
    --- @param buf Buffer
    --- @return boolean
    valid = function(buf)
        return api.nvim_buf_is_valid(buf.id)
    end,
    --- @param buf Buffer
    --- @return number
    changedtick = function(buf)
        return api.nvim_buf_get_changedtick(buf.id)
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
        local Path = require("plenary.path")
        local buf_path = Path(buf.name)
        return buf_path:is_file()
    end,
}

local Buffer_setters = {
    --- @param buf Buffer
    --- @param name string
    name = function(buf, name)
        api.nvim_buf_set_name(buf.id, name)
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

--- Instantiates a Buffer object
--- @param id number The handle of the buffer
--- @param verify boolean? Whether to verify the buffer id, defaults to true
--- @return Buffer
function Buffer:new(id, verify)
    if id == 0 then
        id = api.nvim_get_current_buf()
    else
        verify = verify or true
        if verify then
            if not api.nvim_buf_is_valid(id) then
                error(string.format("Buffer with id %d is not valid", id))
            end
        end
    end
    local buf = {
        id = id,
    }
    setmetatable(buf, Buffer)
    return buf
end

--- Creates a new Buffer in neovim
--- @param name string? Name of the new buffer
--- @param listed boolean?
--- @param scratch boolean?
--- @return Buffer
function Buffer:create(name, listed, scratch)
    listed = listed or true
    scratch = scratch or false
    local id = api.nvim_create_buf(listed, scratch)
    local buf = Buffer:new(id, false)
    if name then
        buf.name = name
    end
    return buf
end

--- Gets an existing Buffer from it's name
--- @param name string? Name of the new buffer
--- @return Buffer
function Buffer:from_name(name)
    local existing_ids = api.nvim_list_bufs()
    for _, hand in ipairs(existing_ids) do
        local buf_name = api.nvim_buf_get_name(hand)
        if buf_name == name then
            return Buffer:new(hand, false)
        end
    end
    error(string.format("Buffer with name %s does not exist", name))
end

--- @param file string file to open
--- @return Buffer
function Buffer:from_file(file, listed, scratch)
    listed = listed or true
    scratch = scratch or false
    file = File(file)
    local lines = file:read_lines()
    local buf = Buffer:create(tostring(file.path), listed, scratch)
    buf:set_lines(lines)
    return buf
end

local Buffer_mt = getmetatable(Buffer)
function Buffer_mt.__call(_, ...)
    local args = { ... }
    if #args == 1 then
        if type(args[1]) == "number" then
            return Buffer:new(args[1])
        elseif type(args[1]) == "string" then
            return Buffer:from_name(args[1])
        end
    end
    error(string.format("No constructor matching arguments"))
end

function Buffer:__tostring()
    local s = "Buffer("
    s = s .. ("id=%s"):format(self.id)
    s = s .. (", name=%s"):format(self.name)
    s = s .. ")"
    return s
end

--- Gets a buffer option
--- @param opt_name string
--- @return any
function Buffer:get_option(opt_name)
    local value = api.nvim_get_option_value(opt_name, { buf = self.id })
    return value
end

--- Gets several buffer option
--- @param opt_names table<string>
--- @return table<string, any>
function Buffer:get_options(opt_names)
    local opts = {}
    for _, name in ipairs(opt_names) do
        opts[name] = api.nvim_get_option_value(name, { buf = self.id })
    end
    return opts
end

--- Sets a buffer option
--- @param opt_name string
--- @param value any
function Buffer:set_option(opt_name, value)
    api.nvim_set_option_value(opt_name, value, { buf = self.id })
end

--- Sets several buffer option
--- @param opts table<string, any>
function Buffer:set_options(opts)
    for name, val in pairs(opts) do
        api.nvim_set_option_value(name, val, { buf = self.id })
    end
end

function Buffer:delete(opts)
    opts = opts or {}
    api.nvim_buf_delete(self.id, opts)
end

function Buffer:set_lines(lines, start, stop, strict_indexing)
    start = start or 0
    stop = stop or (start + #lines)
    local strict = strict_indexing ~= false
    api.nvim_buf_set_lines(self.id, start, stop, strict, lines)
end


---@param start? integer 0-based, inclusive
---@param stop? integer 0-based, exclusive
---@param strict_indexing? boolean
---@return string[]
function Buffer:get_lines(start, stop, strict_indexing)
  start = start or 0
  stop = stop or self.line_count
  local strict = strict_indexing ~= false

  return api.nvim_buf_get_lines(self.id, start, stop, strict)
end


function Buffer:set_text(text, start_row, start_col, stop_row, stop_col)
    stop_row = stop_row or start_row
    stop_col = stop_col or start_col
    api.nvim_buf_set_text(self.id, start_row, start_col, stop_row, stop_col, text)
end

function Buffer:get_text(start_row, start_col, stop_row, stop_col, opts)
    opts = opts or {}
    local text = api.nvim_buf_get_text(self.id, start_row, start_col, stop_row, stop_col, opts)
    return text
end

function Buffer:get_offset(index)
    local offset = api.nvim_buf_get_offset(self.id, index)
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
    local keymaps = api.nvim_buf_get_keymap(self.id, mode)
    return keymaps
end

function Buffer:del_keymap(lhs, mode)
    mode = mode or "n"
    local opts = { buffer = self.id }
    vim.keymap.del(mode, lhs, opts)
end

function Buffer:set_var(name, value)
    api.nvim_buf_set_var(self.id, name, value)
end

function Buffer:del_var(name)
    api.nvim_buf_set_var(self.id, name)
end

function Buffer:set_mark(name, line, col, opts)
    opts = opts or {}
    local success = api.nvim_buf_set_mark(self.id, name, line, col, opts)
    return success
end

function Buffer:del_mark(name)
    local success = api.nvim_buf_del_mark(self.id, name)
    return success
end

function Buffer:attach(send_buffer, opts)
    opts = opts or {}
    local success = api.nvim_buf_attach(self.id, send_buffer, opts)
    return success
end

function Buffer:create_command(name, command, opts)
    opts = opts or {}
    api.nvim_buf_create_user_command(self.id, name, command, opts)
end

function Buffer:del_command(name)
    api.nvim_buf_del_user_command(self.id, name)
end

function Buffer:get_commands(opts)
    opts = opts or {}
    local commands = api.nvim_buf_get_commands(self.id, opts)
    return commands
end

function Buffer:call(fun)
    local res = api.nvim_buf_call(self.id, fun)
    return res
end

function Buffer:clear_namespace(ns_id, line_start, line_stop)
    line_start = line_start or 0
    line_stop = line_stop or -1
    api.nvim_buf_clear_namespace(self.id, ns_id, line_start, line_stop)
end

function Buffer:set_extmark(ns_id, line, col, opts)
    opts = opts or {}
    local id = api.nvim_buf_set_extmark(self.id, ns_id, line, col, opts)
    return id
end

function Buffer:get_extmarks(ns_id, start, stop, opts)
    opts = opts or {}
    local extmarks = api.nvim_buf_get_extmarks(self.id, ns_id, start, stop, opts)
    return extmarks
end

function Buffer:get_extmark_by_id(ns_id, id, opts)
    opts = opts or {}
    local extmark = api.nvim_buf_get_extmark_by_id(self.id, ns_id, id, opts)
    return extmark
end

function Buffer:del_extmark(ns_id, id)
    local success = api.nvim_buf_del_extmark(self.id, ns_id, id)
    return success
end

function Buffer:set_current()
    api.nvim_set_current_buf(self.id)
end

function Buffer:clear()
    self:set_lines({}, 0, -1)
end

function Buffer:write(path)
    path = tostring(path)
    local file = File(path)
    local lines = self:get_lines()
    file:write_lines(lines, "w")
end

--- Lists all buffers
--- @return table The list of all buffers
local function list_buffers()
    local ids = api.nvim_list_bufs()
    local buffers = table.new(#ids, 0)
    for i, hand in ipairs(ids) do
        buffers[i] = Buffer:new(hand, false)
    end
    return buffers
end

return { Buffer = Buffer, list_buffers = list_buffers }

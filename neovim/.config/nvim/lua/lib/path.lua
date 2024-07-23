-- Forked from plenary.nvim
-- implements additional methods and force more python-like behaviour
-- https://github.com/nvim-lua/plenary.nvim
--- Goal: Create objects that are extremely similar to Python's `Path` Objects.
--- Reference: https://docs.python.org/3/library/pathlib.html
local bit = require("plenary.bit")
local uv = vim.loop

local F = require("plenary.functional")

local S_IF = {
    -- S_IFDIR  = 0o040000  # directory
    DIR = 0x4000,
    -- S_IFREG  = 0o100000  # regular file
    REG = 0x8000,
}

local M = {}

local info = {}
info.home = vim.loop.os_homedir()

info.sep = (function()
    if jit then
        local os = string.lower(jit.os)
        if os ~= "windows" then
            return "/"
        else
            return "\\"
        end
    else
        return package.config:sub(1, 1)
    end
end)()

info.root = (function()
    if info.sep == "/" then
        return function()
            return "/"
        end
    else
        return function(base)
            base = base or vim.loop.cwd()
            return base:sub(1, 1) .. ":\\"
        end
    end
end)()

info.S_IF = S_IF

local band = function(reg, value)
    return bit.band(reg, value) == reg
end

local concat_paths = function(...)
    return table.concat({ ... }, info.sep)
end

local function is_root(pathname)
    if info.sep == "\\" then
        return string.match(pathname, "^[A-Z]:\\?$")
    end
    return pathname == "/"
end

local _split_by_separator = (function()
    local formatted = string.format("([^%s]+)", info.sep)
    return function(filepath)
        local t = {}
        for str in string.gmatch(filepath, formatted) do
            table.insert(t, str)
        end
        return t
    end
end)()

local is_uri = function(filename)
    return string.match(filename, "^%a[%w+-.]*://") ~= nil
end

local is_absolute = function(filename, sep)
    if sep == "\\" then
        return string.match(filename, "^[%a]:[\\/].*$") ~= nil
    end
    return string.sub(filename, 1, 1) == sep
end

local function _normalize_path(filename, cwd)
    if is_uri(filename) then
        return filename
    end

    -- handles redundant `./` in the middle
    local redundant = info.sep .. "%." .. info.sep
    if filename:match(redundant) then
        filename = filename:gsub(redundant, info.sep)
    end

    local out_file = filename

    local has = string.find(filename, info.sep .. "..", 1, true) or string.find(filename, ".." .. info.sep, 1, true)

    if has then
        local is_abs = is_absolute(filename, info.sep)
        local split_without_disk_name = function(filename_local)
            local parts = _split_by_separator(filename_local)
            -- Remove disk name part on Windows
            if info.sep == "\\" and is_abs then
                table.remove(parts, 1)
            end
            return parts
        end

        local parts = split_without_disk_name(filename)
        local idx = 1
        local initial_up_count = 0

        repeat
            if parts[idx] == ".." then
                if idx == 1 then
                    initial_up_count = initial_up_count + 1
                end
                table.remove(parts, idx)
                table.remove(parts, idx - 1)
                if idx > 1 then
                    idx = idx - 2
                else
                    idx = idx - 1
                end
            end
            idx = idx + 1
        until idx > #parts

        local prefix = ""
        if is_abs or #split_without_disk_name(cwd) == initial_up_count then
            prefix = info.root(filename)
        end

        out_file = prefix .. table.concat(parts, info.sep)
    end

    return out_file
end

local clean = function(pathname)
    if is_uri(pathname) then
        return pathname
    end

    -- Remove double path seps, it's annoying
    pathname = pathname:gsub(info.sep .. info.sep, info.sep)

    -- Remove trailing path sep if not root
    if not is_root(pathname) and pathname:sub(-1) == info.sep then
        return pathname:sub(1, -2)
    end
    return pathname
end

local function make_absolute(p)
    if p:is_absolute() then
        return _normalize_path(p.filename, p._cwd)
    else
        return _normalize_path(p._absolute or table.concat({ p._cwd, p.filename }, info.sep), p._cwd)
    end
end

-- S_IFCHR  = 0o020000  # character device
-- S_IFBLK  = 0o060000  # block device
-- S_IFIFO  = 0o010000  # fifo (named pipe)
-- S_IFLNK  = 0o120000  # symbolic link
-- S_IFSOCK = 0o140000  # socket file

---@class Path
local Path = {
    info = info,
}

Path.__index = function(t, k)
    local raw = rawget(Path, k)
    if raw then
        return raw
    end

    if k == "_cwd" then
        local cwd = uv.fs_realpath(".")
        t._cwd = cwd
        return cwd
    end

    if k == "_absolute" then
        local absolute = uv.fs_realpath(t.filename)
        t._absolute = absolute
        return absolute
    end
end

Path.__div = function(self, other)
    return self:joinpath(other)
end

Path.__tostring = function(self)
    return clean(self.filename)
end

Path.is_path = function(a)
    return getmetatable(a) == Path
end

function Path:new(...)
    local args = { ... }

    if type(self) == "string" then
        table.insert(args, 1, self)
        self = Path -- luacheck: ignore
    end

    local path_input
    if #args == 1 then
        path_input = args[1]
    else
        path_input = args
    end

    -- If we already have a Path, it's fine.
    --   Just return it
    if Path.is_path(path_input) then
        return path_input
    end

    -- TODO: Should probably remove and dumb stuff like double seps, periods in the middle, etc.
    local sep = info.sep
    if type(path_input) == "table" then
        sep = path_input.sep or info.sep
        path_input.sep = nil
    end

    local path_string
    if type(path_input) == "table" then
        -- TODO: It's possible this could be done more elegantly with __concat
        --       But I'm unsure of what we'd do to make that happen
        local path_objs = {}
        for _, v in ipairs(path_input) do
            if Path.is_path(v) then
                table.insert(path_objs, v.filename)
            else
                assert(type(v) == "string")
                table.insert(path_objs, v)
            end
        end

        path_string = table.concat(path_objs, sep)
    else
        assert(type(path_input) == "string", vim.inspect(path_input))
        path_string = path_input
    end

    local obj = {
        filename = path_string,
    }

    setmetatable(obj, Path)

    return obj
end

-- Let's us avoid new(), just call Path(...)
local mt = {}
setmetatable(Path, mt)

function mt.__call(...)
    return Path.new(...)
end

function Path:_fs_filename()
    return make_absolute(self) or self.filename
end

function Path:_stat()
    return uv.fs_stat(self:_fs_filename()) or {}
end

function Path:_st_mode()
    return self:_stat().mode or 0
end

function Path:joinpath(...)
    return Path:new(self.filename, ...)
end

function Path:absolute()
    return Path(make_absolute(self))
end

function Path:exists()
    return not vim.tbl_isempty(self:_stat())
end

function Path:expand()
    if is_uri(self.filename) then
        return self.filename
    end

    -- TODO support windows
    local expanded
    if string.find(self.filename, "~") then
        expanded = string.gsub(self.filename, "^~", vim.loop.os_homedir())
    elseif string.find(self.filename, "^%.") then
        expanded = vim.loop.fs_realpath(self.filename)
        if expanded == nil then
            expanded = vim.fn.fnamemodify(self.filename, ":p")
        end
    elseif string.find(self.filename, "%$") then
        local rep = string.match(self.filename, "([^%$][^/]*)")
        local val = os.getenv(rep)
        if val then
            expanded = string.gsub(string.gsub(self.filename, rep, val), "%$", "")
        else
            expanded = nil
        end
    else
        expanded = self.filename
    end
    return expanded and expanded or error("Path not valid")
end

function Path:make_relative(cwd)
    if is_uri(self.filename) then
        return self.filename
    end

    self.filename = clean(self.filename)
    cwd = clean(F.if_nil(cwd, self._cwd, cwd))
    if self.filename == cwd then
        self.filename = "."
    else
        if cwd:sub(#cwd, #cwd) ~= info.sep then
            cwd = cwd .. info.sep
        end

        if self.filename:sub(1, #cwd) == cwd then
            self.filename = self.filename:sub(#cwd + 1, -1)
        end
    end

    return Path(self.filename)
end

function Path:normalize(cwd)
    if is_uri(self.filename) then
        return self.filename
    end

    self:make_relative(cwd)

    -- Substitute home directory w/ "~"
    -- string.gsub is not useful here because usernames with dashes at the end
    -- will be seen as a regexp pattern rather than a raw string
    local home = info.home
    if string.sub(info.home, -1) ~= info.sep then
        home = home .. info.sep
    end
    local start, finish = string.find(self.filename, home, 1, true)
    if start == 1 then
        self.filename = "~" .. info.sep .. string.sub(self.filename, (finish + 1), -1)
    end

    return Path(_normalize_path(clean(self.filename), self._cwd))
end

local function shorten_len(filename, len, exclude)
    len = len or 1
    exclude = exclude or { -1 }
    local exc = {}

    -- get parts in a table
    local parts = {}
    local empty_pos = {}
    for m in (filename .. info.sep):gmatch("(.-)" .. info.sep) do
        if m ~= "" then
            parts[#parts + 1] = m
        else
            table.insert(empty_pos, #parts + 1)
        end
    end

    for _, v in pairs(exclude) do
        if v < 0 then
            exc[v + #parts + 1] = true
        else
            exc[v] = true
        end
    end

    local final_path_components = {}
    local count = 1
    for _, match in ipairs(parts) do
        if not exc[count] and #match > len then
            table.insert(final_path_components, string.sub(match, 1, len))
        else
            table.insert(final_path_components, match)
        end
        table.insert(final_path_components, info.sep)
        count = count + 1
    end

    local l = #final_path_components -- so that we don't need to keep calculating length
    table.remove(final_path_components, l) -- remove final slash

    -- add back empty positions
    for i = #empty_pos, 1, -1 do
        table.insert(final_path_components, empty_pos[i], info.sep)
    end

    return table.concat(final_path_components)
end

local shorten = (function()
    local fallback = function(filename)
        return shorten_len(filename, 1)
    end

    if jit and info.sep ~= "\\" then
        local ffi = require("ffi")
        ffi.cdef([[
    typedef unsigned char char_u;
    void shorten_dir(char_u *str);
    ]])
        local ffi_func = function(filename)
            if not filename or is_uri(filename) then
                return filename
            end

            local c_str = ffi.new("char[?]", #filename + 1)
            ffi.copy(c_str, filename)
            ffi.C.shorten_dir(c_str)
            return ffi.string(c_str)
        end
        local ok = pcall(ffi_func, "/tmp/path/file.lua")
        if ok then
            return ffi_func
        else
            return fallback
        end
    end
    return fallback
end)()

function Path:shorten(len, exclude)
    assert(len ~= 0, "len must be at least 1")
    if (len and len > 1) or exclude ~= nil then
        return shorten_len(self.filename, len, exclude)
    end
    return shorten(self.filename)
end

function Path:mkdir(opts)
    opts = opts or {}

    local mode = opts.mode or 448 -- 0700 -> decimal
    local parents = F.if_nil(opts.parents, false, opts.parents)
    local exists_ok = F.if_nil(opts.exists_ok, true, opts.exists_ok)

    local exists = self:exists()
    if not exists_ok and exists then
        error("FileExistsError:" .. make_absolute(self))
    end

    -- fs_mkdir returns nil if folder exists
    if not uv.fs_mkdir(self:_fs_filename(), mode) and not exists then
        if parents then
            local dirs = self:parts()
            local processed = ""
            for _, dir in ipairs(dirs) do
                if dir ~= "" then
                    local joined = concat_paths(processed, dir)
                    if processed == "" and info.sep == "\\" then
                        joined = dir
                    end
                    local stat = uv.fs_stat(joined) or {}
                    local file_mode = stat.mode or 0
                    if band(S_IF.REG, file_mode) then
                        error(string.format("%s is a regular file so we can't mkdir it", joined))
                    elseif band(S_IF.DIR, file_mode) then
                        processed = joined
                    else
                        if uv.fs_mkdir(joined, mode) then
                            processed = joined
                        else
                            error("We couldn't mkdir: " .. joined)
                        end
                    end
                end
            end
        else
            error("FileNotFoundError")
        end
    end

    return true
end

function Path:rmdir()
    if not self:exists() then
        return
    end

    uv.fs_rmdir(make_absolute(self))
end

function Path:rename(opts)
    opts = opts or {}
    if not opts.new_name or opts.new_name == "" then
        error("Please provide the new name!")
    end

    -- handles `.`, `..`, `./`, and `../`
    if opts.new_name:match("^%.%.?/?\\?.+") then
        opts.new_name = {
            uv.fs_realpath(opts.new_name:sub(1, 3)),
            opts.new_name:sub(4, #opts.new_name),
        }
    end

    local new_path = Path:new(opts.new_name)

    if new_path:exists() then
        error("File or directory already exists!")
    end

    local status = uv.fs_rename(make_absolute(self), new_path:absolute().filename)
    self.filename = new_path.filename

    return status
end

--- Copy files or folders with defaults akin to GNU's `cp`.
---@param opts table: options to pass to toggling registered actions
---@field destination string|Path: target file path to copy to
---@field recursive bool: whether to copy folders recursively (default: false)
---@field override bool: whether to override files (default: true)
---@field interactive bool: confirm if copy would override; precedes `override` (default: false)
---@field respect_gitignore bool: skip folders ignored by all detected `gitignore`s (default: false)
---@field hidden bool: whether to add hidden files in recursively copying folders (default: true)
---@field parents bool: whether to create possibly non-existing parent dirs of `opts.destination` (default: false)
---@field exists_ok bool: whether ok if `opts.destination` exists, if so folders are merged (default: true)
---@return table {[Path of destination]: bool} indicating success of copy; nested tablex constitute sub dirs
function Path:copy(opts)
    opts = opts or {}
    opts.recursive = F.if_nil(opts.recursive, false, opts.recursive)
    opts.override = F.if_nil(opts.override, true, opts.override)

    local dest = opts.destination
    -- handles `.`, `..`, `./`, and `../`
    if not Path.is_path(dest) then
        if type(dest) == "string" and dest:match("^%.%.?/?\\?.+") then
            dest = {
                uv.fs_realpath(dest:sub(1, 3)),
                dest:sub(4, #dest),
            }
        end
        dest = Path:new(dest)
    end
    -- success is true in case file is copied, false otherwise
    local success = {}
    if not self:is_dir() then
        if opts.interactive and dest:exists() then
            vim.ui.select(
                { "Yes", "No" },
                { prompt = string.format("Overwrite existing %s?", dest:absolute().filename) },
                function(_, idx)
                    success[dest] = uv.fs_copyfile(self:absolute(), dest:absolute().filename, { excl = idx ~= 1 })
                        or false
                end
            )
        else
            -- nil: not overriden if `override = false`
            success[dest] = uv.fs_copyfile(make_absolute(self), make_absolute(dest), { excl = not opts.override })
                or false
        end
        return success
    end
    -- dir
    if opts.recursive then
        dest:mkdir({
            parents = F.if_nil(opts.parents, false, opts.parents),
            exists_ok = F.if_nil(opts.exists_ok, true, opts.exists_ok),
        })
        local scan = require("plenary.scandir")
        local data = scan.scan_dir(self.filename, {
            respect_gitignore = F.if_nil(opts.respect_gitignore, false, opts.respect_gitignore),
            hidden = F.if_nil(opts.hidden, true, opts.hidden),
            depth = 1,
            add_dirs = true,
        })
        for _, entry in ipairs(data) do
            local entry_path = Path:new(entry)
            local suffix = table.remove(entry_path:_split())
            local new_dest = dest:joinpath(suffix)
            -- clear destination as it might be Path table otherwise failing w/ extend
            opts.destination = nil
            local new_opts = vim.tbl_deep_extend("force", opts, { destination = new_dest })
            -- nil: not overriden if `override = false`
            success[new_dest] = entry_path:copy(new_opts) or false
        end
        return success
    else
        error(string.format("Warning: %s was not copied as `recursive=false`", make_absolute(self)))
    end
end

function Path:rm(opts)
    opts = opts or {}

    local recursive = F.if_nil(opts.recursive, false, opts.recursive)
    if recursive then
        local scan = require("plenary.scandir")
        local abs = make_absolute(self)

        -- first unlink all files
        scan.scan_dir(abs, {
            hidden = true,
            on_insert = function(file)
                uv.fs_unlink(file)
            end,
        })

        local dirs = scan.scan_dir(abs, { add_dirs = true, hidden = true })
        -- iterate backwards to clean up remaining dirs
        for i = #dirs, 1, -1 do
            uv.fs_rmdir(dirs[i])
        end

        -- now only abs is missing
        uv.fs_rmdir(abs)
    else
        uv.fs_unlink(make_absolute(self))
    end
end

-- Path:is_* {{{
function Path:is_dir()
    -- TODO: I wonder when this would be better, if ever.
    -- return self:_stat().type == 'directory'

    return band(S_IF.DIR, self:_st_mode())
end

function Path:is_absolute()
    return is_absolute(self.filename, info.sep)
end
-- }}}

function Path:parts()
    return vim.split(make_absolute(self), info.sep)
end

local _get_parent = (function()
    local formatted = string.format("^(.+)%s[^%s]+", info.sep, info.sep)
    return function(abs_path)
        local parent = abs_path:match(formatted)
        if parent ~= nil and not parent:find(info.sep) then
            return parent .. info.sep
        end
        return parent
    end
end)()

function Path:parent()
    return Path:new(_get_parent(make_absolute(self)) or info.root(make_absolute(self)))
end

function Path:parents()
    local results = {}
    local cur = make_absolute(self)
    repeat
        cur = _get_parent(cur)
        table.insert(results, Path:new(cur))
    until not cur
    table.insert(results, info.root(make_absolute(self)))
    return results
end

function Path:is_file()
    return self:_stat().type == "file" and true or nil
end

function Path:find_upwards(filename)
    local folder = Path:new(self)
    local root = info.root(folder)

    while folder:absolute().filename ~= root do
        local p = folder:joinpath(filename)
        if p:exists() then
            return p
        end
        folder = folder:parent()
    end
    return ""
end

function Path:name()
    local name = self.filename:match("/([^/]+)$")
    return name
end

function Path:home()
    return Path:new(info.home)
end

function Path:cwd()
    return Path:new(vim.uv.cwd())
end

function Path:iterdir() end

M.Path = Path

return M

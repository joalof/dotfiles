local uv = vim.uv

local Path = require("lib.path").Path

local function if_nil(val, was_nil, was_not_nil)
    if val == nil then
        return was_nil
    else
        return was_not_nil
    end
end

local File = setmetatable({}, {})

File.__index = File

function File:new(path)
    local file = { path = Path(path) }
    setmetatable(file, File)
    return file
end

local File_mt = getmetatable(File)
function File_mt.__call(_, ...)
    args = { ... }
    if #args == 1 then
        local name = tostring(args[1])
        return File:new(name)
    end
    error(string.format("No constructor matching arguments"))
end

function File.__tostring(self)
    return tostring(self.path)
end

function File:touch(opts)
    opts = opts or {}
    local path = self.path

    local mode = opts.mode or 420
    local parents = if_nil(opts.parents, false, opts.parents)

    if self:exists() then
        local new_time = os.time()
        uv.fs_utime(path:_fs_filename(), new_time, new_time)
        return
    end

    if parents then
        File:new(self:parent()):mkdir({ parents = true })
    end

    local fd = uv.fs_open(path:_fs_filename(), "w", mode)
    if not fd then
        error("Could not create file: " .. path:_fs_filename())
    end
    uv.fs_close(fd)

    return true
end

function File:write(txt, flag, mode)
    assert(flag, [[Path:write_text requires a flag! For example: 'w' or 'a']])

    mode = mode or 438

    local fd = assert(uv.fs_open(self.path:_fs_filename(), flag, mode))
    assert(uv.fs_write(fd, txt, -1))
    assert(uv.fs_close(fd))
end

function File:write_lines(lines, flag, mode)
    local text = require('lib.stringx').join('\n', lines)
    self:write(text, flag, mode)
end


-- TODO: Asyncify this and use vim.wait in the meantime.
--  This will allow other events to happen while we're waiting!
function File:_read()
    local fd = assert(uv.fs_open(self.path:_fs_filename(), "r", 438)) -- for some reason test won't pass with absolute
    local stat = assert(uv.fs_fstat(fd))
    local data = assert(uv.fs_read(fd, stat.size, 0))
    assert(uv.fs_close(fd))

    return data
end

function File:_read_async(callback)
    vim.uv.fs_open(self.filename, "r", 438, function(err_open, fd)
        if err_open then
            print("We tried to open this file but couldn't. We failed with following error message: " .. err_open)
            return
        end
        vim.uv.fs_fstat(fd, function(err_fstat, stat)
            assert(not err_fstat, err_fstat)
            if stat.type ~= "file" then
                return callback("")
            end
            vim.uv.fs_read(fd, stat.size, 0, function(err_read, data)
                assert(not err_read, err_read)
                vim.uv.fs_close(fd, function(err_close)
                    assert(not err_close, err_close)
                    return callback(data)
                end)
            end)
        end)
    end)
end

function File:read(callback)
    if callback then
        return self:_read_async(callback)
    end
    return self:_read()
end

function File:head(num_lines)
    num_lines = num_lines or 10
    local chunk_size = 256

    local fd = uv.fs_open(self.path:_fs_filename(), "r", 438)
    if not fd then
        return
    end
    local stat = assert(uv.fs_fstat(fd))
    if stat.type ~= "file" then
        uv.fs_close(fd)
        return nil
    end

    local data = ""
    local index, count = 0, 0
    while count < num_lines and index < stat.size do
        local read_chunk = assert(uv.fs_read(fd, chunk_size, index))

        local i = 0
        for char in read_chunk:gmatch(".") do
            if char == "\n" then
                count = count + 1
                if count >= num_lines then
                    break
                end
            end
            index = index + 1
            i = i + 1
        end
        data = data .. read_chunk:sub(1, i)
    end
    assert(uv.fs_close(fd))

    -- Remove potential newline at end of file
    if data:sub(-1) == "\n" then
        data = data:sub(1, -2)
    end

    return data
end

function File:tail(num_lines)
    num_lines = num_lines or 10
    local chunk_size = 256

    local fd = uv.fs_open(self.path:_fs_filename(), "r", 438)
    if not fd then
        return
    end
    local stat = assert(uv.fs_fstat(fd))
    if stat.type ~= "file" then
        uv.fs_close(fd)
        return nil
    end

    local data = ""
    local index, count = stat.size - 1, 0
    while count < num_lines and index > 0 do
        local real_index = index - chunk_size
        if real_index < 0 then
            chunk_size = chunk_size + real_index
            real_index = 0
        end

        local read_chunk = assert(uv.fs_read(fd, chunk_size, real_index))

        local i = #read_chunk
        while i > 0 do
            local char = read_chunk:sub(i, i)
            if char == "\n" then
                count = count + 1
                if count >= num_lines then
                    break
                end
            end
            index = index - 1
            i = i - 1
        end
        data = read_chunk:sub(i + 1, #read_chunk) .. data
    end
    assert(uv.fs_close(fd))

    return data
end

function File:read_lines()
    local data = self:read()

    data = data:gsub("\r", "")
    return vim.split(data, "\n")
end

function File:iter()
    local data = self:readlines()
    local i = 0
    local n = #data
    return function()
        i = i + 1
        if i <= n then
            return data[i]
        end
    end
end

function File:readbyterange(offset, length)
    local fd = uv.fs_open(self.path:_fs_filename(), "r", 438)
    if not fd then
        return
    end
    local stat = assert(uv.fs_fstat(fd))
    if stat.type ~= "file" then
        uv.fs_close(fd)
        return nil
    end

    if offset < 0 then
        offset = stat.size + offset
        -- Windows fails if offset is < 0 even though offset is defined as signed
        -- http://docs.libuv.org/en/v1.x/fs.html#c.uv_fs_read
        if offset < 0 then
            offset = 0
        end
    end

    local data = ""
    while #data < length do
        local read_chunk = assert(uv.fs_read(fd, length - #data, offset))
        if #read_chunk == 0 then
            break
        end
        data = data .. read_chunk
        offset = offset + #read_chunk
    end

    assert(uv.fs_close(fd))

    return data
end

M = { File = File }

return M

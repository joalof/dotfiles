local M = {}

-- useful functions from https://github.com/mobily/.nvim/blob/main/lua/utils/fn.lua
M.pack = table.pack or function(...)
  return { n = select("#", ...), ... }
end

M.unpack = M.unpack or unpack

function M.kpairs(t)
    local index
    return function()
        local value
        while true do
            index, value = next(t, index)
            if type(index) ~= "number" or math.floor(index) ~= index then
                break
            end
        end
        return index, value
    end
end

function M.ireduce(tbl, func, acc)
    for i, v in ipairs(tbl) do
        acc = func(acc, v, i)
    end
    return acc
end

function M.kreduce(tbl, func, acc)
    for i, v in pairs(tbl) do
        if type(i) == "string" then
            acc = func(acc, v, i)
        end
    end
    return acc
end

function M.reduce(tbl, func, acc)
    for i, v in pairs(tbl) do
        acc = func(acc, v, i)
    end
    return acc
end

function M.find_index(tbl, func)
    for index, item in ipairs(tbl) do
        if func(item, index) then
            return index
        end
    end

    return nil
end

function M.isome(tbl, func)
    for index, item in ipairs(tbl) do
        if func(item, index) then
            return true
        end
    end

    return false
end

function M.ifind(tbl, func)
    for index, item in ipairs(tbl) do
        if func(item, index) then
            return item
        end
    end

    return nil
end

function M.find_last_index(tbl, func)
    for index = #tbl, 1, -1 do
        if func(tbl[index], index) then
            return index
        end
    end
end

function M.slice(tbl, i_start, i_stop)
    local sliced = {}
    i_stop = i_stop or #tbl
    for index = i_start, i_stop do
        table.insert(sliced, tbl[index])
    end
    return sliced
end

function M.merge(...)
    local merged = {}

    for _, tbl in ipairs({ ... }) do
        for _, value in ipairs(tbl) do
            table.insert(merged, value)
        end
    end

    return merged
end

function M.kmap(tbl, func)
    return M.kreduce(tbl, function(new_tbl, value, key)
        table.insert(new_tbl, func(value, key))
        return new_tbl
    end, {})
end

function M.imap(tbl, func)
    return M.ireduce(tbl, function(new_tbl, value, index)
        table.insert(new_tbl, func(value, index))
        return new_tbl
    end, {})
end

function M.ieach(tbl, func)
    for index, element in ipairs(tbl) do
        func(element, index)
    end
end

function M.keach(tbl, func)
    for key, element in M.kpairs(tbl) do
        func(element, key)
    end
end

function M.keys(tbl)
    local keys = {}
    for key, _ in M.kpairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end

function M.indices(tbl)
    local inds = {}
    for key, _ in ipairs(tbl) do
        table.insert(inds, key)
    end
    return inds
end


function M.ifilter(tbl, pred_fn)
    return M.ireduce(tbl, function(new_tbl, value, index)
        if pred_fn(value, index) then
            table.insert(new_tbl, value)
        end
        return new_tbl
    end, {})
end

function M.ireject(tbl, pred_fn)
    return M.ifilter(tbl, function(value, index)
        return not pred_fn(value, index)
    end)
end

function M.kfilter(tbl, pred_fn)
    return M.kreduce(tbl, function(new_tbl, value, key)
        if pred_fn(value, key) then
            new_tbl[key] = value
        end
        return new_tbl
    end, {})
end

function M.kreject(tbl, pred_fn)
    return M.kfilter(tbl, function(value, index)
        return not pred_fn(value, index)
    end)
end

return M

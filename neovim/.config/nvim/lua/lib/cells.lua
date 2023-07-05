local ft = require('Comment.ft')

-- @module cells
local cells = {}

cells.cell_delimiter = '%%'
cells.cell_sep = '─'

function cells.setup(cell_delimiter)
    cells.cell_delimiter = cell_delimiter
end

-- Gets the valid comment delimiters (line and block) for the current filetype
function cells.get_comment_delimiters()
    local cmtstr_line = ft.get(vim.bo.filetype)[1]
    local cmtstr_block = ft.get(vim.bo.filetype)[2]
    local delims = {}
    -- delims.line = string_split(cmtstr_line, '%s')
    delims.line = vim.split(cmtstr_line, '%s', {plain=true})
    if cmtstr_block then
        delims.block = vim.split(cmtstr_block, '%s', {plain=true})
    end
   return delims
end

function cells.create_cell_regex()
    local cmt = cells.get_comment_delimiters()
    local cell = cells.cell_delimiter

    -- Regexes
    -- Let d1, d2 denote escaped comment delimiters and c the escaped cell delimiter,
    -- then the basic regex is: ^d1\s*c  and if d2 exists we add .*d2\s*$
    -- Here we define one such regex for line comments (rl) and one for block comments
    -- (rb) and put them together: (rl|rb). Note that in the code we actually use
    -- vim's non-magic mode so all non-alpha characters have to be escaped.
    local regex = [[\V\^]] .. cmt.line[1] .. [[\s\*]] .. cell
    if cmt.line[2] ~= '' then
        regex = regex .. [[\.\*]] .. cmt.line[2] .. [[\s\*\$]]
    end

    if cmt.block and cmt.block ~= cmt.line then
        local regex_b = [[\V\^]] .. cmt.block[1] .. [[\s\*]] .. cell
        regex_b = regex_b .. [[\.\*]] .. cmt.block[2] .. [[\s\*\$]]
        regex = [[\(]] .. regex .. [[\|]] .. regex_b .. [[\)]]
    end

    return regex
end

function cells.find_previous_delimiter(move_cursor, current_line_ok, cell_regex)
    local search_flags = 'Wb'
    search_flags = move_cursor and search_flags or search_flags .. 'n'
    search_flags = search_flags .. (current_line_ok and 'c' or 'z')
    cell_regex = cell_regex or cells.create_cell_regex()

    -- find previous cell delim
    local line = vim.fn.search(cell_regex, search_flags, 1)
    local pos_new = {line, 0}
    if line == 0 then
        pos_new = nil
    end
    return pos_new
end

function cells.find_next_delimiter(move_cursor, match_current_line, cell_regex)
    local search_flags = 'W'
    search_flags = move_cursor and search_flags or search_flags .. 'n'
    search_flags = match_current_line and search_flags .. 'c' or search_flags
    cell_regex = cell_regex or cells.create_cell_regex()

    -- move cursor to starting position for forward search
    local pos_old = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, {pos_old[1], 0})

    -- move to next cell delim
    local to_line = vim.fn.search(cell_regex, search_flags)
    local pos_new = {to_line, 0}
    if to_line == 0 or move_cursor == false then
        vim.api.nvim_win_set_cursor(0, pos_old)
    end
    if to_line == 0 then
        return nil
    else
        return pos_new
    end
end

-- Moves the cursor to the first line of the previous cell.
function cells.cursor_to_previous_cell()
    local cell_regex = cells.create_cell_regex()

    -- first backward search: accept match at current line after this
    -- we are guaranteed to be at the delimiter of the current cell
    local pos_new = cells.find_previous_delimiter(true, true, cell_regex)
    if pos_new then
        vim.api.nvim_win_set_cursor(0, pos_new)
        
        -- second backward search: takes us to the delimiter of the previous cell 
        pos_new = cells.find_previous_delimiter(true, false, cell_regex)
        if pos_new then
            pos_new[1] = pos_new[1] + 1
            vim.api.nvim_win_set_cursor(0, pos_new)
            return pos_new
        end
    end

    -- If one or both backward searches failed: go back to the start.
    pos_new = {1, 0}
    vim.api.nvim_win_set_cursor(0, pos_new)
    return pos_new
end

-- Moves the cursor to the first line of the next cell.
function cells.cursor_to_next_cell()
    local cell_regex = cells.create_cell_regex()

    local pos_new = cells.find_next_delimiter(false, false, cell_regex)
    if pos_new then
        pos_new[1] = pos_new[1] + 1
        vim.api.nvim_win_set_cursor(0, pos_new)
    end
    return pos_new
end

-- Find the region that corresponds to the nearest cell
-- ai_type: 'i' or 'a' for inner or around
function cells.get_cell_region(ai_type)
    local cell_regex = cells.create_cell_regex()
    local pos_old = vim.api.nvim_win_get_cursor(0)
    
    -- move cursor to starting position for backward search
    vim.api.nvim_win_set_cursor(0, {pos_old[1], vim.fn.col('$')})

    -- find previous cell delim or BOF, don't move cursor
    local from_line = vim.fn.search(cell_regex, 'ncWb', 1) + 1
    if from_line > 1 and ai_type == 'a' then
        from_line = from_line - 1
    end

    -- find next cell delim or EOF, move cursor
    local nlines = vim.api.nvim_buf_line_count(0)
    local to_line = vim.fn.search(cell_regex, 'W', nlines)
    to_line = to_line == 0 and nlines or to_line - 1
    vim.api.nvim_win_set_cursor(0, {to_line, 0})
    
    -- define the region and move cursor back
    local from = {line = from_line, col = 1}
    local to = {line = to_line, col = vim.fn.col('$')}
    vim.api.nvim_win_set_cursor(0, pos_old)
    return {from = from, to = to}
end

-- Draws cell borders as virtual text using nvim's extmark functionality
function cells.draw_borders()

    local cell_regex = cells.create_cell_regex()
    -- local buffer = vim.fn.bufnr('%')
    local buffer = 0
    local ns_id = vim.api.nvim_create_namespace('cells')

    local extmarks = vim.api.nvim_buf_get_extmarks(buffer, ns_id, 0, -1, {})

    -- For each border: map line -> state := {id, delete},
    -- where the delete-flag indicates that the border should be deleted,
    -- this is initally set to true for all borders and later flipped if 
    -- a cell delimiter still exists at the line.
    local borders = {}
    for _, ext_tuple in ipairs(extmarks) do
        local id, line = unpack(ext_tuple)
        borders[line] = {id=id, delete=true}
    end

    local opts = {
        virt_text = {{'' , "Comment"}},
        virt_text_pos = 'eol',
        strict = false,
    }
 
    -- Start from BOF and look for existing cell delimiters, the first
    -- time we call find_next_delimiter() we have to accept a match
    -- at the current line in case file starts with a cell delimiter.
    local pos_old = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, {1, 0})
    local match_current_line = true
    while true do
        local pos_next = cells.find_next_delimiter(true, match_current_line, cell_regex)
        if not pos_next then
            -- no more delimiters, delete old borders not marked for saving
            for _, state in pairs(borders) do
                if state.delete then
                    vim.api.nvim_buf_del_extmark(buffer, ns_id, state.id)
                end
            end
            vim.api.nvim_win_set_cursor(0, pos_old)
            return
        else  -- delimiter found
            match_current_line = false
            local line = pos_next[1]
            if not borders[line] then  -- draw new border
                opts.id = line
                local win_width = vim.api.nvim_win_get_width(0)
                local num_sep = win_width - vim.fn.col('$')
                opts.virt_text[1][1] = string.rep(cells.cell_sep, num_sep)
                vim.api.nvim_buf_set_extmark(buffer, ns_id, line - 1, 0, opts)
            else  -- save existing border
                borders[line].delete = false
            end
        end
    end
end

return cells

local Color = require("lib.color")

local M = {}

-- define colors
local norm_fg = Color.from_hl("Normal", "fg")
local norm_fg_dark = norm_fg:shade(-0.55)
local norm_bg = Color.from_hl("Normal", "bg")
local norm_bg_dark = norm_bg:shade(-0.5)
norm_fg = norm_fg:to_css()
norm_fg_dark = norm_fg_dark:to_css()
norm_bg = norm_bg:to_css()
norm_bg_dark = norm_bg_dark:to_css()

M.hls = {
    fill = {
        fg = norm_fg_dark,
        bg = norm_bg_dark,
    },
    wedge = {
        fg = norm_bg_dark,
        bg = norm_bg,
    },
    text = {
        fg_active = norm_fg,
        fg_inactive = norm_fg_dark,
        bg = norm_bg,
    },
}

local function create_pane(f, filename, active)
    f.add({ "", fg = M.hls.wedge.fg, bg = M.hls.wedge.bg })
    if filename then
        f.add({ f.icon(filename) .. " ", fg = f.icon_color(filename), bg = M.hls.text.bg })
        local text_fg = M.hls.text.fg_inactive
        if active  then
            text_fg = M.hls.text.fg_active
        end
        f.add({ vim.fn.fnamemodify(filename, ":t"), fg = text_fg, bg = M.hls.text.bg })
    end
    f.add({ "", fg = M.hls.wedge.fg, bg = M.hls.wedge.bg })
end


-- local function get_harpoon_list()
--     local harpoon = require("harpoon")
--     local harpoon_list = harpoon:list()
--     return harpoon_list
-- end

M.display_marks = {}

-- cache marks for display with tabline
function M.cache_display_marks(list_name)
    local harp_list = require('harpoon'):list(list_name)
    -- only use filenames and not the full path 
    M.display_marks = harp_list.items
    -- M.display_marks = {}
    -- for i, item in ipairs(harp_list.items) do
    --     M.display_marks[i] = Path(item):name()
    -- end
end


-- This will be called a million times so be careful
M.render = function(f)

    -- local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
    local curr_file = vim.fn.expand('%:p')

    -- local found = false
    -- for _, item in ipairs(items) do
    --     if current_file == item.filename then
    --         found = true
    --         break
    --     end
    -- end

    -- if current file is not a mark add it
    -- if not found then
    --     create_pane(f, current_file, true)
    -- end

    -- add all marks
    -- for _, item in ipairs(harp_list.items) do
    --     local active = curr_file == item.value
    --     create_pane(f, item.value, active)
    -- end

    -- add all marks
    for _, item in ipairs(M.display_marks) do
        local active = curr_file == item.value
        create_pane(f, item.value, active)
    end
    --
    f.add_spacer()
    --
    -- f.make_tabs(function(info)
    --     f.add({ "", fg = colors_tmp.black, bg = colors_tmp.bg_sel })
    --     f.add({ " " .. info.index .. " ", fg = info.current and colors_tmp.white or nil })
    --     f.add({ "", bg = colors_tmp.bg_sel, fg = colors_tmp.black })
    -- end )
end

M.toggle_tabline = function()
    if #M.display_marks > 0 then
        vim.o.showtabline = 2
    else
        vim.o.showtabline = 0
    end
end

return M

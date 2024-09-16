local Color = require("lib.color")

local M = {}

-- define highlights for the tabline
local norm_fg = Color.from_hl("Normal", "fg")
local norm_fg_dark = norm_fg:shade(-0.55)
local norm_bg = Color.from_hl("Normal", "bg")
local norm_bg_dark = norm_bg:shade(-0.35)
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

local function create_pane(f, name, active)
    local hls = M.hls
    f.add({ "", fg = hls.wedge.fg, bg = hls.wedge.bg })
    if name then
        f.add({ f.icon(name) .. " ", fg = f.icon_color(name), bg = hls.text.bg })
        local text_fg = hls.text.fg_inactive
        if active then
            text_fg = hls.text.fg_active
        end
        -- f.add({ vim.fn.fnamemodify(filename, ":t"), fg = text_fg, bg = M.hls.text.bg })
        f.add({ name, fg = text_fg, bg = hls.text.bg })
    end
    f.add({ "", fg = hls.wedge.fg, bg = hls.wedge.bg })
end

M.tags = {}

-- cache tags for display with tabline
-- this will not be called frequently
-- function M.cache_display_tags()
-- local harp_list = require("harpoon"):list(list_name)
-- M.display_tags = harp_list.items
-- only use filenames and not the full path
-- M.display_tags = {}
-- for i, item in ipairs(harp_list.items) do
--     M.display_tags[i] = Path(item.value):name()
-- end
-- end


local grapple = require('grapple')

-- This will be called a million times so we don't do expensive stuff here
M.render = function(f)
    local curr_file = vim.fn.expand("%:t")

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

    -- add all tags
    local tags = grapple.tags()
    for _, tag in ipairs(tags) do
        local path = tag.path:match("/([^/]+)$")
        local active = curr_file == path
        create_pane(f, path, active)
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

M.toggle = function()
    local tags = grapple.tags()
    if #tags > 0 then
        vim.o.showtabline = 2
    else
        vim.o.showtabline = 0
    end
end

-- M.update_tags = function(branch)
--     M.cache_display_tags(branch)
--     M.toggle_tabline()
-- end

return M

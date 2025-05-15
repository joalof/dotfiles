local utils = require('heirline.utils')
local conditions = require('heirline.conditions')

local Color = require("lib.color").Color


-- define highlights for the tabline
local norm_fg = Color.from_hl("Normal", "fg")
local norm_fg_dark = norm_fg:shade(-0.55)
local norm_bg = Color.from_hl("Normal", "bg")
local norm_bg_dark = norm_bg:shade(-0.35)

norm_fg = norm_fg:to_css()
norm_fg_dark = norm_fg_dark:to_css()
norm_bg = norm_bg:to_css()
norm_bg_dark = norm_bg_dark:to_css()

local hls = {
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

-- local grapple = require('grapple')
-- local tags = grapple.tags()
-- for _, tag in ipairs(tags) do
--     local path = tag.path:match("/([^/]+)$")
--     local active = curr_file == path
-- end


local function get_filename_component(filename_provider, include_flags)

    include_flags = include_flags or false

    local block_comp = {
        init = function(self)
            self.filename = filename_provider()
        end,
    }
    local icon_comp = {
        init = function(self)
            local fname = self.filename
            local ext = vim.fn.fnamemodify(fname, ":e")
            self.icon, self.icon_color = require('mini.icons').get('filetype', ext)
        end,
        provider = function(self)
            return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end
    }

    local filename_comp = {
        provider = function(self)
            -- first, trim the pattern relative to the current directory. For other
            -- options, see :h filename-modifers
            local fname = vim.fn.fnamemodify(self.filename, ":.")
            if fname == "" then return "[No Name]" end
            -- now, if the filename would occupy more than 1/4th of the available
            -- space, we trim the file path to its initials
            -- See Flexible Components section below for dynamic truncation
            if not conditions.width_percent_below(#fname, 0.25) then
                fname = vim.fn.pathshorten(fname)
            end
            return fname
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
    }
    local flags_comp = {
        {
            condition = function()
                return vim.bo.modified
            end,
            provider = "[+]",
            hl = { fg = "green" },
        },
        {
            condition = function()
                return not vim.bo.modifiable or vim.bo.readonly
            end,
            provider = "",
            hl = { fg = "orange" },
        },
    }
    -- let's add the children to our FileNameBlock component
    block_comp = utils.insert(block_comp,
        icon_comp,
        filename_comp,
        flags_comp,
        { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
    )

    return block_comp
end

local curr_file_comp = get_filename_component(function() return vim.api.nvim_buf_get_name(0) end)
curr_file_comp = utils.surround({"", ""}, hls.wedge.fg, curr_file_comp)

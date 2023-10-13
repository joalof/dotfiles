return {
    "rafcamlet/tabline-framework.nvim",
    -- dev = true,
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        { "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    -- event = "VeryLazy",
    config = function()
        -- Adapted from https://github.com/ThePrimeagen/harpoon/issues/206#issuecomment-1538132132
        local function get_marks()
            local harpoon = require("harpoon")
            local config = harpoon.get_mark_config()
            return config.marks
        end

        local function normalize_path(item)
            local Path = require("plenary.path")
            return Path:new(item):make_relative(vim.loop.cwd())
        end

        -- define colors
        local colors = require("lib.colors")

        local normal_fg = colors.get_hl("Normal", "fg")
        local normal_fg_dark = colors.get_shade(normal_fg, -55)
        local normal_bg = colors.get_hl("Normal", "bg")
        local normal_bg_dark = colors.get_shade(normal_bg, -50)

        local hls = {
            fill = {
                fg = normal_fg_dark,
                bg = normal_bg_dark,
            },
            wedge = {
                fg = normal_bg_dark,
                bg = normal_bg,
            },
            text = {
                fg_active = normal_fg,
                fg_inactive = normal_fg_dark,
                bg = normal_bg,
            },
        }

        local function create_pane(f, filename, active)
            f.add({ "", fg = hls.wedge.fg, bg = hls.wedge.bg })
            if filename then
                f.add({ f.icon(filename) .. " ", fg = f.icon_color(filename), bg = hls.text.bg })
                local text_fg = hls.text.fg_inactive
                if active  then
                    text_fg = hls.text.fg_active
                end
                f.add({ vim.fn.fnamemodify(filename, ":t"), fg = text_fg, bg = hls.text.bg })
            end
            f.add({ "", fg = hls.wedge.fg, bg = hls.wedge.bg })
        end

        local render = function(f)

            local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
            local items = get_marks()

            local found = false
            for _, item in ipairs(items) do
                if current_file == item.filename then
                    found = true
                    break
                end
            end

            -- if current file is not a mark add it
            if not found then
                create_pane(f, current_file, true)
            end

            -- add all marks
            for _, item in ipairs(items) do
                local active = current_file == item.filename
                create_pane(f, item.filename, active)
            end

            f.add_spacer()
            --
            -- f.make_tabs(function(info)
            --     f.add({ "", fg = colors_tmp.black, bg = colors_tmp.bg_sel })
            --     f.add({ " " .. info.index .. " ", fg = info.current and colors_tmp.white or nil })
            --     f.add({ "", bg = colors_tmp.bg_sel, fg = colors_tmp.black })
            -- end )
        end

        require("tabline_framework").setup({
            render = render,
            hl_fill = { fg = hls.fill.fg, bg = hls.fill.bg },
        })
        vim.o.showtabline = 2
    end,
}

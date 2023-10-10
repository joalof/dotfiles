return {
    "rafcamlet/tabline-framework.nvim",
    dev = true,
    dependencies = {
        {"nvim-tree/nvim-web-devicons"},
        { "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    -- event = "VeryLazy",
    config = function()

        -- From https://github.com/ThePrimeagen/harpoon/issues/206#issuecomment-1538132132
        local function get_marks()
            local h = require("harpoon")
            local config = h.get_mark_config()
            return config.marks
        end

        local function normalize_path(item)
            local Path = require("plenary.path")
            return Path:new(item):make_relative(vim.loop.cwd())
        end

        local colors = {
            black = "#000000",
            white = "#ffffff",
            bg = "#181A1F",
            bg_sel = "#282c34",
            temp = "#287c34",
            fg = "#696969",
        }

        local function make_row(text, opts)
            local row = { text }
            for k, v in pairs(opts) do
                row[k] = v
            end
            return row
        end

        local function create_pane(f, filename, opts)
            f.set_fg(colors.fg)
            f.add({ "", fg = colors.black, bg = colors.bg_sel })
            if filename then
                f.add(make_row(f.icon(filename) .. " ", opts))
                f.add(make_row(vim.fn.fnamemodify(filename, ":t"), opts))
            end
            f.add({ "", bg = colors.bg_sel, fg = colors.black })
        end

        local render = function(f)
            local items = get_marks()
            local found = false
            local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
            for _, item in ipairs(items) do
                local selected = current_file == item.filename
                if not found and selected then
                    found = true
                end
                local fg = selected and f.icon_color(item.filename) or nil
                create_pane(f, item.filename, { fg = fg, bg = colors.bg_sel })
            end
        
            if not found then
                create_pane(f, current_file, { fg = colors.temp, bg = colors.bg_sel, gui = "italic" })
            end
        
            f.add_spacer()
        
            f.make_tabs(function(info)
                f.add({ "", fg = colors.black, bg = colors.bg_sel })
                f.add({ " " .. info.index .. " ", fg = info.current and colors.white or nil })
                f.add({ "", bg = colors.bg_sel, fg = colors.black })
            end)
        end

        -- require("tabline_framework").setup({
        --     render = render,
        --     hl = { fg = "#abb2bf", bg = "#181A1F" },
        --     hl_sel = { fg = "#abb2bf", bg = "#282c34" },
        --     hl_fill = { fg = "#ffffff", bg = "#000000" },
        -- })
        -- vim.o.showtabline = 2
    end,
}

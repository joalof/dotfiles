M = {}

-- from https://github.com/akinsho/bufferline.nvim/blob/main/lua/bufferline/colors.lua

---Convert a hex color to rgb
local function hex_to_rgb(color)
    local hex = color:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5), 16)
end

local function alter(attr, percent)
    return math.floor(attr * (100 + percent) / 100)
end

function M.get_shade(color, percent)
    local r, g, b = hex_to_rgb(color)
    if not r or not g or not b then
        return "NONE"
    end
    r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
    r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
    return ("#%02x%02x%02x"):format(r, g, b)
end

function M.is_bright(hex)
    if not hex then
        return false
    end
    local r, g, b = hex_to_rgb(hex)
    -- If any of the colors are missing return false
    if not r or not g or not b then
        return false
    end
    -- Counting the perceptive luminance - human eye favors green color
    local luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
    return luminance > 0.5 -- if > 0.5 Bright colors, black font, otherwise Dark colors, white font
end


---@alias GetColorOpts { name: string, attribute: "fg" | "bg" | "sp", fallback: GetColorOpts?, not_match: string?, cterm: boolean? }
--- parses the GUI hex color code (or cterm color number) from the given hl_name
--- color number (0-255) is returned if cterm is set to true in opts
---@param opts GetColorOpts
---@return string? | number?
function M.get_hl(name, attribute, opts)
    opts = opts or {}
    local cterm = opts.cterm
    -- try and get hl from name
    hl = vim.api.nvim_get_hl(0, { name = name })
    if cterm then
        return hl[attribute]
    else
        local hex = ("#%06x"):format(hl[attribute])
        return hex
    end
end

return M

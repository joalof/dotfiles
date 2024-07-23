local mathx = require('lib.mathx')
--- Color library forked from nightfox theme
--- https://github.com/EdenEast/nightfox.nvim/blob/main/lua/nightfox/lib/color.lua

-- holds top-level functions and Color class
local M = {}


---RGBA color representation stored in float [0,1]
---@class RGBA
---@field red number [0,255]
---@field green number [0,255]
---@field blue number [0,255]
---@field alpha number [0,1]

---@class HSL
---@field hue number Float [0,360)
---@field saturation number Float [0,100]
---@field lightness number Float [0,100]

---@class HSV
---@field hue number Float [0,360)
---@field saturation number Float [0,100]
---@field value number Float [0,100]

--#endregion

--#region Helpers --------------------------------------------------------------

local bitop = bit

local function calc_hue(r, g, b)
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min
    local h = 0

    if max == min then
        h = 0
    elseif max == r then
        h = 60 * ((g - b) / delta)
    elseif max == g then
        h = 60 * ((b - r) / delta + 2)
    elseif max == b then
        h = 60 * ((r - g) / delta + 4)
    end

    if h < 0 then
        h = h + 360
    end

    return { hue = h, max = max, min = min, delta = delta }
end


local Color = setmetatable({}, {})
Color.__index = Color

---@alias GetColorOpts { name: string, attribute: "fg" | "bg" | "sp", fallback: GetColorOpts?, not_match: string?, cterm: boolean? }
--- parses the GUI hex color code (or cterm color number) from the given hl_name
--- color number (0-255) is returned if cterm is set to true in opts
---@param opts GetColorOpts
---@return string? | number?
function Color.get_hl(name, attribute, opts)
    opts = opts or {}
    local cterm = opts.cterm
    -- try and get hl from name
    local hl = vim.api.nvim_get_hl(0, { name = name })
    if cterm then
        return hl[attribute]
    else
        local hex = ("#%06x"):format(hl[attribute])
        return hex
    end
end

function Color.new(opts)
    if type(opts) == "string" then
        return Color.from_css(opts)
    end
    if opts.red then
        return Color.from_rgba(opts.red, opts.green, opts.blue, opts.alpha)
    end
    if opts.value then
        return Color.from_hsv(opts.hue, opts.saturation, opts.value)
    end
    if opts.lightness then
        return Color.from_hsv(opts.hue, opts.saturation, opts.lightness)
    end
    if opts.name then
        return Color.from_hl(opts.name, opts.attribute, opts.opts)
    end
end

function Color.__tostring(self)
    return self:to_css()
end

function Color.init(r, g, b, a)
    local self = setmetatable({}, Color)
    self.red = mathx.clamp(r, 0, 1)
    self.green = mathx.clamp(g, 0, 1)
    self.blue = mathx.clamp(b, 0, 1)
    self.alpha = mathx.clamp(a or 1, 0, 1)
    return self
end

--#region from_* ---------------------------------------------------------------

---Create color from RGBA 0,255
---@param r number Integer [0,255]
---@param g number Integer [0,255]
---@param b number Integer [0,255]
---@param a number Float [0,1]
---@return Color
function Color.from_rgba(r, g, b, a)
    return Color.init(r / 0xff, g / 0xff, b / 0xff, a or 1)
end

---Create a color from a hex number
---@param c number|string Either a literal number or a css-style hex string ('#RRGGBB[AA]')
---@return Color
function Color.from_css(c)
    local n = c
    if type(c) == "string" then
        local s = c:lower():match("#?([a-f0-9]+)")
        n = tonumber(s, 16)
        if #s <= 6 then
            n = bitop.lshift(n, 8) + 0xff
        end
    end

    return Color.init(
        bitop.rshift(n, 24) / 0xff,
        bitop.band(bitop.rshift(n, 16), 0xff) / 0xff,
        bitop.band(bitop.rshift(n, 8), 0xff) / 0xff,
        bitop.band(n, 0xff) / 0xff
    )
end

---Create a Color from HSV value
---@param h number Hue. Float [0,360]
---@param s number Saturation. Float [0,100]
---@param v number Value. Float [0,100]
---@param a number (Optional) Alpha. Float [0,1]
---@return Color

function Color.from_hsv(h, s, v, a)
    h = h % 360
    s = mathx.clamp(s, 0, 100) / 100
    v = mathx.clamp(v, 0, 100) / 100
    a = mathx.clamp(a or 1, 0, 1)

    local function f(n)
        local k = (n + h / 60) % 6
        return v - v * s * math.max(math.min(k, 4 - k, 1), 0)
    end

    return Color.init(f(5), f(3), f(1), a)
end

---Create a Color from HSL value
---@param h number Hue. Float [0,360]
---@param s number Saturation. Float [0,100]
---@param l number Lightness. Float [0,100]
---@param a number (Optional) Alpha. Float [0,1]
---@return Color

function Color.from_hsl(h, s, l, a)
    h = h % 360
    s = mathx.clamp(s, 0, 100) / 100
    l = mathx.clamp(l, 0, 100) / 100
    a = mathx.clamp(a or 1, 0, 1)
    local _a = s * math.min(l, 1 - l)

    local function f(n)
        local k = (n + h / 30) % 12
        return l - _a * math.max(math.min(k - 3, 9 - k, 1), -1)

    end

    return Color.init(f(0), f(8), f(4), a)
end

-- create a Color from vim hl
---@param opts GetColorOpts
---@return table
function Color.from_hl(name, attribute, opts)
    local hex = Color.get_hl(name, attribute, opts)
    return Color.from_css(hex)
end

---Convert Color to RGBA
---@return RGBA
function Color:to_rgba()
    return {
        red = mathx.round(self.red * 0xff),
        green = mathx.round(self.green * 0xff),
        blue = mathx.round(self.blue * 0xff),
        alpha = self.alpha,
    }
end

---Convert Color to HSV
---@return HSV
function Color:to_hsv()
    local res = calc_hue(self.red, self.green, self.blue)
    local h, min, max = res.hue, res.min, res.max
    local s, v = 0, max

    if max ~= 0 then
        s = (max - min) / max
    end

    return { hue = h, saturation = s * 100, value = v * 100 }
end

---Convert the color to HSL.
---@return HSL
function Color:to_hsl()
    local res = calc_hue(self.red, self.green, self.blue)
    local h, min, max = res.hue, res.min, res.max
    local s, l = 0, (max + min) / 2

    if max ~= 0 and min ~= 1 then
        s = (max - l) / math.min(l, 1 - l)
    end

    return { hue = h, saturation = s * 100, lightness = l * 100 }
end

---Convert the color to a hex number representation (`0xRRGGBB[AA]`).
---@param with_alpha boolean Include the alpha component.
---@return integer
function Color:to_hex(with_alpha)
    local ls, bor, fl = bitop.lshift, bitop.bor, math.floor
    local n =
    bor(bor(ls(fl((self.red * 0xff) + 0.5), 16), ls(fl((self.green * 0xff) + 0.5), 8)), fl((self.blue * 0xff) + 0.5))
    return with_alpha and bitop.lshift(n, 8) + (self.alpha * 0xff) or n
end

---Convert the color to a css hex color (`#RRGGBB[AA]`).
---@param with_alpha boolean Include the alpha component.
---@return string
function Color:to_css(with_alpha)
    local n = self:to_hex(with_alpha)
    local l = with_alpha and 8 or 6
    return string.format("#%0" .. l .. "x", n)
end

---Calculate the relative luminance of the color
---https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
---@return number
function Color:luminance()
    local r, g, b = self.red, self.green, self.blue
    r = (r > 0.04045) and ((r + 0.055) / 1.055) ^ 2.4 or (r / 12.92)
    g = (g > 0.04045) and ((g + 0.055) / 1.055) ^ 2.4 or (g / 12.92)
    b = (b > 0.04045) and ((b + 0.055) / 1.055) ^ 2.4 or (b / 12.92)

    return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

---Returns a new color that a linear blend between two colors
---@param other Color
---@param f number Float [0,1]. 0 being this and 1 being other
---@return Color
function Color:blend(other, f)
    return Color.init(
        (other.red - self.red) * f + self.red,
        (other.green - self.green) * f + self.green,
        (other.blue - self.blue) * f + self.blue,
        self.alpha
    )
end

---Returns a new shaded color.
---@param f number Amount. Float [-1,1]. -1 is black, 1 is white
---@return Color
function Color:shade(f)
    local t = f < 0 and 0 or 1.0
    local p = f < 0 and f * -1.0 or f

    return Color.init(
        (t - self.red) * p + self.red,
        (t - self.green) * p + self.green,
        (t - self.blue) * p + self.blue,
        self.alpha
    )
end

---Adds value of `v` to the `value` of the current color. This returns either
---a brighter version if +v and darker if -v.
---@param v number Value. Float [-100,100].
---@return Color
function Color:brighten(v)
    local hsv = self:to_hsv()
    local value = mathx.clamp(hsv.value + v, 0, 100)
    return Color.from_hsv(hsv.hue, hsv.saturation, value)
end

---Adds value of `v` to the `lightness` of the current color. This returns
---either a lighter version if +v and darker if -v.
---@param v number Lightness. Float [-100,100].
---@return Color
function Color:lighten(v)
    local hsl = self:to_hsl()
    local lightness = mathx.clamp(hsl.lightness + v, 0, 100)
    return Color.from_hsl(hsl.hue, hsl.saturation, lightness)
end

---Adds value of `v` to the `saturation` of the current color. This returns
---either a more or less saturated version depending of +/- v.
---@param v number Saturation. Float [-100,100].
---@return Color
function Color:saturate(v)
    local hsv = self:to_hsv()
    local saturation = mathx.clamp(hsv.saturation + v, 0, 100)
    return Color.from_hsv(hsv.hue, saturation, hsv.value)
end

---Adds value of `v` to the `hue` of the current color. This returns a rotation of
---hue based on +/- of v. Resulting `hue` is wrapped [0,360]
---@return Color
function Color:rotate(v)
    local hsv = self:to_hsv()
    local hue = (hsv.hue + v) % 360
    return Color.from_hsv(hue, hsv.saturation, hsv.value)
end


Color.WHITE = Color.init(1, 1, 1, 1)
Color.BLACK = Color.init(0, 0, 0, 1)

function Color:is_bright()
    -- Counting the perceptive luminance - human eye favors green color
    local luminance = (0.299 * self.r + 0.587 * self.g + 0.114 * self.b) / 255
    return luminance > 0.5 -- if > 0.5 Bright colors, black font, otherwise Dark colors, white font
end

---Returns the contrast ratio of the other against another
---@param other Color
function Color:contrast(other)
    local l1 = self:luminance()
    local l2 = other:luminance()
    if l2 > l1 then
        l1, l2 = l2, l1
    end
    return (l1 + 0.05) / (l2 + 0.05)
end

---Check if color passes WCAG AA
---https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
---@param background Color background to check against
---@return boolean, number
function Color:valid_wcag_aa(background)
    local ratio = self:contrast(background)
    return ratio >= 4.5, ratio
end


local mt = getmetatable(Color)
function mt.__call(_, opts)
    return Color.new(opts)
end

M['Color'] = Color

return M

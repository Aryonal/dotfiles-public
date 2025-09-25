---TODO: move to utils
---@alias HexTransformFn fun(h: number, s: number, l: number): number, number, number

local M = {}

---Convert RGB to HSL color space
---@param r number red component (0-1)
---@param g number green component (0-1)
---@param b number blue component (0-1)
---@return number h hue (0-1)
---@return number s saturation (0-1)
---@return number l lightness (0-1)
function M.rgb_to_hsl(r, g, b)
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h, s, l = 0, 0, (max + min) / 2

    if max == min then
        h, s = 0, 0 -- achromatic
    else
        local d = max - min
        s = l > 0.5 and d / (2 - max - min) or d / (max + min)

        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end

    return h, s, l
end

---Convert HSL to RGB color space
---@param h number hue (0-1)
---@param s number saturation (0-1)
---@param l number lightness (0-1)
---@return number r red component (0-1)
---@return number g green component (0-1)
---@return number b blue component (0-1)
function M.hsl_to_rgb(h, s, l)
    local r, g, b

    if s == 0 then
        r, g, b = l, l, l -- achromatic
    else
        local function hue_to_rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1 / 6 then return p + (q - p) * 6 * t end
            if t < 1 / 2 then return q end
            if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
            return p
        end

        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        r = hue_to_rgb(p, q, h + 1 / 3)
        g = hue_to_rgb(p, q, h)
        b = hue_to_rgb(p, q, h - 1 / 3)
    end

    return r, g, b
end

---Clamp a value between 0 and 1
---@param value number value to clamp
---@return number clamped value
local function clamp(value)
    return math.max(0, math.min(1, value))
end

---Brighten a color by increasing its lightness
---@param h number hue (0-1)
---@param s number saturation (0-1)
---@param l number lightness (0-1)
---@param amount number amount to brighten (0-1)
---@return number h unchanged hue
---@return number s unchanged saturation
---@return number l increased lightness
function M.brighten(h, s, l, amount)
    return h, s, clamp(l + amount)
end

---Darken a color by decreasing its lightness
---@param h number hue (0-1)
---@param s number saturation (0-1)
---@param l number lightness (0-1)
---@param amount number amount to darken (0-1)
---@return number h unchanged hue
---@return number s unchanged saturation
---@return number l decreased lightness
function M.darken(h, s, l, amount)
    return h, s, clamp(l - amount)
end

---Saturate a color by increasing its saturation
---@param h number hue (0-1)
---@param s number saturation (0-1)
---@param l number lightness (0-1)
---@param amount number amount to saturate (0-1)
---@return number h unchanged hue
---@return number s increased saturation
---@return number l unchanged lightness
function M.saturate(h, s, l, amount)
    return h, clamp(s + amount), l
end

---Desaturate a color by decreasing its saturation
---@param h number hue (0-1)
---@param s number saturation (0-1)
---@param l number lightness (0-1)
---@param amount number amount to desaturate (0-1)
---@return number h unchanged hue
---@return number s decreased saturation
---@return number l unchanged lightness
function M.desaturate(h, s, l, amount)
    return h, clamp(s - amount), l
end

---Warm a color by shifting hue towards red/orange
---@param h number hue (0-1)
---@param s number saturation (0-1)
---@param l number lightness (0-1)
---@param amount number amount to warm (0-1)
---@return number h shifted hue towards warm
---@return number s unchanged saturation
---@return number l unchanged lightness
function M.warm(h, s, l, amount)
    -- Shift hue towards red/orange (around 0.08 in hue space)
    local target_hue = 0.08
    local new_h = h + (target_hue - h) * amount
    -- Wrap around if necessary
    if new_h > 1 then new_h = new_h - 1 end
    if new_h < 0 then new_h = new_h + 1 end
    return new_h, s, l
end

---Cool a color by shifting hue towards blue/cyan
---@param h number hue (0-1)
---@param s number saturation (0-1)
---@param l number lightness (0-1)
---@param amount number amount to cool (0-1)
---@return number h shifted hue towards cool
---@return number s unchanged saturation
---@return number l unchanged lightness
function M.cool(h, s, l, amount)
    -- Shift hue towards blue/cyan (around 0.6 in hue space)
    local target_hue = 0.6
    local new_h = h + (target_hue - h) * amount
    -- Wrap around if necessary
    if new_h > 1 then new_h = new_h - 1 end
    if new_h < 0 then new_h = new_h + 1 end
    return new_h, s, l
end

---Convert hex color to RGB values
---@param hex string hex color string (e.g. "#ff0000" or "ff0000")
---@return number r red component (0-255)
---@return number g green component (0-255)
---@return number b blue component (0-255)
function M.hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    if #hex == 3 then
        hex = hex:gsub(".", "%1%1")
    end
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return r, g, b
end

---Convert RGB values to hex color string
---@param r number red component (0-255)
---@param g number green component (0-255)
---@param b number blue component (0-255)
---@return string hex color string with # prefix
function M.rgb_to_hex(r, g, b)
    return string.format("#%02x%02x%02x", r, g, b)
end

return M

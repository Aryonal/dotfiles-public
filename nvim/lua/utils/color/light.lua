local M = {}

-- REF: https://stackoverflow.com/questions/72424838/programmatically-lighten-or-darken-a-hex-color-in-lua-nvim-highlight-colors
local function clamp(component)
    return math.min(math.max(component, 0), 255)
end

-- LightenDarkenColor will transform color (%02x%02x%02x), change the brightness by percentage
local function lightenDarkenColor(col, percentage)
    local num = tonumber(col, 16)
    local r = math.floor(num / 0x10000)
    local g = (math.floor(num / 0x100) % 0x100)
    local b = (num % 0x100)

    local brightness = (0.2126 * r + 0.7152 * g + 0.0722 * b)
    local amt = brightness * percentage

    r = r + amt
    g = g + amt
    b = b + amt
    return string.format("%02x%02x%02x", clamp(r), clamp(g), clamp(b))
end

function M.darken(c, percentage)
    c = string.sub(c, 2) -- #123456 => 123456
    return "#" .. lightenDarkenColor(c, -1 * percentage)
end

function M.brighten(c, percentage)
    c = string.sub(c, 2) -- #123456 => 123456
    return "#" .. lightenDarkenColor(c, percentage)
end


return M

local vim_utils = require("helper.vim")
local vim_hl = require("helper.vim.hl")
local color = require("helper.color")

---@class plugin.status.StyleProperties
---@field bold? boolean
---@field italic? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field underdouble? boolean
---@field underdotted? boolean
---@field underdashed? boolean
---@field strikethrough? boolean
---@field reverse? boolean
---@field standout? boolean
---@field nocombine? boolean

---@class plugin.status.HighlightTransforms
---@field fg? HexTransformFn foreground color transformation
---@field bg? HexTransformFn background color transformation
---@field style? plugin.status.StyleProperties text style properties

---@class plugin.status.StatusGroupConfig
---@field base_hl string base highlight group name
---@field transforms plugin.status.HighlightTransforms transformation configuration

local M = {}

---@type table<string, plugin.status.StatusGroupConfig>
local status_groups = {}

---Remove/unset a color property by returning nil
---@param h number hue (unused)
---@param s number saturation (unused)
---@param l number lightness (unused)
---@return nil
local function make_nil(h, s, l)
    return nil
end

local function make_color(hex)
    return function(_, _, _)
        local r, g, b = color.hex_to_rgb(hex)
        return color.rgb_to_hsl(r / 255, g / 255, b / 255)
    end
end

local function make_darken(amount)
    return function(h, s, l)
        return color.darken(h, s, l, amount)
    end
end

---Apply color transformation to a hex color
---@param hex_color string hex color string
---@param hsl_transform HexTransformFn color transformation function
---@return string|nil transformed hex color string or nil if transform removes the color
local function apply_color_transform(hex_color, hsl_transform)
    if not hex_color or hex_color == "" then
        return hex_color
    end

    local r, g, b = color.hex_to_rgb(hex_color)
    local h, s, l = color.rgb_to_hsl(r / 255, g / 255, b / 255)

    local new_h, new_s, new_l = hsl_transform(h, s, l)

    -- If transform function returns nil, it means remove this color property
    if new_h == nil then
        return nil
    end

    local new_r, new_g, new_b = color.hsl_to_rgb(new_h, new_s, new_l)

    return color.rgb_to_hex(math.floor(new_r * 255), math.floor(new_g * 255), math.floor(new_b * 255))
end

---Create and set a status line highlight group
---@param name string highlight group name
---@param base_hl string base highlight group to derive from
---@param transforms? plugin.status.HighlightTransforms transformation config with fg, bg, and style properties
local function create_status_hl(name, base_hl, transforms)
    -- If no transforms provided, create a simple link
    if not transforms then
        vim.api.nvim_set_hl(0, name, { link = base_hl })
        return
    end

    local source_hl = vim_hl.get_source_hl(base_hl)
    local new_hl = {}

    if source_hl.fg then
        local fg_hex = string.format("#%06x", source_hl.fg)
        if transforms.fg then
            fg_hex = apply_color_transform(fg_hex, transforms.fg)
        end
        if fg_hex ~= nil then
            new_hl.fg = fg_hex
        end
    end

    if source_hl.bg then
        local bg_hex = string.format("#%06x", source_hl.bg)
        if transforms.bg then
            bg_hex = apply_color_transform(bg_hex, transforms.bg)
        end
        if bg_hex ~= nil then
            new_hl.bg = bg_hex
        end
    end

    if transforms.style then
        for style, value in pairs(transforms.style) do
            new_hl[style] = value
        end
    end

    vim.api.nvim_set_hl(0, name, new_hl)
end

---Update all registered status line highlight groups
---@param opts plugin.status.StatusOptions options for status line configuration
local function update_status_highlights(opts)
    for name, config in pairs(status_groups) do
        create_status_hl(name, config.base_hl, config.transforms)
    end
end

---Register a new status line highlight group
---@param name string highlight group name
---@param base_hl string base highlight group to derive from
---@param transforms? plugin.status.HighlightTransforms transformation config with fg, bg, and style properties
local function register_status_hl(name, base_hl, transforms)
    status_groups[name] = {
        base_hl = base_hl,
        transforms = transforms or {}
    }

    create_status_hl(name, base_hl, transforms)
end

---@param opts plugin.status.StatusOptions
local function register_hls(opts)
    register_status_hl("MyStatusLineInsert", "StatusLine", {
        bg = make_color("#38a169") -- moderate green
    })
    register_status_hl("MyStatusLineVisual", "StatusLine", {
        bg = make_color("#d69e2e") -- moderate amber/orange
    })
    register_status_hl("MyStatusLineBold", "StatusLine", {
        fg = make_nil,
        bg = make_nil,
        style = { bold = true }
    })
    register_status_hl("MyStatusLineItalic", "StatusLine", {
        fg = make_nil,
        bg = make_nil,
        style = { italic = true }
    })
    register_status_hl("MyStatusLineNCBold", "StatusLineNC", {
        fg = make_nil,
        bg = make_nil,
        style = { bold = true }
    })
    register_status_hl("MyStatusLineDiffAdded", "Added", {
        fg = make_darken(0.25),
        bg = make_nil,
    })
    register_status_hl("MyStatusLineDiffChanged", "Changed", {
        fg = make_darken(0.25),
        bg = make_nil,
    })
    register_status_hl("MyStatusLineDiffRemoved", "Removed", {
        fg = make_darken(0.25),
        bg = make_nil,
    })
    register_status_hl("MyStatusLineDiagnosticHint", "DiagnosticHint", {
        fg = make_darken(0.25),
        bg = make_nil,
        style = { italic = true },
    })
    register_status_hl("MyStatusLineDiagnosticInfo", "DiagnosticInfo", {
        fg = make_darken(0.25),
        bg = make_nil,
        style = { italic = true },
    })
    register_status_hl("MyStatusLineDiagnosticWarn", "DiagnosticWarn", {
        fg = make_darken(0.25),
        bg = make_nil,
        style = { italic = true },
    })
    register_status_hl("MyStatusLineDiagnosticError", "DiagnosticError", {
        fg = make_darken(0.25),
        bg = make_nil,
        style = { italic = true },
    })
    register_status_hl("MyTabLineHeader", "TabLineFill", {
        style = { bold = true },
    })
    register_status_hl("MyTabLineDiagnosticHint", "DiagnosticHint", {
        bg = make_nil,
        style = { italic = true },
    })
    register_status_hl("MyTabLineDiagnosticInfo", "DiagnosticInfo", {
        bg = make_nil,
        style = { italic = true },
    })
    register_status_hl("MyTabLineDiagnosticWarn", "DiagnosticWarn", {
        bg = make_nil,
        style = { italic = true },
    })
    register_status_hl("MyTabLineDiagnosticError", "DiagnosticError", {
        bg = make_nil,
        style = { italic = true },
    })
end

---Setup status line highlight system with ColorScheme autocmd and default groups
---@param opts plugin.status.StatusOptions
function M.setup(opts)
    vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        group = vim.api.nvim_create_augroup("StatusLineHighlights", { clear = true }),
        desc = "Update status line highlight groups",
        callback = update_status_highlights,
    })

    register_hls(opts)
    update_status_highlights(opts)
end

---Wrap text with a highlight group
---@param text string text to wrap
---@param highlight string? highlight group name
---@return string formatted text with highlight
function M.with_hl(text, highlight)
    if not highlight or highlight == "" then
        return text
    end
    return "%#" .. highlight .. "#" .. text .. "%*"
end

return M

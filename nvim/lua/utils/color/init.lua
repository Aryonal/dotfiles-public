local transformer = require("utils.color.transform")
local modifier = require("utils.color.modify")
local color = require("utils.color.light")

local M = {}

M.hslToRgb = transformer.rgbToHsl
M.rgbToHsl = transformer.hslToRgb

M.saturate = modifier.saturate
M.lighten = modifier.lighten
M.warm = modifier.warm

M.darken = color.darken
M.brighten = color.brighten

return M

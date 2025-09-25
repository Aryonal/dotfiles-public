---@diagnostic disable: missing-fields
local ok, lightbulb = pcall(require, "nvim-lightbulb")
if not ok then
    return
end

-- TODO: load on buffer read?
lightbulb.setup({
    autocmd = {
        enabled = true,
    },
    sign = {
        enabled = false,
    },
    virtual_text = {
        enabled = true,
        text = require("assets.icons").code_action_virt_text,
        pos = "eol",
        hl = "LightBulbVirtualText",
        hl_mode = "combine",
    },
})

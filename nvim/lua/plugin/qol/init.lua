local M = {}

local cmds = {
    {
        cmd = "CopyCurLoc",
        key = "<leader>ccl",
        desc = "Copy relative path of current buffer with cursor location",
        exec = function()
            local loc = require("plugin.gf").get_cloc()
            local path = loc.file .. ":" .. loc.line .. ":" .. loc.col
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyCurLocAbs",
        key = "<leader>ccL",
        desc = "Copy absolute path of current buffer with cursor location",
        exec = function()
            local loc = require("plugin.gf").get_cloc(true)
            local path = loc.file .. ":" .. loc.line .. ":" .. loc.col
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
}

function M.setup()
    local set_cmd = require("helper.vim").set_cmd

    for _, c in ipairs(cmds) do
        set_cmd(c)
    end

    local custom_aug = vim.api.nvim_create_augroup("lua/plugin/qol/init.lua", { clear = true })
    vim.api.nvim_create_autocmd({ "TextYankPost" }, {
        group = custom_aug,
        desc = "Highlight text after yank",
        callback = function()
            vim.highlight.on_yank()
        end,
    })
end

return M

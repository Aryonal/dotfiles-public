local M = {}

local cmds = {
    {
        cmd = "CopyPathAbs",
        key = "<leader>ccP",
        desc = "Copy absolute path of current buffer",
        exec = function()
            local path = vim.fn.expand("%:p")
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyPath",
        key = "<leader>ccp",
        desc = "Copy relative path of current buffer",
        exec = function()
            local path = vim.fn.expand("%:p")
            -- "%" seems not to be so reliable
            local cwd = vim.fn.getcwd() .. "/"
            path = require("x.helper.lua").crop(path, cwd)
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyDirAbs",
        key = "<leader>ccD",
        desc = "Copy absolute path of current buffer directory",
        exec = function()
            local path = vim.fn.expand("%:p:h")
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyDir",
        key = "<leader>ccd",
        desc = "Copy absolute path of current buffer directory",
        exec = function()
            local path = vim.fn.expand("%:p:h")
            -- "%" seems not to be so reliable
            local cwd = vim.fn.getcwd() .. "/"
            path = require("x.helper.lua").crop(path, cwd)
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyWorkDir",
        key = "<leader>ccw",
        desc = "Copy absolute path of current work directory",
        exec = function()
            local path = vim.uv.cwd()
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyCurLoc",
        key = "<leader>ccl",
        desc = "Copy relative path of current buffer with cursor location",
        exec = function()
            local loc = require("x.plugin.gf").get_cloc()
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
            local loc = require("x.plugin.gf").get_cloc(true)
            local path = loc.file .. ":" .. loc.line .. ":" .. loc.col
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
}

function M.setup()
    local set_cmd = require("x.helper.vim").set_cmd

    for _, c in ipairs(cmds) do
        set_cmd(c)
    end

    local custom_aug = vim.api.nvim_create_augroup("customs/qol.lua", { clear = true })
    vim.api.nvim_create_autocmd({ "TextYankPost" }, {
        group = custom_aug,
        desc = "Highlight text after yank",
        callback = function()
            vim.highlight.on_yank()
        end,
    })
end

return M

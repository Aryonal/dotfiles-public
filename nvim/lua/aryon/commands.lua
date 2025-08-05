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
            path = require("utils.lua").crop(path, cwd)
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
            path = require("utils.lua").crop(path, cwd)
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
            local loc = require("customs.gf").get_cloc()
            local path = loc.file .. ":" .. loc.line .. ":" .. loc.col
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    --- use :InspectTree
    -- {
    --     cmd = "TreeSitterInspect",
    --     abbr = "tti",
    --     desc = "Treesitter inspect",
    --     exec = function()
    --         vim.treesitter.inspect_tree()
    --     end
    -- },
}

local set_cmd = require("utils.vim").set_cmd

for _, c in ipairs(cmds) do
    set_cmd(c)
end

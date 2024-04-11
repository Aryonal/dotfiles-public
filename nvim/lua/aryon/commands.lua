-- structure
-- REF: h: nvim_create_user_command
-- ```
-- {
--    cmd = "CommandName",
--    desc = "",
--    abbr = "",
--    exec = function () { print("hello") },
--    opts = {},
-- }
-- ```

local cmds = {
    {
        -- REF: https://www.reddit.com/r/neovim/comments/u221as/comment/i5y9zy2/?utm_source=share&utm_medium=web2x&context=3
        cmd = "CopyPathAbs",
        desc = "Copy absolute path of current buffer",
        exec = function()
            local path = vim.fn.expand("%:p")
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyPath",
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
        desc = "Copy absolute path of current buffer directory",
        exec = function()
            local path = vim.fn.expand("%:p:h")
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyDir",
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
        desc = "Copy absolute path of current work directory",
        exec = function()
            local path = vim.loop.cwd()
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "TrssSitterInspect",
        abbr = "tti",
        desc = "Treesitter inspect",
        exec = function()
            vim.treesitter.inspect_tree()
        end
    }
}

-- local cmds = require("aryon.config.commands")
local set_cmd = require("utils.command").set_cmd

for _, c in ipairs(cmds) do
    set_cmd(c)
end

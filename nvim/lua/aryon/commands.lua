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
            local path = vim.fn.expand("%")
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyDirAbs",
        desc = "Copy absolute path of current buffer directory",
        exec = function()
            local path = vim.fn.expand("%:hp")
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end,
    },
    {
        cmd = "CopyDir",
        desc = "Copy absolute path of current buffer directory",
        exec = function()
            local path = vim.fn.expand("%:h")
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
        cmd = "SaveSessionLocal",
        desc = "Save vim session of current workspace",
        exec = function()
            local session_folder = vim.fn.stdpath("state") .. "/sessions"

            vim.fn.mkdir(session_folder, "p")
            if vim.fn.isdirectory(session_folder) ~= 1 then
                vim.notify("Failed to create session folder: " .. session_folder)
                return
            end

            local cw = vim.fn.getcwd()
            cw = require("utils.path").strip_path(cw)
            local session_file = session_folder .. "/" .. require("utils.path").path_as_filename(cw) .. ".vim"

            vim.cmd(string.format("mksession! %s", session_file))
            vim.notify("Saved to " .. session_file)
        end,
    },
    {
        cmd = "LoadSessionLocal",
        desc = "Load vim session of current workspace",
        abbr = "sl",
        exec = function()
            local session_folder = vim.fn.stdpath("state") .. "/sessions"

            vim.fn.mkdir(session_folder, "p")
            if vim.fn.isdirectory(session_folder) ~= 1 then
                vim.notify("Failed to create session folder: " .. session_folder)
                return
            end

            local cw = vim.fn.getcwd()
            cw = require("utils.path").strip_path(cw)
            local session_file = session_folder .. "/" .. require("utils.path").path_as_filename(cw) .. ".vim"

            if vim.fn.filereadable(session_file) ~= 1 then
                vim.notify("Session file not exists: " .. session_file)
                return
            end

            vim.cmd(string.format("source %s", session_file))
            vim.notify("Loading " .. session_file)
        end,
    },
}

-- local cmds = require("aryon.config.commands")
local set_cmd = require("utils.command").set_cmd

for _, c in ipairs(cmds) do
    set_cmd(c)
end

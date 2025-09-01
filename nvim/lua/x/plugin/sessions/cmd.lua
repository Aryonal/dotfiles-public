---@diagnostic disable: unused-local
local util = require("x.plugin.sessions.utils")

local M = {}

---create session save command
---@param opts any
function M.create_cmd_save(opts)
    vim.api.nvim_create_user_command(
        "SaveSession",
        function()
            util.save(opts)
        end,
        { desc = "Save local session" })
end

---create session load command
---@param opts any
function M.create_cmd_load(opts)
    vim.api.nvim_create_user_command(
        "LoadSession",
        function()
            util.load(opts)
        end,
        { desc = "Load local session" })
end

---register autocmds for autosave on leave
---@param opts table: option table
---@param group any: autocmd group
function M.autosave_on_leave(opts, group)
    if not opts.auto_save_on_leave then
        return
    end
    -- TODO: check group is nil
    vim.api.nvim_create_autocmd({ "VimLeave" }, {
        group = group,
        desc = "Save session on leave",
        callback = function()
            ---TODO: check if enpty buffer
            util.save(opts)
        end,
    })
end

---register autocmds for autosave on leave
---@param opts table: option table
---@param group any: autocmd group
function M.autosave_on_win_change(opts, group)
    if not opts.auto_save_on_win_change then
        return
    end
    -- TODO: check group is nil
    vim.api.nvim_create_autocmd({ "WinNew", "WinResized", "WinClosed" }, {
        group = group,
        desc = "Save snapshot on win change",
        callback = function()
            util.save_n(opts)
        end,
    })
end

---register autocmds for autoload on enter
---@param opts table: option table
---@param group any: autocmd group
function M.autoload_on_enter(opts, group)
    if not opts.auto_load_on_enter and not opts.force_load_on_enter then
        return
    end
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        group = group,
        desc = "Load session on enter",
        -- nested = true,
        callback = function(args)
            local is_directory = vim.fn.isdirectory(args.file) == 1
            local is_real_file = vim.fn.filereadable(args.file) == 1
            local no_name = args.file == "" and vim.bo[args.buf].buftype == ""

            local bare = #(vim.v.argv) <= 2 --- [ nvim, --embed ]

            local loadable = no_name and bare
            loadable = loadable or (opts.override_non_empty or opts.force_load_on_enter)

            if loadable then
                vim.defer_fn(function()
                    --- wait for plugins loading
                    -- if util.input("Load last session?") == 0 then
                    util.load(opts)
                    -- end
                end, 50) -- wait for other plugins being loaded
            end
        end,
    })
end

return M

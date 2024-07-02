local M = {}
M.__index = M

local git_status_cmd = { "git", "status", "-s" }

---shared table for git status
---@class Status
---@field n_changed number number of changed files

---get git repository status, return a table of status info, blocking
---@param cb fun(_:Status)? callback function accepts returned table
---@return Status
function M.status(cb)
    local status = {
        n_changed = 0,
    }
    local obj = vim.system(git_status_cmd, { text = true }):wait()
    local stdout = obj.stdout

    if stdout ~= nil then
        local lines = vim.split(stdout, "\n")
        status.n_changed = #lines - 1
    end

    if cb ~= nil then
        cb(status)
    end

    return status
end

---NOTE: this can be a heavy job in large repository
---get git repository status, return a table, non-blocking
---@param cb fun(_:Status)? callback function accepts returned table
function M.async_status(interval_ms, cb)
    if interval_ms == nil then
        interval_ms = 1000
    end
    local poll_log = {}
    local fs_event = vim.uv.new_fs_event()
    if fs_event == nil then
        print("[utils/git] failed to create fs_event")
        return
    end
    local locker = require("utils.lua").Lock.new()

    local process = function()
        if locker:locked() then
            return
        end

        locker:lock()
        vim.system(git_status_cmd, { text = true }, function(obj)
            local stdout = obj.stdout
            local status = {
                n_changed = 0,
            }
            if cb ~= nil then
                if stdout ~= nil then
                    local lines = vim.split(stdout, "\n")
                    status.n_changed = #lines - 1
                end
                cb(status)
            end
            locker:unlock()
        end)
    end

    --- one time job to get git status on start
    local first_time_job
    first_time_job = vim.uv.new_async(function()
        process()
        if first_time_job ~= nil then
            first_time_job:close()
        end
    end)
    if first_time_job ~= nil then
        -- this job is safe to fail
        first_time_job:send()
    end

    local success = fs_event:start(
        vim.fn.getcwd(),
        { recursive = true },
        function(err, filename, ev)
            if err ~= nil then
                print("[utils/git] Error in fs_event:", err)
                return
            end
            -- ignore path with .git included
            if string.find(filename, "%.git") ~= nil or string.find(filename, "submodules") ~= nil then
                return
            end
            if not ev.change and not ev.rename then
                return
            end
            -- check if filename is ignored by git
            local ts = vim.uv.now()
            if poll_log[filename] ~= nil and ts - poll_log[filename] < interval_ms then
                return
            end
            vim.system({ "git", "check-ignore", filename }, { text = true }, function(obj)
                if obj.code ~= 0 then
                    process()
                    poll_log[filename] = vim.uv.now()
                else
                    -- set to infinity for git ignored file
                    poll_log[filename] = math.huge
                end
            end)
        end
    )

    if not success then
        print("[utils/git] failed to start fs_event")
        fs_event:stop()
        return
    end

    require("utils.vim").create_autocmd({
        events = { "VimLeavePre" },
        description = "[utils/git] stop fs_event",
        pattern = "*",
        group_name = "utils/git.lua",
        callback = function()
            if fs_event ~= nil then
                fs_event:stop()
            end
        end,
    })
end

return M

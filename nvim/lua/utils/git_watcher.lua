local debounce = require("utils.lua").debounce

---git utility functions
local G = {}
G.__index = G

---shared table for git status
---@class Status
---@field n_changed number? number of changed files

---@param cb fun(_:Status) callback function to handle status
function G.new(cb)
    local self = setmetatable({}, G)
    self.locked = false ---@type boolean locked status
    self.git_dir = "" ---@type string git directory
    self.fs_event = nil ---@type uv_fs_event_t? fs_event handle
    self.git_index_event = nil ---@type uv_fs_event_t? fs_event handle
    self.git_head_event = nil ---@type uv_fs_event_t? fs_event handle
    self.git_refs_event = nil ---@type uv_fs_event_t? fs_event handle
    self.cb = cb ---@type fun(_:Status) callback function to handle status
    return self
end

local git_status_cmd = { "git", "status", "-s" }

---start git status polling in cwd
---and register autocmd to stop or refresh fs_event on VimLeavePre and DirChanged
---@return nil
function G:start()
    if require("utils.os").is_windows() then
        vim.notify("[utils/git.lua] Windows is not supported")
        return
    end

    -- register autocmd to stop fs_event on VimLeavePre
    local au = vim.api.nvim_create_augroup("utils/git.lua", { clear = true })

    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        group = au,
        desc = "[utils/git.lua] start wather",
        pattern = "*",
        callback = function()
            self:_watch(vim.uv.cwd())
        end,
    })

    vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
        group = au,
        desc = "[utils/git.lua] stop wather",
        pattern = "*",
        callback = function()
            self:_stop()
        end,
    })

    vim.api.nvim_create_autocmd({ "DirChanged" }, {
        group = au,
        desc = "[utils/git.lua] refresh wathcer",
        pattern = "*",
        callback = function()
            self:_watch(vim.uv.cwd())
        end,
    })
end

---get git root directory, worktree is not supported
---@param path string? path to check
---@return string|nil: root path of git repository, nil if not in git repository
local function git_root(path)
    if path == nil then
        return nil
    end
    path = vim.fn.expand(path)
    if path == nil then
        return nil
    end
    local orig_path = path
    -- recursively check if `.git` directory exists
    while true do
        local git_dir = path .. "/.git"
        if vim.fn.isdirectory(git_dir) == 1 then
            return path
        end
        if path == "/" then
            print("[debug] utils/git_watcher.lua: not git repository: " .. orig_path)
            return nil
        end
        path = vim.fn.fnamemodify(path, ":h")
    end
end

---watch a path for changes, and fetch git status under certain condition
---@param path string path to watch
---@param recursive boolean true if watch recursively
---@param ignore_fn fun(filename: string): boolean function to check filename from fs_event, return true if ignore filename
---@param process_fn fun() function to process on change
---@return uv_fs_event_t?: fs_event handle, nil if failed
local function watch_fs(path, recursive, ignore_fn, process_fn)
    local fs_event = vim.uv.new_fs_event()
    if fs_event == nil then
        vim.notify("[utils/git] failed to create fs_event" .. path)
        return nil
    end

    local success, err_name, _ = fs_event:start(
        path,
        { recursive = recursive },
        function(err, filename, ev)
            if err ~= nil then
                vim.notify("[utils/git] Error in fs_event:" .. err)
                return
            end
            if not ev.change and not ev.rename then
                return
            end
            if ignore_fn(filename) then
                return
            end
            -- print(vim.uv.now() .. "[debug] utils/git_watcher.lua: fs_event: process " .. filename)

            process_fn()
        end
    )
    if not success then
        vim.notify("[utils/git] failed to start fs_event: " .. path .. ": " .. err_name)
        fs_event:stop()
        return nil
    end

    return fs_event
end

---watch a path for changes, and fetch git status under certain condition
---@param path string? path to watch
function G:_watch(path)
    local root = git_root(path)
    if root == nil then
        -- not git repository
        -- force update with callback
        self.cb({})
        -- TODO: gitsigns fixed variable name
        vim.g.gitsigns_head = nil
        -- stop fs_event watcher for non git repository
        self.git_dir = ""
        self:_stop()

        return
    end

    if root == self.git_dir then
        -- same git repository
        return
    end

    -- it's a new git repository,
    -- stop and start new fs_event watcher
    self.git_dir = root

    print("[debug] utils/git_watcher.lua: refresh watcher: " .. root)

    -- stop anyway
    self:_stop()

    self:_async_git_status()

    local process_fn = debounce(2000, function()
        self:_async_git_status()
    end)
    self.fs_event = watch_fs(root, true, function(filename)
        -- ignore path with submodules included
        if string.find(filename, "submodules") ~= nil then
            return true
        end
        -- ignore path with .git included
        if string.find(filename, "%.git") ~= nil then
            return true
        end

        return false
    end, process_fn)

    process_fn = debounce(2000, function()
        self:_async_git_status()
    end)
    self.git_index_event = watch_fs(root .. "/.git/index", false, function(_)
        return false
    end, process_fn)

    process_fn = debounce(2000, function()
        self:_async_git_status()
    end)
    self.git_head_event = watch_fs(root .. "/.git/HEAD", false, function(_)
        return false
    end, process_fn)

    process_fn = debounce(2000, function()
        self:_async_git_status()
    end)
    self.git_refs_event = watch_fs(root .. "/.git/refs", true, function(_)
        return false
    end, process_fn)
end

---process git status, non-blocking
function G:_async_git_status()
    -- the heavy job!
    if self.locked then
        return
    end
    self.locked = true
    vim.system(git_status_cmd, { text = true }, function(obj)
        local stdout = obj.stdout
        local status = {
            n_changed = 0,
        }
        if self.cb ~= nil then
            if stdout ~= nil then
                local lines = vim.split(stdout, "\n")
                status.n_changed = #lines - 1
            end
            self.cb(status)
        end
        self.locked = false
    end)
end

---stop git status polling
---@return nil
function G:_stop()
    if self.fs_event ~= nil then
        self.fs_event:stop()
        if not self.fs_event:is_closing() then
            self.fs_event:close()
        end
    end
    if self.git_head_event ~= nil then
        self.git_head_event:stop()
        if not self.git_head_event:is_closing() then
            self.git_head_event:close()
        end
    end
    if self.git_head_event ~= nil then
        self.git_head_event:stop()
        if not self.git_head_event:is_closing() then
            self.git_head_event:close()
        end
    end
    if self.git_refs_event ~= nil then
        self.git_refs_event:stop()
        if not self.git_refs_event:is_closing() then
            self.git_refs_event:close()
        end
    end
end

return G

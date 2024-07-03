local debounce = require("utils/lua").debounce

---git utility functions
local G = {}
G.__index = G

---shared table for git status
---@class Status
---@field n_changed number? number of changed files

---@class Lock
---@field lock fun() lock the object
---@field unlock fun() unlock the object
---@field locked fun() check if object is locked


---@param cb fun(_:Status) callback function to handle status
function G.new(cb)
    local self = setmetatable({}, G)
    self.locked = false ---@type boolean locked status
    self.fs_event = nil ---@type uv_fs_event_t? fs_event handle
    self.git_index_event = nil ---@type uv_fs_event_t? fs_event handle
    self.git_head_event = nil ---@type uv_fs_event_t? fs_event handle
    self.git_refs_event = nil ---@type uv_fs_event_t? fs_event handle
    self.cb = cb ---@type fun(_:Status) callback function to handle status
    return self
end

local git_status_cmd = { "git", "status", "-s" }

---get git root directory, worktree is not supported
---@param path string? path to check
---@return (string|nil) root path of git repository, nil if not in git repository
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
            print("[utils/git] not git repository: " .. orig_path)
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
---@return uv_fs_event_t? fs_event handle, nil if failed
local function watch_fs(path, recursive, ignore_fn, process_fn)
    local fs_event = vim.uv.new_fs_event()
    if fs_event == nil then
        vim.notify("[utils/git] failed to create fs_event")
        return nil
    end

    local success = fs_event:start(
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
            -- ignore path with .git included
            -- FIXME: one commit will trigger multiple runs

            ---check if filename should be ignored
            ---@return boolean true if filename should be ignored
            local ignore = ignore_fn
            if ignore(filename) then
                return
            end
            -- print(vim.uv.now() .. "[utils/git][debug] fs_event: process " .. filename)

            process_fn()
        end
    )
    if not success then
        vim.notify("[utils/git] failed to start fs_event")
        fs_event:stop()
        return nil
    end

    return fs_event
end

---start git status polling in cwd
---@return nil
function G:start()
    if require("utils.os").is_windows() then
        vim.notify("[utils/git.lua] Windows is not supported")
        return
    end
    self:_watch(vim.uv.cwd())

    -- register autocmd to stop fs_event on VimLeavePre
    local au = vim.api.nvim_create_augroup("utils/git.lua", { clear = true })

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

---watch a path for changes, and fetch git status under certain condition
---@param path string? path to watch
function G:_watch(path)
    -- stop anyway
    self:_stop()

    local root = git_root(path)
    if root == nil then
        -- not git repository
        self.cb({})
        -- TODO: fixed variable name
        vim.g.gitsigns_head = nil
        return
    end

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

    process_fn = require("utils/lua").debounce(2000, function()
        self:_async_git_status()
    end)
    self.git_head_event = watch_fs(root .. "/.git/HEAD", false, function(_)
        return false
    end, process_fn)

    process_fn = require("utils/lua").debounce(2000, function()
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

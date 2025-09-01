local debounce = require("x.helper.lua").debounce

local log_prefix = "customs/git.lua: "

---@param ... string
local function log(...)
    vim.notify(log_prefix .. table.concat(vim.tbl_map(tostring, { ... }), " "))
end

---@param ... string
local function error(...)
    vim.notify(log_prefix .. table.concat(vim.tbl_map(tostring, { ... }), " "), vim.log.levels.ERROR)
end

---git utility functions
local G = {}
G.__index = G

---shared table for git status
---@class GitWatcherStatus
---@field type string? type of git status, e.g. "git_status", "git_head"
---@field n_changed number? number of changed files
---@field branch string? branch name

---@class GitWatcherOptions
---@field enable_git_status boolean? enable git status polling
---@field enable_git_head boolean? enable git head polling

---@param cb fun(_:GitWatcherStatus) callback function to handle status
---@param opts GitWatcherOptions? options for git watcher
function G.new(cb, opts)
    local self = setmetatable({}, G)
    self.locked = false ---@type boolean locked status
    self.git_dir = "" ---@type string git directory
    self.fs_event = nil ---@type uv.uv_fs_event_t? fs_event handle
    self.git_index_event = nil ---@type uv.uv_fs_event_t? fs_event handle
    self.git_head_event = nil ---@type uv.uv_fs_event_t? fs_event handle
    self.git_refs_event = nil ---@type uv.uv_fs_event_t? fs_event handle
    self.cb = cb ---@type fun(_:GitWatcherStatus) callback function to handle status

    ---@type GitWatcherOptions
    self.opts = vim.tbl_deep_extend("force", {
        enable_git_status = false,
        enable_git_head = false,
    }, opts or {})
    return self
end

local git_status_cmd = { "git", "status", "-bsu" } -- TODO: use --porcelain

---start git status polling in cwd
---and register autocmd to stop or refresh fs_event on VimLeavePre and DirChanged
---@return nil
function G:start()
    if require("x.helper.os").is_windows() then
        error("Windows is not supported")
        return
    end

    -- register autocmd to stop fs_event on VimLeavePre
    local au = vim.api.nvim_create_augroup("utils/git.lua", { clear = true })

    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        group = au,
        desc = "[customs/git] start wather",
        pattern = "*",
        callback = function()
            self:_watch(vim.uv.cwd())
        end,
    })

    vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
        group = au,
        desc = "[customs/git] stop wather",
        pattern = "*",
        callback = function()
            self:_stop()
        end,
    })

    vim.api.nvim_create_autocmd({ "DirChanged" }, {
        group = au,
        desc = "[customs/git] refresh wathcer",
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
            -- print("[debug] customs.git.lua: not git repository: " .. orig_path)
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
---@return uv.uv_fs_event_t?: fs_event handle, nil if failed
local function watch_fs(path, recursive, ignore_fn, process_fn)
    local fs_event = vim.uv.new_fs_event()
    if fs_event == nil then
        error("failed to create fs_event" .. path)
        return nil
    end

    local success, err_name, _ = fs_event:start(
        path,
        { recursive = recursive },
        function(err, filename, ev)
            if err ~= nil then
                error("error in fs_event:" .. err)
                return
            end
            if not ev.change and not ev.rename then
                -- print(vim.uv.now() .. "  [debug] customs.git.lua: fs_event: ev " .. vim.inspect(ev))
                return
            end
            if ignore_fn(filename) then
                return
            end
            -- print(vim.uv.now() .. "  [debug] customs.git.lua: fs_event: process " .. filename)

            process_fn()
        end
    )
    if not success then
        error("failed to start fs_event: " .. path .. ": " .. err_name)
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

    -- print("[debug] customs.git.lua: refresh watcher: " .. root)

    -- stop anyway
    self:_stop()

    if self.opts.enable_git_status then self:_async_git_status() end
    if self.opts.enable_git_head then self:_async_git_head() end

    local debounced_git_status = debounce(2000, function()
        self:_async_git_status()
    end)
    local debounced_git_head = debounce(2000, function()
        self:_async_git_head()
    end)
    if self.opts.enable_git_status then
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
        end, debounced_git_status)

        self.git_index_event = watch_fs(root .. "/.git/index", false, function(_)
            return false
        end, debounced_git_status)

        self.git_refs_event = watch_fs(root .. "/.git/refs", true, function(_)
            return false
        end, debounced_git_status)
    end

    if self.opts.enable_git_head then
        self.git_head_event = watch_fs(root .. "/.git", false, function(_)
            return false
        end, debounced_git_head)
        self.git_head_event = watch_fs(root .. "/.git/refs/", false, function(_)
            return false
        end, debounced_git_head)
    end
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
                -- extract branch from first line of `git status -bsu`
                -- e.g. "## main...origin/main" --> "main"
                -- e.g. "## local/branch" --> "local/branch"
                status.branch = lines[1]:match("## ([^%. ]+)")

                status.n_changed = #lines - 2
                ---TODO: add more status
            end
            self.cb(status)
        end
        self.locked = false
    end)
end

---read .git/HEAD, and parse it as branch name
function G:_async_git_head()
    -- print("called async git head")
    -- the heavy job!
    if self.locked then
        return
    end
    self.locked = true

    if self.git_dir == "" then
        self.locked = false
        return
    end

    local head_file = self.git_dir .. "/.git/HEAD"
    vim.system({ "cat", head_file }, { text = true }, function(obj)
        local stdout = obj.stdout
        local status = {}

        if self.cb ~= nil then
            if stdout ~= nil then
                local head_content = vim.trim(stdout)
                -- parse branch from .git/HEAD content
                -- e.g. "ref: refs/heads/main" --> "main"
                -- e.g. "ref: refs/heads/feature/branch" --> "feature/branch"
                local branch = head_content:match("ref: refs/heads/(.+)")
                if branch then
                    status.branch = branch
                else
                    -- detached HEAD state (commit hash)
                    status.branch = head_content:sub(1, 7) -- short hash
                end
            end
            self.cb(status)
        end
        -- print("head lock released")
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
    if self.git_index_event ~= nil then
        self.git_index_event:stop()
        if not self.git_index_event:is_closing() then
            self.git_index_event:close()
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

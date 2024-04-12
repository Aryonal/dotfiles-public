local M = {}

-- REF: https://github.com/nvim-lualine/lualine.nvim/blob/0050b308552e45f7128f399886c86afefc3eb988/lua/lualine/components/filename.lua#L27-L51
---shortens path by turning apple/orange -> a/orange
---@param path string
---@param sep string path separator
---@param max_len integer maximum length of the full filename string
---@return string
function M.shorten_path(path, sep, max_len)
    local len = #path
    if len <= max_len then
        return path
    end

    local segments = vim.split(path, sep)
    for idx = 1, #segments - 1 do
        if len <= max_len then
            break
        end

        local segment = segments[idx]
        local shortened = segment:sub(1, vim.startswith(segment, ".") and 2 or 1)
        segments[idx] = shortened
        len = len - (#segment - #shortened)
    end

    return table.concat(segments, sep)
end

---get current working directory path, and shorten it
---@param l integer maximum length of the full filename string, default 68
---@return string
function M.get_cwd_short(l)
    -- REF: https://github.com/nvim-lualine/lualine.nvim/blob/ad4f4ff7515990b5b2a01bc3933346e11ebf0301/lua/lualine/extensions/nerdtree.lua#L4
    local pth = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
    l = l or 68
    return M.shorten_path(pth, "/", l)
end

---get file path, and shorten it
---@param l integer: maximum length of the full filename string, default 68
---@return string
function M.get_file_path_short(l)
    local pth = vim.fn.expand("%")
    l = l or 68
    return M.shorten_path(pth, "/", l)
end

-- strip_path will remove the leading and trailing slashes, and dots
-- Example:
--  /home/user/.config/nvim -> home/user/.config/nvim
--  ./home/user/.config/nvim -> home/user/.config/nvim
function M.strip_path(path)
    path = string.gsub(path, "^%.", "") -- Remove leading dots
    path = string.gsub(path, "^/*", "") -- Remove leading slashes
    path = string.gsub(path, "/*$", "") -- Remove trailing slashes
    return path
end

---scan_directory will scan the given directory and call the given function for each file
-- fn will be called with the following parameters:
-- - name: string
-- - type: string
-- Example:
-- ```lua
-- scan_directory("/home/user/.config/nvim", function(name, type) print(name, type) end)
-- ```
-- Output:
-- ```
-- init.lua file
-- lua/ directory
-- plugin/ directory
-- ...
-- ```
---@param path string
---@param fn function
function M.scan_directory(path, fn)
    local handle, err = vim.loop.fs_scandir(path)
    if not handle then
        vim.notify("Error: " .. err, vim.log.levels.ERROR)
        return
    end

    while true do
        local name, type, err = vim.loop.fs_scandir_next(handle)
        if not name then
            break
        end
        if err then
            vim.notify("Error: " .. err, vim.log.levels.ERROR)
            break
        end
        if type == "directory" then
            name = name .. "/"
        end

        fn(name, type)
    end

    vim.loop.fs_scandir_close(handle)
end

return M

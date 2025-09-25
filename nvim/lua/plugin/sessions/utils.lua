local M = {}

-- strip_path will remove the leading and trailing slashes, and dots
-- Example:
--  /home/user/.config/nvim -> home/user/.config/nvim
--  ./home/user/.config/nvim -> home/user/.config/nvim
---@param path string: file path to strip
local function strip_path(path)
    path = string.gsub(path, "^/*", "") -- Remove leading slashes
    path = string.gsub(path, "/*$", "") -- Remove trailing slashes
    path = string.gsub(path, "^%.", "") -- Remove leading dots
    return path
end

---path_as_filename will replace slashes with dots
---it's used in scenarios where we want to use the path as a filename
---@param path string: full path to convert
local function path_as_filename(path)
    path = strip_path(path)
    ---TODO: replace `.` with `..`
    return string.gsub(path, "/", ".") -- Replace slashes with dots
end

--- hash will generate a hash from the path, the result will be used as a file name
--- the hash result should be different for each different path
---@param path string: full path to convert
---@return string: hash value
local function hash(path)
    local hash = 5381
    local MOD = 2^32 -- Use a large prime number for modulo to prevent overflow
    for i = 1, #path do
        hash = ((hash * 32) + hash + path:byte(i)) % MOD  -- hash * 33 + c
    end
    return string.format("%x", hash)
end

---get session file path
---@param opts table: option table
---@return string: file path
function M.session_path(opts)
    local session_folder = opts.session_folder or opts.session_folder or vim.fn.stdpath("state") .. "/sessions"
    vim.fn.mkdir(session_folder, "p")
    if vim.fn.isdirectory(session_folder) ~= 1 then
        vim.notify("[Auto Sessions] Failed to create session folder: " .. session_folder)
        return ""
    end

    ---session file name reflects working dir
    local cw = vim.fn.getcwd()
    cw = strip_path(cw)
    local session_file = session_folder .. "/" .. hash(cw) .. ".vim"

    return session_file
end

---Merge two tables into one.
---If elements in a and b share the same key, value from b will overwrite value from a.
---@param a table: the first table to merge.
---@param b table: the second table to merge.
---@return table: the merged table.
function M.merge_tbl(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return {}
    end

    local m = {}
    for k, v in pairs(a) do
        m[k] = v
    end
    for k, v in pairs(b) do
        m[k] = v
    end

    return m
end

function M.save(opts)
    local session_file = M.session_path(opts)
    if session_file == "" then
        return
    end
    vim.cmd(string.format("mksession! %s", session_file))
end

function M.load(opts)
    local session_file = M.session_path(opts)
    if session_file == "" then
        return
    end
    if vim.fn.filereadable(session_file) ~= 1 then
        vim.notify("Session file not exists: " .. session_file)
        return
    end
    vim.cmd(string.format("source %s", session_file))
end

local function get_char_choice(message)
    vim.api.nvim_echo({ { message .. " (y/n): ", "Question" } }, false, {})
    local char = vim.fn.getchar()
    local key = type(char) == "number" and vim.fn.nr2char(char) or char

    vim.api.nvim_echo({}, false, {}) -- Clear the prompt

    return key:lower()
end

---Prompts the user with a yes or no question and returns a corresponding integer value.
---@param prompt string: the prompt message to display to the user.
---@return integer: 0 if the user inputs 'y', 1 if 'n', and 99 for any other input.
function M.input(prompt)
    local choice = get_char_choice(prompt)
    if choice == "y" then
        return 0
    elseif choice == "n" then
        return 1
    else
        return 99
    end
end

return M

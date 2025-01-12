-- print("[debug] Loading utils.loader")
local M = {}

---transform lua chunk to path by replacing . with /
---Example:
--- - "aryon.config" -> "aryon/config/"
--- - "." -> ""
---@param chk string: lua chunk
local function chunk_to_path(chk)
    if chk == "." then
        return ""
    end
    return chk:gsub("%.", "/") .. "/"
end

local function path_to_chunk(path)
    if path == "" then
        return "."
    end
    return path:gsub("%/", ".")
end

---loads all first-level lua modules with a prefix from neovim config
---and returns a list
---files are loaded in alphabetical order
---Example:
--- - load("aryon.config") -> loads all lua files under "/lua/aryon/config", loads "aryon.config.a" if exists, but not "aryon.config.a.b"
--- - load(".") -> loads all files in lua/
---@param chk_prefix string: chunk prefix, e.g. "aryon.config", or "."
---@param recursive boolean?: whether to load recursively
---@return table: list of loaded chunks
function M.load(chk_prefix, recursive)
    recursive = recursive or false
    local dir = chunk_to_path(chk_prefix)
    local chks = {}
    local wc = "/lua/" .. dir .. (recursive and "**/*.lua" or "*.lua")
    local files = vim.api.nvim_get_runtime_file(wc, true)
    -- sort files in alphabetical order
    table.sort(files)
    for _, file in ipairs(files) do
        local prefix_path = vim.fn.stdpath("config") .. "/lua/" .. dir
        local chk_path = file:gsub("//+", "/"):gsub(prefix_path, ""):gsub("%.lua$", "")
        local chk_name = path_to_chunk(chk_path)
        -- print("[debug] utils/loader: chk_name: " .. chk_prefix .. "." .. chk_name .. ", file: " .. file .. ", prefix_path: " .. prefix_path)
        local ok, chk = pcall(require, chk_prefix .. "." .. chk_name)
        if not ok then
            vim.notify("Failed to load file: " .. chk_prefix .. "." .. chk_name)
        else
            table.insert(chks, chk)
        end
    end
    return chks
end

return M

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

---loads all first-level lua files in a directory from neovim config
---and returns a list
---files are loaded in alphabetical order
---@param chk_prefix string: chunk prefix, e.g. "aryon.config", or "."
---@return table: list of loaded chunks
function M.load(chk_prefix)
    local dir = chunk_to_path(chk_prefix)
    local chks = {}
    local files = vim.api.nvim_get_runtime_file("lua/" .. dir .. "*.lua", true)
    -- sort files in alphabetical order
    table.sort(files)
    for _, file in ipairs(files) do
        local chk_name = file:gsub("^.*[\\/]", ""):gsub("%.lua$", "")
        -- vim.notify("Load chunk: " .. chk_prefix .. "." .. chk_name)
        local ok, chk = pcall(require, chk_prefix .. "." .. chk_name)
        if not ok then
            vim.notify("Failed to load file: " .. chk_name)
        else
            table.insert(chks, chk)
        end
    end
    return chks
end

return M

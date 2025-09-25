-- print("[debug] Loading utils.loader")
local M = {}

---Load runtime files, and lua eval
---@param name string: name for vim.api.nvim_get_runtime_file, e.g., file.lua, **/*.lua
---@return table: list of loaded chunks
function M.load(name)
    local files = vim.api.nvim_get_runtime_file(name, true)
    -- sort files in alphabetical order
    local chks = {}
    table.sort(files)
    for _, file in ipairs(files) do
        local prefix_path = vim.fn.stdpath("config") .. "/lua/"
        local chk_path = file:gsub("//+", "/"):gsub(prefix_path, ""):gsub("%.lua$", "")
        local ok, chk = pcall(require, chk_path)
        if not ok then
            vim.notify("Failed to load file: " .. chk_path)
        else
            table.insert(chks, chk)
        end
    end
    return chks
end

return M

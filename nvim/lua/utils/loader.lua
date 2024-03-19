local M = {}

-- load all first-level lua files in a directory from neovim config
-- files are loaded in alphabetical order
function M.load(dir)
    local files = vim.api.nvim_get_runtime_file("lua/" .. dir .. "/*.lua", true)
    -- sort files in alphabetical order
    table.sort(files)
    for _, file in ipairs(files) do
        local module_name = file:gsub("^.*[\\/]", ""):gsub("%.lua$", "")
        -- vim.notify("Load: " .. module_name)
        local ok, _ = pcall(require, dir .. "." .. module_name)
        if not ok then
            vim.notify("Failed to load file: " .. module_name)
        end
    end
end

return M

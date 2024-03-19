local M = {}

-- transform lua chunk to path by replacing . with /
local function chunk_to_path(chk)
    return chk:gsub("%.", "/")
end

-- load all first-level lua files in a directory from neovim config
-- files are loaded in alphabetical order
function M.load(chk_prefix)
    local dir = chunk_to_path(chk_prefix)
    local files = vim.api.nvim_get_runtime_file("lua/" .. dir .. "/*.lua", true)
    -- sort files in alphabetical order
    table.sort(files)
    for _, file in ipairs(files) do
        local chk_name = file:gsub("^.*[\\/]", ""):gsub("%.lua$", "")
        -- vim.notify("Load: " .. chk_prefix .. "." .. chk_name)
        local ok, _ = pcall(require, chk_prefix .. "." .. chk_name)
        if not ok then
            vim.notify("Failed to load file: " .. chk_name)
        end
    end
end

-- load_as_list loads all first-level lua files in a directory from neovim config
-- and returns a list
-- files are loaded in alphabetical order
function M.load_as_list(chk_prefix)
    local dir = chunk_to_path(chk_prefix)
    local chks = {}
    local files = vim.api.nvim_get_runtime_file("lua/" .. dir .. "/*.lua", true)
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
